import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityStreamProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  final connectivity = Connectivity();
  final controller = StreamController<List<ConnectivityResult>>();
  connectivity.checkConnectivity().then(controller.add);
  final sub = connectivity.onConnectivityChanged.listen(controller.add);
  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });
  return controller.stream;
});

final isOfflineProvider = Provider<bool>((ref) {
  final isOffline = ref.watch(connectivityStreamProvider).maybeWhen(
        data: (results) => results.isEmpty || results.every((r) => r == ConnectivityResult.none),
        orElse: () => true, // Assume offline if we can't determine connectivity
      );
  return isOffline;
});
