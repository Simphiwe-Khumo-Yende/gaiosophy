import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DisclaimerService {
  static const _storage = FlutterSecureStorage();
  
  Future<bool> hasAcceptedDisclaimer(String userId) async {
    try {
      // Check both local storage and Firestore for disclaimer acceptance
      final localKey = 'disclaimer_accepted_$userId';
      final localValue = await _storage.read(key: localKey);
      
      if (localValue == 'true') {
        return true;
      }
      
      // Check Firestore as backup
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      
      final firestoreValue = userDoc.data()?['disclaimerAccepted'] as bool? ?? false;
      
      // If Firestore has it but local doesn't, sync to local
      if (firestoreValue) {
        await _storage.write(key: localKey, value: 'true');
      }
      
      return firestoreValue;
    } catch (e) {
      return false;
    }
  }

  Future<void> acceptDisclaimer(String userId) async {
    try {
      // Store in both local storage and Firestore
      final localKey = 'disclaimer_accepted_$userId';
      await _storage.write(key: localKey, value: 'true');
      
      // Store in Firestore with timestamp
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({
        'disclaimerAccepted': true,
        'disclaimerAcceptedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // If Firestore fails, at least keep local storage
      final localKey = 'disclaimer_accepted_$userId';
      await _storage.write(key: localKey, value: 'true');
    }
  }

  Future<void> resetDisclaimerAcceptance(String userId) async {
    try {
      final localKey = 'disclaimer_accepted_$userId';
      await _storage.delete(key: localKey);
      
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({
        'disclaimerAccepted': false,
        'disclaimerAcceptedAt': null,
      });
    } catch (e) {
      // Handle error silently
    }
  }
}

final disclaimerServiceProvider = Provider<DisclaimerService>((ref) {
  return DisclaimerService();
});

final disclaimerAcceptedProvider = FutureProvider<bool>((ref) async {
  final authState = ref.watch(firebaseAuthProvider);
  final user = authState.value;
  
  if (user == null) {
    return false;
  }
  
  final service = ref.read(disclaimerServiceProvider);
  return await service.hasAcceptedDisclaimer(user.uid);
});

// Firebase auth provider for consistency
final firebaseAuthProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
