import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/content.dart';
import 'content_list_provider.dart';

class HomeSection {
  HomeSection({required this.title, this.subtitle, required this.items});
  final String title;
  final String? subtitle;
  final List<Content> items;
}

final _dbProvider = firestoreProvider; // alias

Future<List<Content>> _fetchFromCollection(FirebaseFirestore db, String collectionName, ContentType type, {int limit = 10}) async {
  final snap = await db
      .collection(collectionName)
      .orderBy('updated_at', descending: true)
      .limit(limit)
      .get();
  
  // Convert documents to Content objects, setting the appropriate type
  return snap.docs.map((doc) {
    final data = doc.data();
    // Add the type field to match our Content model
    data['type'] = switch (type) { 
      ContentType.plant => 'plant', 
      ContentType.recipe => 'recipe', 
      ContentType.seasonal => 'seasonal' 
    };
    return Content.fromFirestore(doc);
  }).toList();
}

final homeSectionsProvider = FutureProvider<List<HomeSection>>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return [];
  final db = ref.read(_dbProvider);
  
  final results = await Future.wait([
    _fetchFromCollection(db, 'content_seasonal_wisdom', ContentType.seasonal, limit: 12),
    _fetchFromCollection(db, 'content_plant_allies', ContentType.plant, limit: 12),
    _fetchFromCollection(db, 'content_recipes', ContentType.recipe, limit: 12),
  ]);
  
  return [
    HomeSection(title: 'Seasonal Wisdom & Rituals', subtitle: 'Guidance & attunement', items: results[0]),
    HomeSection(title: 'Plant Allies', subtitle: 'Companions in this season', items: results[1]),
    HomeSection(title: 'Seasonal Remedies & Recipes and Crafts', subtitle: 'Kitchen & apothecary', items: results[2]),
  ];
});
