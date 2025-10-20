import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/app_config.dart';
import '../../data/repositories/app_config_repository.dart';

final appConfigRepositoryProvider = Provider<AppConfigRepository>((ref) {
  return AppConfigRepository(FirebaseFirestore.instance);
});

final appConfigStreamProvider = StreamProvider<AppConfig>((ref) {
  final repository = ref.watch(appConfigRepositoryProvider);
  return repository.watchAppConfig();
});

final appConfigProvider = Provider<AppConfig>((ref) {
  final asyncConfig = ref.watch(appConfigStreamProvider);
  return asyncConfig.maybeWhen(
    data: (config) => config,
    orElse: () => const AppConfig(),
  );
});
