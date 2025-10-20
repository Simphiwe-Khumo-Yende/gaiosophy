import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  AuthService(this._auth);
  final FirebaseAuth _auth;

  Future<UserCredential> signInWithEmail(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);
  Future<UserCredential> registerWithEmail(String email, String password) =>
      _auth.createUserWithEmailAndPassword(email: email, password: password);

  Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb) {
      final googleProvider = GoogleAuthProvider();
      return _auth.signInWithPopup(googleProvider);
    }
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Sign in aborted');
    }
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );
    return _auth.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithApple() async {
    // Request Apple ID credential
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: kIsWeb
          ? WebAuthenticationOptions(
              clientId: 'com.gaiosophy.app', // Your bundle ID
              redirectUri: Uri.parse(
                'https://gaiosophy-app.firebaseapp.com/__/auth/handler',
              ),
            )
          : null,
    );

    // Create OAuth credential for Firebase
    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    // Sign in to Firebase with the credential
    final userCredential = await _auth.signInWithCredential(oauthCredential);

    // Update display name if provided and not already set
    if (userCredential.user != null && userCredential.user!.displayName == null) {
      final fullName = appleCredential.givenName != null && appleCredential.familyName != null
          ? '${appleCredential.givenName} ${appleCredential.familyName}'
          : null;
      if (fullName != null) {
        await userCredential.user!.updateDisplayName(fullName);
      }
    }

    return userCredential;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    if (!kIsWeb) {
      try {
        final GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
      } catch (_) {}
    }
  }
}
