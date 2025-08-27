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
    _bookmarksBox ??= await Hive.openBox(_bookmarksBoxName);
    _contentBox ??= await Hive.openBox(_contentBoxName);
  }

  // Get bookmarked content IDs
  List<String> getBookmarkedContentIds() {
    return (_bookmarksBox?.get(_bookmarkedIdsKey, defaultValue: <String>[]) as List<dynamic>?)
        ?.cast<String>() ?? [];
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
  }

  // Save content for offline access
  Future<void> _saveContentOffline(String contentId, Content content) async {
    await init();
    
    // Convert content to JSON and save as Map<String, dynamic>
    final contentJson = content.toJson();
    contentJson['savedAt'] = DateTime.now().toIso8601String();
    
    // Store as Map<String, dynamic> to avoid adapter issues
    await _contentBox?.put(contentId, Map<String, dynamic>.from(contentJson));
  }

  // Get saved content
  Future<Content?> getSavedContent(String contentId) async {
    await init();
    
    final contentData = _contentBox?.get(contentId);
    if (contentData == null) return null;
    
    try {
      // Ensure it's a Map<String, dynamic>
      final Map<String, dynamic> jsonData;
      if (contentData is Map<String, dynamic>) {
        jsonData = contentData;
      } else if (contentData is Map) {
        jsonData = Map<String, dynamic>.from(contentData);
      } else {
        // Invalid data format, remove it
        await _contentBox?.delete(contentId);
        return null;
      }
      
      return Content.fromJson(jsonData);
    } catch (e) {
      // If content format is invalid, remove it
      await _contentBox?.delete(contentId);
      return null;
    }
  }

  // Get all saved content
  Future<List<Content>> getAllSavedContent() async {
    await init();
    
    final bookmarkedIds = getBookmarkedContentIds();
    final savedContent = <Content>[];
    
    for (final contentId in bookmarkedIds) {
      final content = await getSavedContent(contentId);
      if (content != null) {
        savedContent.add(content);
      }
    }
    
    return savedContent;
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
}
