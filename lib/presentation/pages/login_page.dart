import 'package:flash_english/core/providers/api_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  Future<void> _login(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final loginUseCase = ref.read(loginUseCaseProvider);

    final success = await loginUseCase.login();

    if (success) {
      if (context.mounted) {
        context.go('/training');
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'ログインに失敗しました',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    return Scaffold(
      appBar: AppBar(title: const Text("ログイン")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _login(context, ref),
          child: const Text("Googleでログイン"),
        ),
      ),
    );
  }
}
