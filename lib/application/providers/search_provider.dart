import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/content.dart';
import 'content_list_provider.dart';

final _dbProvider = firestoreProvider;

/// Provider for search query state
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Provider for search results based on the current query
final searchResultsProvider = FutureProvider<List<Content>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  
  // Return empty list if query is empty or too short
  if (query.trim().isEmpty || query.trim().length < 2) {
    return <Content>[];
  }
  
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return <Content>[];
  
  final db = ref.read(_dbProvider);
  final searchTerm = query.toLowerCase().trim();
  
  // Search across all content collections
  final collections = [
    {'name': 'content_seasonal_wisdom', 'type': ContentType.seasonal},
    {'name': 'content_plant_allies', 'type': ContentType.plant},
    {'name': 'content_recipes', 'type': ContentType.recipe},
  ];
  
  List<Content> allResults = [];
  
  for (final collection in collections) {
    try {
      // Firestore doesn't support case-insensitive search or "contains" queries on text fields,
      // so we'll fetch all documents and filter them client-side for now
      // For better performance in production, consider using Algolia or similar search service
      final snap = await db
          .collection(collection['name'] as String)
          .where('status', isEqualTo: 'Published')
          .orderBy('updated_at', descending: true)
          .limit(100) // Limit to prevent excessive data transfer
          .get();
      
      // Filter results client-side based on title
      final filteredDocs = snap.docs.where((doc) {
        final data = doc.data();
        final title = (data['title'] as String? ?? '').toLowerCase();
        return title.contains(searchTerm);
      }).toList();
      
      // Convert to Content objects
      final contents = filteredDocs.map((doc) {
        final data = doc.data();
        data['type'] = switch (collection['type'] as ContentType) {
          ContentType.plant => 'plant',
          ContentType.recipe => 'recipe', 
          ContentType.seasonal => 'seasonal'
        };
        return Content.fromFirestore(doc);
      }).toList();
      
      allResults.addAll(contents);
    } catch (e) {
      // Continue with other collections if one fails
      print('Error searching in ${collection['name']}: $e');
    }
  }
  
  // Sort by relevance (exact matches first, then by update date)
  allResults.sort((a, b) {
    final aTitle = a.title.toLowerCase();
    final bTitle = b.title.toLowerCase();
    
    // Exact matches first
    final aExact = aTitle == searchTerm;
    final bExact = bTitle == searchTerm;
    if (aExact && !bExact) return -1;
    if (!aExact && bExact) return 1;
    
    // Then by title starts with search term
    final aStarts = aTitle.startsWith(searchTerm);
    final bStarts = bTitle.startsWith(searchTerm);
    if (aStarts && !bStarts) return -1;
    if (!aStarts && bStarts) return 1;
    
    // Finally by update date (most recent first)
    if (a.updatedAt != null && b.updatedAt != null) {
      return b.updatedAt!.compareTo(a.updatedAt!);
    }
    return 0;
  });
  
  return allResults;
});

/// Provider to check if search is currently active
final isSearchActiveProvider = Provider<bool>((ref) {
  final query = ref.watch(searchQueryProvider);
  return query.trim().isNotEmpty && query.trim().length >= 2;
});
