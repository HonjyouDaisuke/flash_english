import 'package:flash_english/core/providers/api_providers.dart';
import 'package:flash_english/presentation/providers/auth_provider.dart';
import 'package:flash_english/presentation/providers/sync_queue_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  Future<void> _login() async {
    debugPrint("ログイン処理開始");

    final loginUseCase = ref.read(loginUseCaseProvider);

    final success = await loginUseCase.login();
    if (!mounted) return;
    if (success) {
      await ref
          .read(syncQueueUseCaseProvider)
          .execute(ref.read(authProvider).userId!);
      debugPrint("ローカルのキューをサーバーに同期完了");
      if (!mounted) return;
      context.go('/training');
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ログイン")),
      body: Center(
        child: ElevatedButton(
          onPressed: _login,
          child: const Text("Googleでログイン"),
        ),
      ),
    );
  }
}
