import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/content.dart';

class FirestoreContentPage {
  FirestoreContentPage(this.items, this.nextCursor);
  final List<Content> items;
  final DocumentSnapshot<Map<String, dynamic>>? nextCursor;
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
    Query<Map<String, dynamic>> q = _db.collection(_collection).where('published', isEqualTo: true);
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
        final data = Map<String, dynamic>.from(doc.data() ?? {});
        
        // Ensure type field is set based on collection name
        if (!data.containsKey('type')) {
          switch (collection) {
            case 'content_seasonal_wisdom':
              data['type'] = 'seasonal';
              break;
            case 'content_plant_allies':
              data['type'] = 'plant';
              break;
            case 'content_recipes':
              data['type'] = 'recipe';
              break;
            default:
              data['type'] ??= 'seasonal';
          }
        }
        
        // Add document ID to data
        data['id'] = doc.id;
        
        // Parse directly using the same logic as fromFirestore but with our modified data
        return _parseContentFromData(doc.id, data);
      }
    }
    
    throw Exception('Content with ID $id not found');
  }

  // Parse content using the same logic as Content.fromFirestore
  Content _parseContentFromData(String docId, Map<String, dynamic> data) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      if (v is Timestamp) return v.toDate();
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      if (v is String) return DateTime.tryParse(v);
      return null;
    }
    
    return Content(
      id: docId,
      type: () {
        final t = data['type'] as String?;
        switch (t) {
          case 'plant':
            return ContentType.plant;
          case 'recipe':
            return ContentType.recipe;
          case 'seasonal':
          default:
            return ContentType.seasonal;
        }
      }(),
      title: data['title'] as String? ?? 'Untitled',
      slug: data['slug'] as String? ?? docId,
      summary: data['summary'] as String? ?? data['excerpt'] as String?,
      body: data['body'] as String? ?? data['content'] as String?,
      season: data['season'] as String?,
      featuredImageId: data['featured_image_id'] as String?,
      templateType: data['template_type'] as String?,
      status: data['status'] as String?,
      published: data['published'] as bool? ?? (data['status'] == 'published'),
      tags: (data['tags'] as List?)?.whereType<String>().toList() ?? const [],
      media: (data['media'] as List?)?.whereType<String>().toList() ?? const [],
      contentBlocks: () {
        final blocks = data['content_blocks'] as List?;
        if (blocks == null) return <ContentBlock>[];
        return blocks
            .whereType<Map<String, dynamic>>()
            .map((blockData) => ContentBlock(
                  id: blockData['id'] as String? ?? '',
                  type: blockData['type'] as String? ?? 'text',
                  order: blockData['order'] as int? ?? 0,
                  data: ContentBlockData(
                    title: blockData['data']?['title'] as String?,
                    subtitle: blockData['data']?['subtitle'] as String?,
                    content: blockData['data']?['content'] as String?,
                    featuredImageId: blockData['data']?['featured_image_id'] as String?,
                    galleryImageIds: (blockData['data']?['gallery_image_ids'] as List?)
                            ?.whereType<String>()
                            .toList() ??
                        const [],
                  ),
                  button: () {
                    final buttonData = blockData['data']?['button'] as Map<String, dynamic>?;
                    if (buttonData == null) return null;
                    return ContentBlockButton(
                      action: buttonData['action'] as String? ?? 'next',
                      show: buttonData['show'] as bool? ?? false,
                      text: buttonData['text'] as String? ?? '',
                    );
                  }(),
                ))
            .toList();
      }(),
      createdAt: parseDate(data['created_at'] ?? data['createdAt']),
      updatedAt: parseDate(data['updated_at'] ?? data['updatedAt']),
    );
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
