import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/content.dart';

/// A simple content repository used by the search provider.
class ContentRepository {
  Future<List<Content>> searchContent(String query) async {
    final q = query.toLowerCase().trim();

    // Simulate small delay as if fetching from network/local DB
    await Future.delayed(const Duration(milliseconds: 150));

    final all = await _getMockContent();

    return all.where((c) {
      final title = c.title.toLowerCase();
      final summary = (c.summary ?? '').toLowerCase();
      final body = (c.body ?? '').toLowerCase();
      final tags = (c.tags).map((t) => t.toLowerCase()).toList();

      if (title.contains(q)) return true;
      if (summary.contains(q)) return true;
      if (body.contains(q)) return true;
      if (tags.any((t) => t.contains(q))) return true;
      return false;
    }).toList();
  }

  Future<List<Content>> _getMockContent() async {
    return [
      Content(
        id: '1',
        type: ContentType.plant,
        title: 'Elder',
        slug: 'elder',
        summary: 'A powerful plant ally for immune support and protection',
        body: 'Elderberry and related uses',
        tags: ['elder', 'elderberry', 'immune support', 'autumn'],
        published: true,
      ),
      Content(
        id: '2',
        type: ContentType.plant,
        title: 'Bramble',
        slug: 'bramble',
        summary: 'Wild blackberry with medicinal leaves and berries',
        tags: ['bramble', 'blackberry', 'digestive'],
        published: true,
      ),
      Content(
        id: '3',
        type: ContentType.seasonal,
        title: 'Autumn Equinox',
        slug: 'autumn-equinox',
        summary: 'Balance and harvest celebrations',
        tags: ['autumn', 'equinox', 'seasonal', 'ritual'],
        published: true,
      ),
      Content(
        id: '4',
        type: ContentType.seasonal,
        title: 'Water Ceremony',
        slug: 'water-ceremony',
        summary: 'Sacred water rituals for cleansing and renewal',
        tags: ['water', 'ceremony', 'ritual', 'cleansing'],
        published: true,
      ),
      Content(
        id: '5',
        type: ContentType.recipe,
        title: 'Elderberry Syrup',
        slug: 'elderberry-syrup',
        summary: 'Traditional immune-boosting syrup recipe',
        tags: ['elderberry', 'syrup', 'recipe', 'immune support'],
        published: true,
      ),
    ];
  }
}

final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  return ContentRepository();
});
// Legacy REST ContentRepository removed after migration to Firestore.
// File retained temporarily to avoid stale imports breaking incremental builds.
// Safe to delete once no references remain in the codebase or tests.
