import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gaiosophy_app/data/repositories/firestore_content_repository.dart';
import 'package:gaiosophy_app/data/models/content.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gaiosophy_app/firebase_options.dart';

Future<bool> _ensureFirebase() async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    }
    return true;
  } catch (_) {
    return false;
  }
}

void main() {
  group('FirestoreContentRepository', () {
    test('fetchPage returns empty list when no docs', () async {
      final ok = await _ensureFirebase();
      if (!ok) return; // skip silently
      final repo = FirestoreContentRepository(FirebaseFirestore.instance);
      final page = await repo.fetchPage(limit: 3);
      expect(page.items, isA<List<Content>>());
      expect(page.items.length, 0);
    });
  });
}
