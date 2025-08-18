import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/hive_init.dart';

/// Performs lightweight startup initialization (local stores, etc.).
/// Remote config & season now sourced from Firestore directly via providers (TBD).
final bootstrapProvider = FutureProvider<void>((ref) async {
  await initHive();
});
