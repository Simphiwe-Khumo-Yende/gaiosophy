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
    final doc = await _db.collection(_collection).doc(id).get();
    if (!doc.exists) {
      throw Exception('Content with ID $id not found');
    }
    return Content.fromFirestore(doc);
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
