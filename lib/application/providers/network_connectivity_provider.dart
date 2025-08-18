import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityStreamProvider = StreamProvider<ConnectivityResult>((ref) {
  final connectivity = Connectivity();
  final controller = StreamController<ConnectivityResult>();
  connectivity.checkConnectivity().then(controller.add);
  final sub = connectivity.onConnectivityChanged.listen(controller.add);
  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });
  return controller.stream;
});

final isOfflineProvider = Provider<bool>((ref) {
  final connectivity = ref.watch(connectivityStreamProvider).maybeWhen(
        data: (r) => r,
        orElse: () => ConnectivityResult.none,
      );
  return connectivity == ConnectivityResult.none;
});
