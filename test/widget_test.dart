// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:gaiosophy_app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gaiosophy_app/firebase_options.dart';

void main() {
  testWidgets('App builds within ProviderScope', (WidgetTester tester) async {
    // Initialize Firebase
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      try { await FirebaseAuth.instance.signInAnonymously(); } catch (_) {}
    }
    await tester.pumpWidget(const ProviderScope(child: GaiosophyApp()));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(GaiosophyApp), findsOneWidget);
  });
}
