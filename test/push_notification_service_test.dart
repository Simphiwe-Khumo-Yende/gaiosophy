import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:gaiosophy_app/data/repositories/user_notification_repository.dart';
import 'package:gaiosophy_app/data/services/push_notification_service.dart';

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserNotificationRepository extends Mock
    implements UserNotificationRepository {}

class MockUser extends Mock implements User {}

void main() {
  group('PushNotificationService', () {
    late MockFirebaseMessaging messaging;
    late MockFirebaseAuth auth;
    late MockUserNotificationRepository repository;
    late MockUser user;
    late PushNotificationService service;

    setUp(() {
      messaging = MockFirebaseMessaging();
      auth = MockFirebaseAuth();
      repository = MockUserNotificationRepository();
      user = MockUser();

      service = PushNotificationService(
        messaging: messaging,
        auth: auth,
        repository: repository,
      );

      when(() => auth.currentUser).thenReturn(user);
      when(() => user.uid).thenReturn('user-123');
    when(() => messaging.subscribeToTopic(any<String>()))
      .thenAnswer((_) async {});
    when(() => messaging.unsubscribeFromTopic(any<String>()))
          .thenAnswer((_) async {});
    when(() => repository.setNotificationsEnabled(
      uid: any<String>(named: 'uid'),
      enabled: any<bool>(named: 'enabled'),
      ))
          .thenAnswer((_) async {});
    when(() => repository.addToken(
      uid: any<String>(named: 'uid'),
      token: any<String>(named: 'token'),
      ))
          .thenAnswer((_) async {});
    when(() => repository.removeToken(
      uid: any<String>(named: 'uid'),
      token: any<String>(named: 'token'),
      ))
          .thenAnswer((_) async {});
    when(() => repository.getNotificationsEnabled(uid: any<String>(named: 'uid')))
          .thenAnswer((_) async => false);
    });

    test('enableNotifications returns true when permission granted', () async {
  when(() => messaging.requestPermission(
    alert: any<bool>(named: 'alert'),
    announcement: any<bool>(named: 'announcement'),
    badge: any<bool>(named: 'badge'),
    carPlay: any<bool>(named: 'carPlay'),
    criticalAlert: any<bool>(named: 'criticalAlert'),
    provisional: any<bool>(named: 'provisional'),
    sound: any<bool>(named: 'sound'),
    providesAppNotificationSettings:
        any<bool>(named: 'providesAppNotificationSettings'),
      )).thenAnswer(
        (_) async => const NotificationSettings(
          authorizationStatus: AuthorizationStatus.authorized,
          alert: AppleNotificationSetting.enabled,
          announcement: AppleNotificationSetting.notSupported,
          badge: AppleNotificationSetting.enabled,
          carPlay: AppleNotificationSetting.notSupported,
          lockScreen: AppleNotificationSetting.enabled,
          notificationCenter: AppleNotificationSetting.enabled,
          showPreviews: AppleShowPreviewSetting.always,
          timeSensitive: AppleNotificationSetting.notSupported,
          criticalAlert: AppleNotificationSetting.notSupported,
          sound: AppleNotificationSetting.enabled,
          providesAppNotificationSettings: AppleNotificationSetting.notSupported,
        ),
      );

      when(() => messaging.getToken()).thenAnswer((_) async => 'token-123');

      final bool result = await service.enableNotifications();

      expect(result, isTrue);
      verify(() => repository.addToken(uid: 'user-123', token: 'token-123'))
          .called(1);
      verify(
        () => repository.setNotificationsEnabled(
          uid: 'user-123',
          enabled: true,
        ),
      ).called(1);
      verify(() => messaging.subscribeToTopic(PushNotificationService.newContentTopic))
          .called(1);
    });

    test('enableNotifications returns false when permission denied', () async {
  when(() => messaging.requestPermission(
    alert: any<bool>(named: 'alert'),
    announcement: any<bool>(named: 'announcement'),
    badge: any<bool>(named: 'badge'),
    carPlay: any<bool>(named: 'carPlay'),
    criticalAlert: any<bool>(named: 'criticalAlert'),
    provisional: any<bool>(named: 'provisional'),
    sound: any<bool>(named: 'sound'),
    providesAppNotificationSettings:
        any<bool>(named: 'providesAppNotificationSettings'),
      )).thenAnswer(
        (_) async => const NotificationSettings(
          authorizationStatus: AuthorizationStatus.denied,
          alert: AppleNotificationSetting.disabled,
          announcement: AppleNotificationSetting.notSupported,
          badge: AppleNotificationSetting.disabled,
          carPlay: AppleNotificationSetting.notSupported,
          lockScreen: AppleNotificationSetting.disabled,
          notificationCenter: AppleNotificationSetting.disabled,
          showPreviews: AppleShowPreviewSetting.never,
          timeSensitive: AppleNotificationSetting.notSupported,
          criticalAlert: AppleNotificationSetting.notSupported,
          sound: AppleNotificationSetting.disabled,
          providesAppNotificationSettings: AppleNotificationSetting.notSupported,
        ),
      );

      final bool result = await service.enableNotifications();

      expect(result, isFalse);
      verify(
        () => repository.setNotificationsEnabled(
          uid: 'user-123',
          enabled: false,
        ),
      ).called(1);
      verifyNever(() => messaging.subscribeToTopic(any()));
      verifyNever(() => repository.addToken(uid: any(named: 'uid'), token: any(named: 'token')));
    });
  });
}
