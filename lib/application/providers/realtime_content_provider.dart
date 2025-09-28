import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:developer' as developer;
import '../../data/models/content.dart';

/// Real-time content state for streaming updates
class RealTimeContentState {
  const RealTimeContentState({
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.isConnected = true,
  });
  
  final List<Content> items;
  final bool isLoading;
  final Object? error;
  final bool isConnected;

  RealTimeContentState copyWith({
    List<Content>? items,
    bool? isLoading,
    Object? error,
    bool? isConnected,
    bool clearError = false,
  }) => RealTimeContentState(
        items: items ?? this.items,
        isLoading: isLoading ?? this.isLoading,
        error: clearError ? null : error ?? this.error,
        isConnected: isConnected ?? this.isConnected,
      );
}

/// Real-time content notifier that streams updates from Firestore
class RealTimeContentNotifier extends StateNotifier<RealTimeContentState> {
  RealTimeContentNotifier(this._db) : super(const RealTimeContentState()) {
    _startListening();
  }

  final FirebaseFirestore _db;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  void _startListening() {
    state = state.copyWith(isLoading: true, clearError: true);
    
    try {
      // Listen to real-time updates from Firestore
      _subscription = _db
          .collection('content')
          .where('status', isEqualTo: 'published')
          .orderBy('updated_at', descending: true)
          .limit(50) // Reasonable limit for real-time updates
          .snapshots()
          .listen(
            _onDataReceived,
            onError: (Object error, StackTrace stackTrace) =>
                _onError(error, stackTrace: stackTrace),
          );
    } catch (error, stackTrace) {
      _onError(error, stackTrace: stackTrace);
    }
  }

  void _onDataReceived(QuerySnapshot<Map<String, dynamic>> snapshot) {
    try {
      _logSnapshotMetadata(snapshot);
      // Handle document changes for more efficient updates
      final List<Content> newItems = [];
      final List<Content> modifiedItems = [];
      final List<String> removedIds = [];

      for (final change in snapshot.docChanges) {
        final content = Content.fromFirestore(change.doc);
        
        switch (change.type) {
          case DocumentChangeType.added:
            newItems.add(content);
            break;
          case DocumentChangeType.modified:
            modifiedItems.add(content);
            break;
          case DocumentChangeType.removed:
            removedIds.add(content.id);
            break;
        }
      }

      // Update state with changes
      final updatedItems = _applyChanges(
        state.items,
        newItems: newItems,
        modifiedItems: modifiedItems,
        removedIds: removedIds,
      );

      state = state.copyWith(
        items: updatedItems,
        isLoading: false,
        isConnected: true,
        clearError: true,
      );
      if (kDebugMode) {
        developer.log(
          'Applied changes: total=${updatedItems.length} · new=${newItems.length} · modified=${modifiedItems.length} · removed=${removedIds.length}',
          name: 'RealTimeContentNotifier',
        );
      }
    } catch (error, stackTrace) {
      _onError(error, stackTrace: stackTrace);
    }
  }

  void _onError(Object error, {StackTrace? stackTrace}) {
    if (kDebugMode) {
      developer.log(
        'Real-time stream error',
        name: 'RealTimeContentNotifier',
        error: error,
        stackTrace: stackTrace,
      );
    }
    state = state.copyWith(
      error: error,
      isLoading: false,
      isConnected: false,
    );
  }

  List<Content> _applyChanges(
    List<Content> currentItems, {
    required List<Content> newItems,
    required List<Content> modifiedItems,
    required List<String> removedIds,
  }) {
    // Create a map for efficient lookups
    final Map<String, Content> itemMap = {
      for (final item in currentItems) item.id: item
    };

    // Remove deleted items
    for (final id in removedIds) {
      itemMap.remove(id);
    }

    // Add/update modified items
    for (final item in [...newItems, ...modifiedItems]) {
      itemMap[item.id] = item;
    }

    // Convert back to list and sort by updated_at
    final result = itemMap.values.toList();
    result.sort((a, b) {
      final aTime = a.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime = b.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });

    return result;
  }

  /// Refresh the real-time connection
  void refresh() {
    if (kDebugMode) {
      developer.log('Manual refresh requested', name: 'RealTimeContentNotifier');
    }
    _subscription?.cancel();
    _startListening();
  }

