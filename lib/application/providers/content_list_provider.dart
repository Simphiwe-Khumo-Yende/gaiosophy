import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/content.dart';
import '../../data/repositories/firestore_content_repository.dart';
import '../../data/services/offline_storage_service.dart';
import '../../data/services/image_cache_service.dart';
import 'network_connectivity_provider.dart';

class PaginatedContentState {
  const PaginatedContentState({
    this.items = const [],
    this.isLoading = false,
    this.cursor,
    this.hasMore = true,
    this.error,
  });
  final List<Content> items;
  final bool isLoading;
  final DocumentSnapshot<Map<String, dynamic>>? cursor;
  final bool hasMore;
  final Object? error;

  PaginatedContentState copyWith({
    List<Content>? items,
    bool? isLoading,
    DocumentSnapshot<Map<String, dynamic>>? cursor,
    bool? hasMore,
    Object? error,
    bool clearError = false,
  }) => PaginatedContentState(
        items: items ?? this.items,
        isLoading: isLoading ?? this.isLoading,
        cursor: cursor ?? this.cursor,
        hasMore: hasMore ?? this.hasMore,
        error: clearError ? null : error ?? this.error,
      );
}

class ContentListNotifier extends StateNotifier<PaginatedContentState> {
  ContentListNotifier(this._repo, this._imageCacheService) : super(const PaginatedContentState());
  final FirestoreContentRepository _repo;
  final ImageCacheService _imageCacheService;

  Future<void> loadNext({ContentType? type}) async {
    if (state.isLoading || !state.hasMore) return;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final page = await _repo.fetchPage(
        startAfter: state.cursor,
        type: type,
      );
      
      // Preload images for the new content
      _preloadImages(page.items);
      
      state = state.copyWith(
        items: [...state.items, ...page.items],
        cursor: page.nextCursor,
        hasMore: page.nextCursor != null,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  Future<void> refresh({ContentType? type}) async {
    state = const PaginatedContentState();
    await loadNext(type: type);
  }

  /// Preload images for content in the background
  void _preloadImages(List<Content> content) {
    final imageIds = <String>[];
    for (final item in content) {
      // Add featured image
      if (item.featuredImageId?.isNotEmpty == true) {
        imageIds.add(item.featuredImageId!);
      }
      
      // Add content block images
      for (final block in item.contentBlocks) {
        if (block.data.featuredImageId?.isNotEmpty == true) {
          imageIds.add(block.data.featuredImageId!);
        }
      }
    }
    
    // Preload images asynchronously (don't wait for completion)
    if (imageIds.isNotEmpty) {
      _imageCacheService.preloadImageUrls(imageIds);
    }
  }
}

final firestoreProvider = Provider<FirebaseFirestore>((_) => FirebaseFirestore.instance);

// Repository provider for Firestore content operations
final firestoreContentRepositoryProvider = Provider<FirestoreContentRepository>((ref) {
  final db = ref.read(firestoreProvider);
  return FirestoreContentRepository(db);
});

// Provider for paginated content lists with caching
final contentListProvider = StateNotifierProvider<ContentListNotifier, PaginatedContentState>((ref) {
  final repo = ref.watch(firestoreContentRepositoryProvider);
  final imageCacheService = ref.watch(imageCacheServiceProvider);
  return ContentListNotifier(repo, imageCacheService);
});

// Fallback provider for single content items with offline support
final contentDetailProvider = FutureProvider.family<Content, String>((ref, id) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception('Please sign in to view content');
  }
  
  final isOffline = ref.watch(isOfflineProvider);
  final offlineService = ref.watch(offlineStorageServiceProvider);
  
  // If offline, try to get content from offline storage first
  if (isOffline) {
    final offlineContent = await offlineService.getSavedContent(id);
    if (offlineContent != null) {
      return offlineContent;
    }
    throw Exception('Content not available offline. Please connect to the internet.');
  }
  
  // If online, try Firestore first, with offline fallback
  try {
    final repo = ref.watch(firestoreContentRepositoryProvider);
    final content = await repo.fetchById(id);
    return content;
  } catch (e) {
    if (e.toString().contains('permission-denied')) {
      throw Exception('Access denied. Please check your login status.');
    }
    
    // Network error or other issue - try offline content as fallback
    final offlineContent = await offlineService.getSavedContent(id);
    if (offlineContent != null) {
      return offlineContent;
    }
    
    rethrow;
  }
});

// Real-time provider for content with automatic updates
final realTimeContentDetailProvider = StreamProvider.family<Content?, String>((ref, id) async* {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception('Please sign in to view content');
  }

  final firestore = ref.read(firestoreProvider);
  const collections = [
    'content',
    'content_seasonal_wisdom',
    'content_plant_allies',
    'content_recipes',
  ];

  DocumentReference<Map<String, dynamic>>? docRef;
  String? collectionName;

  for (final collection in collections) {
    try {
      final doc = await firestore.collection(collection).doc(id).get();
      if (doc.exists) {
        docRef = doc.reference;
        collectionName = collection;
        if (kDebugMode) {
          developer.log(
            'Resolved $id to collection $collection',
            name: 'RealTimeContentDetailProvider',
          );
        }
        break;
      }
    } catch (error, stackTrace) {
      if (kDebugMode) {
        developer.log(
          'Error resolving $id in $collection',
          name: 'RealTimeContentDetailProvider',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
  }

  if (docRef == null || collectionName == null) {
    if (kDebugMode) {
      developer.log(
        'Content $id not found in any collection',
        name: 'RealTimeContentDetailProvider',
      );
    }
    yield null;
    return;
  }

  yield* docRef.snapshots().map((snapshot) {
    if (!snapshot.exists) {
      if (kDebugMode) {
        developer.log(
          'Snapshot for $id no longer exists in $collectionName',
          name: 'RealTimeContentDetailProvider',
        );
      }
      return null;
    }

    return parseContentSnapshot(snapshot, collectionHint: collectionName);
  });
});
