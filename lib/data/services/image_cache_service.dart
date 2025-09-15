import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

// Provider for image cache service
final imageCacheServiceProvider = Provider<ImageCacheService>((ref) {
  return ImageCacheService();
});

class ImageCacheService {
  static const _storage = FlutterSecureStorage();
  static const String _urlCacheKey = 'firebase_image_urls';
  
  // In-memory cache for this session
  final Map<String, String> _memoryCache = {};
  
  // Cache duration (24 hours)
  static const Duration _cacheDuration = Duration(hours: 24);

  /// Get image URL with caching support
  Future<String?> getImageUrl(String imageId) async {
    try {
      // Check memory cache first
      if (_memoryCache.containsKey(imageId)) {
        return _memoryCache[imageId];
      }

      // Check persistent cache
      final cachedUrl = await _getCachedUrl(imageId);
      if (cachedUrl != null) {
        _memoryCache[imageId] = cachedUrl;
        return cachedUrl;
      }

      // Fetch from Firebase Storage
      final url = await _fetchFromFirebase(imageId);
      if (url != null) {
        // Cache the URL
        await _cacheUrl(imageId, url);
        _memoryCache[imageId] = url;
        return url;
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print('ImageCacheService error for $imageId: $e');
      }
      // Return cached URL if available, even if expired
      return await _getCachedUrl(imageId, ignoreExpiry: true);
    }
  }

  /// Fetch image URL from Firebase Storage
  Future<String?> _fetchFromFirebase(String imageId) async {
    try {
      // Ensure we're signed in (anonymous) so storage rules that require auth pass
      if (FirebaseAuth.instance.currentUser == null) {
        await FirebaseAuth.instance.signInAnonymously();
      }

      // Try different extensions
      final extensions = ['webp', 'png', 'jpg', 'jpeg'];
      for (final ext in extensions) {
        final path = 'media/content-images/$imageId.$ext';
        try {
          final url = await FirebaseStorage.instance
              .ref()
              .child(path)
              .getDownloadURL();
          return url;
        } catch (e) {
          // Try next extension
          continue;
        }
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Firebase fetch error for $imageId: $e');
      }
      return null;
    }
  }

  /// Get URL from persistent cache
  Future<String?> _getCachedUrl(String imageId, {bool ignoreExpiry = false}) async {
    try {
      final cacheData = await _storage.read(key: _urlCacheKey);
      if (cacheData == null) return null;

      final Map<String, dynamic> cache = json.decode(cacheData);
      final imageData = cache[imageId];
      if (imageData == null) return null;

      final cachedAt = DateTime.parse(imageData['cachedAt']);
      final url = imageData['url'] as String;

      // Check if cache is still valid (unless ignoring expiry)
      if (!ignoreExpiry && DateTime.now().difference(cachedAt) > _cacheDuration) {
        // Cache expired, remove it
        cache.remove(imageId);
        await _storage.write(key: _urlCacheKey, value: json.encode(cache));
        return null;
      }

      return url;
    } catch (e) {
      if (kDebugMode) {
        print('Cache read error for $imageId: $e');
      }
      return null;
    }
  }

  /// Cache URL persistently
  Future<void> _cacheUrl(String imageId, String url) async {
    try {
      final cacheData = await _storage.read(key: _urlCacheKey) ?? '{}';
      final Map<String, dynamic> cache = json.decode(cacheData);
      
      cache[imageId] = {
        'url': url,
        'cachedAt': DateTime.now().toIso8601String(),
      };

      await _storage.write(key: _urlCacheKey, value: json.encode(cache));
    } catch (e) {
      if (kDebugMode) {
        print('Cache write error for $imageId: $e');
      }
    }
  }

  /// Preload image URLs for a list of image IDs
  Future<void> preloadImageUrls(List<String> imageIds) async {
    // Process in batches to avoid overwhelming Firebase
    const batchSize = 5;
    for (int i = 0; i < imageIds.length; i += batchSize) {
      final batch = imageIds.skip(i).take(batchSize).toList();
      await Future.wait(
        batch.map((imageId) => getImageUrl(imageId)),
      );
      // Small delay between batches
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  /// Clear expired cache entries
  Future<void> clearExpiredCache() async {
    try {
      final cacheData = await _storage.read(key: _urlCacheKey);
      if (cacheData == null) return;

      final Map<String, dynamic> cache = json.decode(cacheData);
      final now = DateTime.now();
      
      // Remove expired entries
      cache.removeWhere((key, value) {
        try {
          final cachedAt = DateTime.parse(value['cachedAt']);
          return now.difference(cachedAt) > _cacheDuration;
        } catch (e) {
          return true; // Remove invalid entries
        }
      });

      await _storage.write(key: _urlCacheKey, value: json.encode(cache));
    } catch (e) {
      if (kDebugMode) {
        print('Cache cleanup error: $e');
      }
    }
  }

  /// Clear all cached URLs
  Future<void> clearAllCache() async {
    try {
      await _storage.delete(key: _urlCacheKey);
      _memoryCache.clear();
    } catch (e) {
      if (kDebugMode) {
        print('Cache clear error: $e');
      }
    }
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStats() async {
    try {
      final cacheData = await _storage.read(key: _urlCacheKey);
      if (cacheData == null) {
        return {
          'totalCached': 0,
          'memoryCache': _memoryCache.length,
          'cacheSize': 0,
        };
      }

      final Map<String, dynamic> cache = json.decode(cacheData);
      return {
        'totalCached': cache.length,
        'memoryCache': _memoryCache.length,
        'cacheSize': cacheData.length,
      };
    } catch (e) {
      return {
        'totalCached': 0,
        'memoryCache': _memoryCache.length,
        'cacheSize': 0,
        'error': e.toString(),
      };
    }
  }
}