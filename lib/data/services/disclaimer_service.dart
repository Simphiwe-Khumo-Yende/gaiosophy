import 'dart:async';
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
      
      // Check Firestore as backup with timeout to prevent hanging
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get()
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              print('⚠️ Firestore timeout checking disclaimer - using local value');
              throw TimeoutException('Firestore get timeout');
            },
          );
      
      final firestoreValue = userDoc.data()?['disclaimerAccepted'] as bool? ?? false;
      
      // If Firestore has it but local doesn't, sync to local
      if (firestoreValue) {
        await _storage.write(key: localKey, value: 'true');
      }
      
      return firestoreValue;
    } catch (e) {
      print('⚠️ Error checking disclaimer: $e');
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
  try {
    final authState = ref.watch(firebaseAuthProvider);
    
    // Handle loading state
    if (authState.isLoading) {
      return false;
    }
    
    // Handle error state
    if (authState.hasError) {
      print('⚠️ DisclaimerProvider: Auth state error: ${authState.error}');
      return false;
    }
    
    final user = authState.value;
    
    if (user == null) {
      return false;
    }
    
    final service = ref.read(disclaimerServiceProvider);
    return await service.hasAcceptedDisclaimer(user.uid);
  } catch (e, stackTrace) {
    // Catch any errors to prevent crash
    print('❌ DisclaimerProvider error: $e');
    print('Stack trace: $stackTrace');
    // Default to false (user hasn't accepted) to be safe
    return false;
  }
});

// Firebase auth provider for consistency
final firebaseAuthProvider = StreamProvider<User?>((ref) {
  try {
    return FirebaseAuth.instance.authStateChanges();
  } catch (e, stackTrace) {
    print('❌ FirebaseAuthProvider error: $e');
    print('Stack trace: $stackTrace');
    // Return empty stream to prevent crash
    return Stream.value(null);
  }
});
