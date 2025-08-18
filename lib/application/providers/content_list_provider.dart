import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/content.dart';
import '../../data/repositories/firestore_content_repository.dart';

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
  ContentListNotifier(this._repo) : super(const PaginatedContentState());
  final FirestoreContentRepository _repo;

  Future<void> loadNext({ContentType? type}) async {
    if (state.isLoading || !state.hasMore) return;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final page = await _repo.fetchPage(
        startAfter: state.cursor,
        type: type,
      );
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
}

final firestoreProvider = Provider<FirebaseFirestore>((_) => FirebaseFirestore.instance);

final firestoreContentRepositoryProvider = Provider<FirestoreContentRepository>((ref) {
  final db = ref.read(firestoreProvider);
  return FirestoreContentRepository(db);
});

final contentListProvider = StateNotifierProvider<ContentListNotifier, PaginatedContentState>((ref) {
  final repo = ref.watch(firestoreContentRepositoryProvider);
  return ContentListNotifier(repo);
});

final contentDetailProvider = FutureProvider.family<Content, String>((ref, id) async {
  final repo = ref.watch(firestoreContentRepositoryProvider);
  return repo.fetchById(id);
});