  /// Manually trigger a refresh if needed
  Future<void> forceRefresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    
    try {
      final snapshot = await _db
          .collection('content')
          .where('status', isEqualTo: 'published')
          .orderBy('updated_at', descending: true)
          .limit(50)
          .get();

      _logSnapshotMetadata(snapshot);

      final items = snapshot.docs.map(Content.fromFirestore).toList();
      
      state = state.copyWith(
        items: items,
        isLoading: false,
        isConnected: true,
        clearError: true,
      );
    } catch (error, stackTrace) {
      _onError(error, stackTrace: stackTrace);
    }
  }

  void _logSnapshotMetadata(QuerySnapshot<Map<String, dynamic>> snapshot) {
    if (!kDebugMode) {
      return;
    }

    final source = snapshot.metadata.isFromCache ? 'cache' : 'server';
    developer.log(
      'Snapshot from $source · docs=${snapshot.size} · changes=${snapshot.docChanges.length}',
      name: 'RealTimeContentNotifier',
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

/// Provider for real-time content updates
final realTimeContentProvider = StateNotifierProvider<RealTimeContentNotifier, RealTimeContentState>((ref) {
  final db = FirebaseFirestore.instance;
  return RealTimeContentNotifier(db);
});

/// Provider for specific content type real-time updates
final realTimeContentByTypeProvider = StateNotifierProvider.family<RealTimeContentByTypeNotifier, RealTimeContentState, ContentType?>((ref, type) {
  final db = FirebaseFirestore.instance;
  return RealTimeContentByTypeNotifier(db, type);
});

/// Real-time content notifier filtered by type
class RealTimeContentByTypeNotifier extends StateNotifier<RealTimeContentState> {
  RealTimeContentByTypeNotifier(this._db, this._contentType) : super(const RealTimeContentState()) {
    _startListening();
  }

  final FirebaseFirestore _db;
  final ContentType? _contentType;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  void _startListening() {
    state = state.copyWith(isLoading: true, clearError: true);
    
    try {
      final query = _buildQuery();

      _subscription = query
          .orderBy('updated_at', descending: true)
          .limit(50)
          .snapshots()
          .listen(
            _onDataReceived,
            onError: (Object error, StackTrace stackTrace) =>
                _onError(error, stackTrace: stackTrace),
          );
    } catch (error, stackTrace) {
      _onError(error, stackTrace: stackTrace);
    }
  }

  void _onDataReceived(QuerySnapshot<Map<String, dynamic>> snapshot) {
    try {
      if (kDebugMode) {
        final source = snapshot.metadata.isFromCache ? 'cache' : 'server';
        developer.log(
          '[$_contentType] snapshot from $source · docs=${snapshot.size}',
          name: 'RealTimeContentByType',
        );
      }
  final items = snapshot.docs.map(_mapContent).toList();
      
      state = state.copyWith(
        items: items,
        isLoading: false,
        isConnected: true,
        clearError: true,
      );
    } catch (error, stackTrace) {
      _onError(error, stackTrace: stackTrace);
    }
  }

  void _onError(Object error, {StackTrace? stackTrace}) {
    if (kDebugMode) {
      developer.log(
        '[$_contentType] real-time stream error',
        name: 'RealTimeContentByType',
        error: error,
        stackTrace: stackTrace,
      );
    }
    state = state.copyWith(
      error: error,
      isLoading: false,
      isConnected: false,
    );
  }

  void refresh() {
    if (kDebugMode) {
      developer.log('[$_contentType] manual refresh requested', name: 'RealTimeContentByType');
    }
    _subscription?.cancel();
    _startListening();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Query<Map<String, dynamic>> _buildQuery() {
    final collectionName = _collectionPath();
    Query<Map<String, dynamic>> query = _db
        .collection(collectionName)
        .where('status', isEqualTo: 'published');

    if (_contentType == null) {
      return query;
    }

    // Some legacy collections don't store the `type` field, so we rely on the path
    if (_collectionIncludesTypeField()) {
      query = query.where('type', isEqualTo: _getTypeString(_contentType!));
    }

    return query;
  }

  String _collectionPath() {
    if (_contentType == null) {
      return 'content';
    }

    switch (_contentType!) {
      case ContentType.plant:
        return 'content_plant_allies';
      case ContentType.recipe:
        return 'content_recipes';
      case ContentType.seasonal:
        return 'content_seasonal_wisdom';
    }
  }

  bool _collectionIncludesTypeField() {
    // The primary `content` collection contains explicit `type` fields, but
    // legacy collections (content_recipes, etc.) do not. Skip adding the
    // equality filter in that case to avoid empty results.
    return _collectionPath() == 'content';
  }

  String _getTypeString(ContentType type) {
    switch (type) {
      case ContentType.plant:
        return 'plant';
      case ContentType.recipe:
        return 'recipe';
      case ContentType.seasonal:
        return 'seasonal';
    }
  }

  Content _mapContent(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final content = Content.fromFirestore(doc);

    if (_contentType != null && content.type != _contentType) {
      return content.copyWith(type: _contentType!);
    }

    return content;
  }
}