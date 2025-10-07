import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/content.dart';

class FirestoreContentPage {
  FirestoreContentPage(this.items, this.nextCursor);
  final List<Content> items;
  final DocumentSnapshot<Map<String, dynamic>>? nextCursor;
}

Content parseContentFromData(
  String docId,
  Map<String, dynamic> data, {
  String? collectionHint,
}) {
  DateTime? parseDate(dynamic v) {
    if (v == null) return null;
    if (v is Timestamp) return v.toDate();
    if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
    if (v is String) return DateTime.tryParse(v);
    return null;
  }

  ContentType resolveType() {
    final typeValue = data['type'] as String?;
    switch (typeValue) {
      case 'plant':
        return ContentType.plant;
      case 'recipe':
        return ContentType.recipe;
      case 'seasonal':
        return ContentType.seasonal;
    }

    switch (collectionHint) {
      case 'content_plant_allies':
        return ContentType.plant;
      case 'content_recipes':
        return ContentType.recipe;
      case 'content_seasonal_wisdom':
        return ContentType.seasonal;
    }

    return ContentType.seasonal;
  }

  final type = resolveType();

  return Content(
    id: docId,
    type: type,
    title: data['title'] as String? ?? 'Untitled',
    slug: data['slug'] as String? ?? docId,
    summary: data['summary'] as String? ?? data['excerpt'] as String?,
    body: data['body'] as String? ?? data['content'] as String?,
    season: data['season'] as String?,
    featuredImageId: data['featured_image_id'] as String?,
    audioId: data['audio_id'] as String?,
    templateType: data['template_type'] as String?,
    status: data['status'] as String?,
    subtitle: data['subtitle'] as String?,
    prepTime: data['prep_time'] as String?,
    infusionTime: data['infusion_time'] as String?,
    difficulty: data['difficulty'] as String?,
    ritual: data['ritual'] as bool?,
    published: data['published'] as bool? ?? (data['status'] == 'published'),
    tags: (data['tags'] as List?)?.whereType<String>().toList() ?? const [],
    media: (data['media'] as List?)?.whereType<String>().toList() ?? const [],
  linkedRecipeIds:
    (data['linked_recipe_ids'] as List?)?.whereType<String>().toList() ??
      const [],
    contentBlocks: () {
      final blocks = data['content_blocks'] as List?;
      if (blocks == null) return <ContentBlock>[];

      return blocks
          .whereType<Map<String, dynamic>>()
          .map((blockData) {
            final blockMap = Map<String, dynamic>.from(blockData);
            final dataMap = Map<String, dynamic>.from(blockMap['data'] as Map<String, dynamic>? ?? {});

            final subBlocks = (dataMap['sub_blocks'] as List?)
                    ?.whereType<Map<String, dynamic>>()
                    .map((subBlockData) => SubBlock(
                          id: subBlockData['id'] as String?,
                          plantPartName: subBlockData['plant_part_name'] as String?,
                          imageUrl: subBlockData['image_url'] as String?,
                          medicinalUses: (subBlockData['medicinal_uses'] as List?)
                                  ?.whereType<String>()
                                  .toList() ??
                              const [],
                          energeticUses: (subBlockData['energetic_uses'] as List?)
                                  ?.whereType<String>()
                                  .toList() ??
                              const [],
                          skincareUses: (subBlockData['skincare_uses'] as List?)
                                  ?.whereType<String>()
                                  .toList() ??
                              const [],
                        ))
                    .toList() ??
                const <SubBlock>[];

            return ContentBlock(
              id: blockMap['id'] as String? ?? '',
              type: blockMap['type'] as String? ?? 'text',
              order: blockMap['order'] as int? ?? 0,
              data: ContentBlockData(
                title: dataMap['title'] as String?,
                subtitle: dataMap['subtitle'] as String?,
                content: dataMap['content'] as String?,
                featuredImageId: dataMap['featured_image_id'] as String?,
                galleryImageIds: (dataMap['gallery_image_ids'] as List?)
                        ?.whereType<String>()
                        .toList() ??
                    const [],
                subBlocks: subBlocks,
                listItems: (dataMap['list_items'] as List?)
                        ?.whereType<String>()
                        .toList() ??
                    const [],
                listStyle: dataMap['list_style'] as String?,
              ),
              button: () {
                final buttonData = dataMap['button'] as Map<String, dynamic>?;
                if (buttonData == null) return null;
                return ContentBlockButton(
                  action: buttonData['action'] as String? ?? 'next',
                  show: buttonData['show'] as bool? ?? false,
                  text: buttonData['text'] as String? ?? '',
                );
              }(),
              audioId: dataMap['audio_id'] as String?,
              audioAutoPlay: dataMap['audio_auto_play'] as bool? ?? false,
              audioTranscript: dataMap['audio_transcript'] as String?,
              showAudioTranscript: dataMap['show_audio_transcript'] as bool? ?? false,
            );
          })
          .toList();
    }(),
    createdAt: parseDate(data['created_at'] ?? data['createdAt']),
    updatedAt: parseDate(data['updated_at'] ?? data['updatedAt']),
  );
}

