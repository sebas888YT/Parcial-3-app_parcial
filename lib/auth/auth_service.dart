import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

const _facebookAppId = '1455175546078462';

class AuthService {
  AuthService({FirebaseAuth? firebaseAuth})
    : _auth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await credential.user?.updateDisplayName(name.trim());
    return credential;
  }

  Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb) {
      return _auth.signInWithPopup(GoogleAuthProvider());
    }

    final platform = defaultTargetPlatform;
    if (platform != TargetPlatform.android && platform != TargetPlatform.iOS) {
      throw UnsupportedError(
        'El inicio de sesión con Google está disponible en Android, iOS y web.',
      );
    }

    final googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize();
    final account = await googleSignIn.authenticate();
    final idToken = account.authentication.idToken;
    if (idToken == null) {
      throw FirebaseAuthException(
        code: 'missing-google-id-token',
        message: 'No se recibió el token de Google. Verifica la configuración OAuth de Firebase.',
      );
    }

    final credential = GoogleAuthProvider.credential(idToken: idToken);
    return _auth.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    final platform = defaultTargetPlatform;
    if (kIsWeb ||
        platform == TargetPlatform.windows ||
        platform == TargetPlatform.macOS) {
      await FacebookAuth.instance.webAndDesktopInitialize(
        appId: _facebookAppId,
        cookie: true,
        xfbml: true,
        version: 'v18.0',
      );
    } else if (platform != TargetPlatform.android &&
        platform != TargetPlatform.iOS) {
      throw UnsupportedError(
        'El inicio de sesión con Facebook está disponible en Android, iOS, '
        'Windows, macOS y web.',
      );
    }

    final result = await FacebookAuth.instance.login(
      permissions: const ['public_profile'],
    );
    if (result.status == LoginStatus.cancelled) {
      throw const AuthOperationCancelledException();
    }
    if (result.status != LoginStatus.success || result.accessToken == null) {
      throw Exception(
        result.message ?? 'Facebook no pudo completar la autenticación.',
      );
    }

    final credential = FacebookAuthProvider.credential(
      result.accessToken!.tokenString,
    );
    return _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    Object? providerError;
    final platform = defaultTargetPlatform;

    if (!kIsWeb &&
        (platform == TargetPlatform.android ||
            platform == TargetPlatform.iOS)) {
      try {
        await FacebookAuth.instance.logOut();
      } catch (error) {
        providerError = error;
      }

      try {
        final googleSignIn = GoogleSignIn.instance;
        await googleSignIn.initialize();
        await googleSignIn.signOut();
      } catch (error) {
        providerError ??= error;
      }
    }

    await _auth.signOut();
    if (providerError != null) {
      throw StateError(
        'Se cerró la sesión de Firebase, pero no se pudo cerrar una sesión social: $providerError',
      );
    }
  }
}

class AuthOperationCancelledException implements Exception {
  const AuthOperationCancelledException();
}
