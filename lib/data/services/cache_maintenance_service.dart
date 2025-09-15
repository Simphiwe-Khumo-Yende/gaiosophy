import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../services/image_cache_service.dart';

// Provider for cache maintenance service
final cacheMaintenanceProvider = Provider<CacheMaintenanceService>((ref) {
  final imageCacheService = ref.watch(imageCacheServiceProvider);
  return CacheMaintenanceService(imageCacheService);
});

class CacheMaintenanceService {
  CacheMaintenanceService(this._imageCacheService) {
    _startPeriodicCleanup();
  }

  final ImageCacheService _imageCacheService;
  Timer? _cleanupTimer;

  /// Start periodic cache cleanup (every 6 hours)
  void _startPeriodicCleanup() {
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer.periodic(const Duration(hours: 6), (_) {
      _imageCacheService.clearExpiredCache();
    });
  }

  /// Manually trigger cache cleanup
  Future<void> cleanupCache() async {
    await _imageCacheService.clearExpiredCache();
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStats() async {
    return await _imageCacheService.getCacheStats();
  }

  /// Clear all cached data
  Future<void> clearAllCache() async {
    await _imageCacheService.clearAllCache();
  }

  void dispose() {
    _cleanupTimer?.cancel();
  }
}