import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_english/infrastructure/authentication/auth_backend.dart';
import 'package:flash_english/infrastructure/storage/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginUseCase {
  final AuthBackend _authBackend;
  final TokenStorage _tokenStorage;

  // ✅ ここが重要（依存注入）
  LoginUseCase({
    required AuthBackend authBackend,
    required TokenStorage tokenStorage,
  })  : _authBackend = authBackend,
        _tokenStorage = tokenStorage;

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<bool> login() async {
    try {
      final userCredential = await signInWithGoogle();

      if (userCredential == null || userCredential.user == null) {
        debugPrint("ログインキャンセル or 失敗");
        return false;
      }
      final idToken = await userCredential.user!.getIdToken();
      debugPrint("ログイン成功");
      if (idToken == null) {
        debugPrint("IDトークンの取得に失敗");
        return false;
      }
      final result = await _authBackend.callBackend(idToken);
      if (result == null || !result.containsKey('access_token')) {
        debugPrint("バックエンドからのアクセストークンの取得に失敗");
        return false;
      }

      final accessToken = result['access_token'];
      final refreshToken = result['refresh_token'];

      if (accessToken == null || refreshToken == null) {
        debugPrint("token取得失敗");
        return false;
      }

      // 🔥 ここが超重要
      await _tokenStorage.saveTokens(
          accessToken: accessToken, refreshToken: refreshToken);

      final token = await _tokenStorage.getAccessToken();
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebaseエラー: ${e.code}");
    } catch (e) {
      debugPrint("その他エラー: $e");
    }

    return false;
  }
}
