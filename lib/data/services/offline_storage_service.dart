import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/content.dart';

// Providers for offline storage
final offlineStorageServiceProvider = Provider<OfflineStorageService>((ref) {
  return OfflineStorageService();
});

final bookmarkedContentProvider = StreamProvider<List<String>>((ref) {
  final service = ref.watch(offlineStorageServiceProvider);
  return service.watchBookmarkedContentIds();
});

final savedContentProvider = FutureProvider.family<Content?, String>((ref, contentId) {
  final service = ref.watch(offlineStorageServiceProvider);
  return service.getSavedContent(contentId);
});

class OfflineStorageService {
  static const String _bookmarksBoxName = 'bookmarks';
  static const String _contentBoxName = 'saved_content';
  static const String _bookmarkedIdsKey = 'bookmarked_ids';

  Box<dynamic>? _bookmarksBox;
  Box<dynamic>? _contentBox;

  // Initialize boxes
  Future<void> init() async {
    try {
      _bookmarksBox ??= await Hive.openBox(_bookmarksBoxName);
      _contentBox ??= await Hive.openBox(_contentBoxName);
    } catch (e) {
      print('Error initializing offline storage: $e');
      rethrow;
    }
  }

  // Get bookmarked content IDs
  List<String> getBookmarkedContentIds() {
    try {
      final data = _bookmarksBox?.get(_bookmarkedIdsKey, defaultValue: <String>[]);
      if (data is List<dynamic>) {
        return data.cast<String>();
      }
      return <String>[];
    } catch (e) {
      print('Error getting bookmarked IDs: $e');
      return <String>[];
    }
  }

  // Watch bookmarked content IDs
  Stream<List<String>> watchBookmarkedContentIds() async* {
    await init();
    yield getBookmarkedContentIds();
    
    yield* _bookmarksBox!.watch(key: _bookmarkedIdsKey).map((_) {
      return getBookmarkedContentIds();
    });
  }

  // Check if content is bookmarked
  bool isContentBookmarked(String contentId) {
    final bookmarkedIds = getBookmarkedContentIds();
    return bookmarkedIds.contains(contentId);
  }

  // Toggle bookmark status
  Future<bool> toggleBookmark(String contentId, Content content) async {
    await init();
    
    try {
      final bookmarkedIds = getBookmarkedContentIds();
      final isCurrentlyBookmarked = bookmarkedIds.contains(contentId);
      
      if (isCurrentlyBookmarked) {
        // Remove bookmark
        bookmarkedIds.remove(contentId);
        await _contentBox?.delete(contentId);
      } else {
        // Add bookmark
        bookmarkedIds.add(contentId);
        await _saveContentOffline(contentId, content);
      }
      
      await _bookmarksBox?.put(_bookmarkedIdsKey, bookmarkedIds);
      return !isCurrentlyBookmarked;
    } catch (e) {
      print('Error toggling bookmark for $contentId: $e');
      rethrow;
    }
  }

  // Save content for offline access
  Future<void> _saveContentOffline(String contentId, Content content) async {
    await init();
    
    try {
      // Create a simplified version for storage
      final simplifiedContent = {
        'id': content.id,
        'title': content.title,
        'slug': content.slug,
        'type': content.type.name,
        'summary': content.summary,
        'body': content.body,
        'season': content.season,
        'featuredImageId': content.featuredImageId,
        'audioId': content.audioId,
        'templateType': content.templateType,
        'status': content.status,
        'subtitle': content.subtitle,
        'prepTime': content.prepTime,
        'infusionTime': content.infusionTime,
        'difficulty': content.difficulty,
        'published': content.published,
        'tags': content.tags,
        'media': content.media,
        'createdAt': content.createdAt?.toIso8601String(),
        'updatedAt': content.updatedAt?.toIso8601String(),
        'savedAt': DateTime.now().toIso8601String(),
        'contentBlocks': content.contentBlocks.map((block) => {
          'id': block.id,
          'type': block.type,
          'order': block.order,
          'data': {
            'title': block.data.title,
            'subtitle': block.data.subtitle,
            'content': block.data.content,
            'featuredImageId': block.data.featuredImageId,
            'galleryImageIds': block.data.galleryImageIds,
            'listItems': block.data.listItems,
            'listStyle': block.data.listStyle,
            'subBlocks': block.data.subBlocks.map((subBlock) => {
              'id': subBlock.id,
              'plantPartName': subBlock.plantPartName,
              'imageUrl': subBlock.imageUrl,
              'medicinalUses': subBlock.medicinalUses,
              'energeticUses': subBlock.energeticUses,
              'skincareUses': subBlock.skincareUses,
            }).toList(),
          },
          'button': block.button != null ? {
            'action': block.button!.action,
            'show': block.button!.show,
            'text': block.button!.text,
          } : null,
        }).toList(),
      };
      
      await _contentBox?.put(contentId, simplifiedContent);
    } catch (e) {
      print('Error saving content offline: $contentId - $e');
      // Clean up any partial data
      try {
        await _contentBox?.delete(contentId);
      } catch (cleanupError) {
        print('Error during cleanup: $cleanupError');
      }
      rethrow;
    }
  }