Content parseContentSnapshot(
  DocumentSnapshot<Map<String, dynamic>> doc, {
  String? collectionHint,
}) {
  final data = Map<String, dynamic>.from(doc.data() ?? {});
  data['id'] = doc.id;
  return parseContentFromData(doc.id, data, collectionHint: collectionHint ?? doc.reference.parent.id);
}

class FirestoreContentRepository {
  FirestoreContentRepository(this._db);
  final FirebaseFirestore _db;
  static const _collection = 'content';

  Future<FirestoreContentPage> fetchPage({
    int limit = 20,
    ContentType? type,
    String? season,
    String? tag,
    String? query,
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
  }) async {
    Query<Map<String, dynamic>> q = _db.collection(_collection).where('status', isEqualTo: 'published');
    if (type != null) {
      q = q.where('type', isEqualTo: _typeString(type));
    }
    if (season != null) {
      q = q.where('season', isEqualTo: season);
    }
    if (tag != null) {
      q = q.where('tags', arrayContains: tag);
    }
    if (query != null && query.trim().isNotEmpty) {
      final qLower = query.toLowerCase();
      q = q.where('keywords', arrayContains: qLower);
    }
    q = q.orderBy('updated_at', descending: true).limit(limit);
    if (startAfter != null) q = q.startAfterDocument(startAfter);
    final snap = await q.get();
    final items = snap.docs.map(Content.fromFirestore).toList();
    final nextCursor = snap.docs.isNotEmpty && snap.docs.length == limit ? snap.docs.last : null;
    return FirestoreContentPage(items, nextCursor);
  }

  Future<Content> fetchById(String id) async {
    // List of all content collections to search
    final collections = ['content', 'content_seasonal_wisdom', 'content_plant_allies', 'content_recipes'];
    
    for (final collection in collections) {
      final doc = await _db.collection(collection).doc(id).get();
      if (doc.exists) {
        return parseContentSnapshot(doc, collectionHint: collection);
      }
    }
    
    throw Exception('Content with ID $id not found');
  }

  Future<List<Content>> searchContent(String query) async {
    if (query.trim().isEmpty) return [];
    
    final qLower = query.toLowerCase();
    
    // Search across all content collections
    final collections = ['content', 'content_seasonal_wisdom', 'content_plant_allies', 'content_recipes'];
    final List<Content> allResults = [];
    
    for (final collection in collections) {
      try {
        // Search by title and summary (no keywords field dependency)
        final allDocs = await _db.collection(collection)
            .where('status', isEqualTo: 'published')  // Use lowercase 'published'
            .limit(50)
            .get();
            
        for (final doc in allDocs.docs) {
          final data = Map<String, dynamic>.from(doc.data());
          final title = (data['title'] as String? ?? '').toLowerCase();
          final summary = (data['summary'] as String? ?? '').toLowerCase();
          final body = (data['body'] as String? ?? data['content'] as String? ?? '').toLowerCase();
          final tags = (data['tags'] as List?)?.whereType<String>().map((t) => t.toLowerCase()).toList() ?? <String>[];
          
          // Check if query matches title, summary, body, or tags
          if (title.contains(qLower) || 
              summary.contains(qLower) || 
              body.contains(qLower) ||
              tags.any((tag) => tag.contains(qLower))) {
            
            // Ensure type field is set based on collection name
            allResults.add(parseContentFromData(doc.id, data, collectionHint: collection));
          }
        }
      } catch (e) {
        // Continue with other collections if one fails
        print('Error searching collection $collection: $e');
        continue;
      }
    }
    
    // Remove duplicates and sort by relevance (title matches first, then summary)
    final uniqueResults = <String, Content>{};
    for (final content in allResults) {
      if (!uniqueResults.containsKey(content.id)) {
        uniqueResults[content.id] = content;
      }
    }
    
    final results = uniqueResults.values.toList();
    results.sort((a, b) {
      final aTitle = a.title.toLowerCase();
      final bTitle = b.title.toLowerCase();
      final aTitleMatch = aTitle.contains(qLower) ? 1 : 0;
      final bTitleMatch = bTitle.contains(qLower) ? 1 : 0;
      
      // Title matches come first
      if (aTitleMatch != bTitleMatch) {
        return bTitleMatch.compareTo(aTitleMatch);
      }
      
      // Then alphabetical
      return aTitle.compareTo(bTitle);
    });
    
    return results.take(20).toList();
  }

  String _typeString(ContentType t) {
    switch (t) {
      case ContentType.plant:
        return 'plant';
      case ContentType.recipe:
        return 'recipe';
      case ContentType.seasonal:
        return 'seasonal';
    }
  }
}
