import 'package:hive_flutter/hive_flutter.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  // Register adapters here when created
  // await Hive.openBox('tokens');
  await Hive.openBox('saved_content');
  await Hive.openBox('bookmarks');
  // await Hive.openBox('config');
}