  // Get saved content
  Future<Content?> getSavedContent(String contentId) async {
    await init();
    
    try {
      final contentData = _contentBox?.get(contentId);
      if (contentData == null) return null;
      
      // Ensure it's a Map<String, dynamic>
      final Map<String, dynamic> data;
      if (contentData is Map<String, dynamic>) {
        data = contentData;
      } else if (contentData is Map) {
        data = Map<String, dynamic>.from(contentData);
      } else {
        // Invalid data format, remove it
        await _contentBox?.delete(contentId);
        return null;
      }
      
      // Reconstruct Content from simplified data
      final content = Content(
        id: data['id']?.toString() ?? contentId,
        title: data['title']?.toString() ?? '',
        slug: data['slug']?.toString() ?? contentId,
        type: _parseContentType(data['type']?.toString()),
        summary: data['summary']?.toString(),
        body: data['body']?.toString(),
        contentBlocks: <ContentBlock>[], // Empty for offline content
        tags: (data['tags'] as List<dynamic>?)?.cast<String>() ?? <String>[],
        createdAt: data['createdAt'] != null 
          ? DateTime.tryParse(data['createdAt'].toString()) 
          : null,
        updatedAt: data['updatedAt'] != null 
          ? DateTime.tryParse(data['updatedAt'].toString()) 
          : null,
        published: data['published'] as bool? ?? true,
      );
      
      return content;
      
    } catch (e) {
      print('Error reconstructing content for $contentId: $e');
      await _contentBox?.delete(contentId);
      return null;
    }
  }

  // Get all saved content
  Future<List<Content>> getAllSavedContent() async {
    await init();
    
    try {
      final bookmarkedIds = getBookmarkedContentIds();
      final savedContent = <Content>[];
      
      for (final contentId in bookmarkedIds) {
        final content = await getSavedContent(contentId);
        if (content != null) {
          savedContent.add(content);
        }
      }
      
      return savedContent;
    } catch (e) {
      print('Error getting all saved content: $e');
      return <Content>[];
    }
  }

  // Remove bookmark and saved content
  Future<void> removeBookmark(String contentId) async {
    await init();
    
    final bookmarkedIds = getBookmarkedContentIds();
    bookmarkedIds.remove(contentId);
    
    await _bookmarksBox?.put(_bookmarkedIdsKey, bookmarkedIds);
    await _contentBox?.delete(contentId);
  }

  // Clear all bookmarks and saved content
  Future<void> clearAllBookmarks() async {
    await init();
    
    await _bookmarksBox?.clear();
    await _contentBox?.clear();
  }

  // Get storage info
  Future<Map<String, dynamic>> getStorageInfo() async {
    await init();
    
    final bookmarkedIds = getBookmarkedContentIds();
    final savedContentCount = _contentBox?.length ?? 0;
    
    return {
      'bookmarkedCount': bookmarkedIds.length,
      'savedContentCount': savedContentCount,
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }

  // Check if content is available offline
  Future<bool> isContentAvailableOffline(String contentId) async {
    await init();
    return _contentBox?.containsKey(contentId) ?? false;
  }

  // Debug method to check storage status
  Future<void> debugStorageStatus() async {
    if (kDebugMode) {
      await init();
      
      print('=== OFFLINE STORAGE DEBUG ===');
      print('Bookmarks box: ${_bookmarksBox != null ? "✓" : "✗"}');
      print('Content box: ${_contentBox != null ? "✓" : "✗"}');
      
      final bookmarkedIds = getBookmarkedContentIds();
      print('Bookmarked IDs (${bookmarkedIds.length}): $bookmarkedIds');
      
      if (_contentBox != null) {
        print('Saved content keys (${_contentBox!.length}): ${_contentBox!.keys.toList()}');
      }
      
      print('==============================');
    }
  }

  // Helper method to parse ContentType from string
  ContentType _parseContentType(String? typeString) {
    switch (typeString?.toLowerCase()) {
      case 'seasonal':
        return ContentType.seasonal;
      case 'plant':
        return ContentType.plant;
      case 'recipe':
        return ContentType.recipe;
      default:
        return ContentType.plant; // Default fallback
    }
  }
}
