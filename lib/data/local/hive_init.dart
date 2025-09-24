import 'package:hive_flutter/hive_flutter.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  
  try {
    // Open boxes with the exact same names used in OfflineStorageService
    await Hive.openBox<dynamic>('bookmarks');
    await Hive.openBox<dynamic>('saved_content');
  } catch (e) {
    print('Error initializing Hive: $e');
    rethrow;
  }
}
