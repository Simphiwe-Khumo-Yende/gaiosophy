import 'package:cloud_firestore/cloud_firestore.dart';

abstract class UserNotificationRepository {
  const UserNotificationRepository();

  Future<void> setNotificationsEnabled({
    required String uid,
    required bool enabled,
  });

  Future<void> addToken({
    required String uid,
    required String token,
  });

  Future<void> removeToken({
    required String uid,
    required String token,
  });

  Future<bool?> getNotificationsEnabled({
    required String uid,
  });
}

class FirestoreUserNotificationRepository implements UserNotificationRepository {
  FirestoreUserNotificationRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  @override
  Future<void> setNotificationsEnabled({
    required String uid,
    required bool enabled,
  }) async {
    await _usersCollection.doc(uid).set(
      <String, dynamic>{
        'notificationsEnabled': enabled,
        'notificationsUpdatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  @override
  Future<void> addToken({
    required String uid,
    required String token,
  }) async {
    await _usersCollection.doc(uid).set(
      <String, dynamic>{
        'notificationTokens': FieldValue.arrayUnion(<String>[token]),
        'notificationsUpdatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  @override
  Future<void> removeToken({
    required String uid,
    required String token,
  }) async {
    await _usersCollection.doc(uid).set(
      <String, dynamic>{
        'notificationTokens': FieldValue.arrayRemove(<String>[token]),
        'notificationsUpdatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  @override
  Future<bool?> getNotificationsEnabled({required String uid}) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _usersCollection.doc(uid).get();
    if (!snapshot.exists) {
      return null;
    }
    final Map<String, dynamic>? data = snapshot.data();
    return data == null ? null : data['notificationsEnabled'] as bool?;
  }
}
