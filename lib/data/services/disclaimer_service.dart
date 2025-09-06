import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisclaimerService {
  static const _storage = FlutterSecureStorage();
  static const String _disclaimerAcceptedKey = 'disclaimer_accepted';

  Future<bool> hasAcceptedDisclaimer() async {
    try {
      final value = await _storage.read(key: _disclaimerAcceptedKey);
      return value == 'true';
    } catch (e) {
      return false;
    }
  }

  Future<void> acceptDisclaimer() async {
    await _storage.write(key: _disclaimerAcceptedKey, value: 'true');
  }

  Future<void> resetDisclaimerAcceptance() async {
    await _storage.delete(key: _disclaimerAcceptedKey);
  }
}

final disclaimerServiceProvider = Provider<DisclaimerService>((ref) {
  return DisclaimerService();
});

final disclaimerAcceptedProvider = FutureProvider<bool>((ref) async {
  final service = ref.read(disclaimerServiceProvider);
  return await service.hasAcceptedDisclaimer();
});
