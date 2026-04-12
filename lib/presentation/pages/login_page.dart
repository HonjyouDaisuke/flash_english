import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> _login(BuildContext context) async {
    try {
      final userCredential = await signInWithGoogle();

      if (userCredential == null || userCredential.user == null) {
        debugPrint("ログインキャンセル or 失敗");
        return;
      }

      debugPrint("ログイン成功: ${userCredential.user!.email}");

      if (!context.mounted) return;

      context.go('/training');
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebaseエラー: ${e.code}");
    } catch (e) {
      debugPrint("その他エラー: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ログイン")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _login(context),
          child: const Text("Googleでログイン"),
        ),
      ),
    );
  }
}

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
