import 'package:flash_english/core/providers/api_providers.dart';
import 'package:flash_english/presentation/providers/sync/sync_unit_score_usecase_provider.dart';
import 'package:flash_english/presentation/providers/sync/sync_user_data_usecase_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _isLoading = false;

  Future<void> _login() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });
    try {
      debugPrint("ログイン処理開始");
      final loginUseCase = ref.read(loginUseCaseProvider);

      final loginUserId = await loginUseCase.login();
      if (!mounted) return;
      if (loginUserId != null) {
        try {
          await ref.read(syncUserDataUseCaseProvider).execute(loginUserId);
          debugPrint("ユーザーデータ同期完了");

          try {
            await ref.read(syncUnitScoreUseCaseProvider).execute(loginUserId);
          } catch (e) {
            debugPrint('ユニットスコア同期失敗: $e');
          }
          debugPrint('ユニットスコア同期完了');

          if (!mounted) return;

          context.go('/training');
        } catch (e) {
          debugPrint("ユーザーデータ同期失敗: $e");
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('同期に失敗しました。通信状態を確認してください。')),
          );
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
    } catch (e) {
      debugPrint("ログイン処理中にエラーが発生: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'ログイン中にエラーが発生しました。通信状態を確認してください。',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ログイン")),
      body: Stack(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: _isLoading ? null : _login,
              child: const Text("Googleでログイン"),
            ),
          ),
          if (_isLoading)
            const ColoredBox(
              color: Colors.black26,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
