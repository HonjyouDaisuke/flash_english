import 'package:flash_english/application/usecases/login_usecase.dart';
import 'package:flash_english/infrastructure/api/api_client.dart';
import 'package:flash_english/infrastructure/authentication/auth_backend.dart';
import 'package:flash_english/infrastructure/storage/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  late final tokenStorage = TokenStorage();
  late final apiClient = ApiClient(tokenStorage);
  late final authBackend =
      AuthBackend(apiClient, 'http://10.0.2.2:8888'); //10.0.2.2:8888
  late final loginUseCase = LoginUseCase(
    authBackend: authBackend,
    tokenStorage: tokenStorage,
  );

  LoginPage({super.key});

  Future<void> _login(BuildContext context) async {
    final success = await loginUseCase.login();
    if (success) {
      if (context.mounted) {
        context.go('/training');
      }
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ログインに失敗しました')),
      );
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
