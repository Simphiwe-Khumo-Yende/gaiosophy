import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/content.dart';
import 'content_list_provider.dart';

/// Simple search query state
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Is search active (non-empty query)
final isSearchActiveProvider = Provider<bool>((ref) {
  final query = ref.watch(searchQueryProvider);
  return query.trim().isNotEmpty;
});

/// Search results provider that uses FirestoreContentRepository
final searchResultsProvider = FutureProvider<List<Content>>((ref) async {
  final query = ref.watch(searchQueryProvider);

  if (query.trim().isEmpty) return <Content>[];

  final repository = ref.watch(firestoreContentRepositoryProvider);
  return repository.searchContent(query);
});
