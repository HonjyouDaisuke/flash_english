import 'package:flash_english/domain/entities/auth_status.dart';
import 'package:flash_english/infrastructure/persistence/app_database.dart';
import 'package:flash_english/presentation/providers/app_initialize_provider.dart';
import 'package:flash_english/presentation/providers/auth_provider.dart';
import 'package:flash_english/presentation/providers/auth_state.dart';
import 'package:flash_english/presentation/providers/sync_user_data_usecase_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  void _debugPrint(AuthState auth) {
    if (auth.token != null) {
      debugPrint('トークンあり');
    } else {
      debugPrint('トークンなし');
    }
    if (auth.userId != null) {
      debugPrint('ユーザーID: ${auth.userId}');
    } else {
      debugPrint('ユーザーIDなし');
    }
    if (auth.isExpired) {
      debugPrint('トークンが期限切れ...');
    } else {
      debugPrint('トークンは有効...');
    }
    if (auth.isOffline) {
      debugPrint('オフライン状態...');
    } else {
      debugPrint('オンライン状態...');
    }
    switch (auth.status) {
      case AuthStatus.unknown:
        debugPrint('認証状態: unknown');
        break;
      case AuthStatus.nonToken:
        debugPrint('認証状態: nonToken');
        break;
      case AuthStatus.onlineAuthenticated:
        debugPrint('認証状態: onlineAuthenticated');
        break;
      case AuthStatus.onlineAuthExpired:
        debugPrint('認証状態: onlineAuthExpired');
        break;
      case AuthStatus.offlineAuthenticated:
        debugPrint('認証状態: offlineAuthenticated');
        break;
      case AuthStatus.offlineAuthExpired:
        debugPrint('認証状態: offlineAuthExpired');
        break;
    }
  }

  Future<void> _initialize() async {
    await AppDatabase.instance.init();
    try {
      await ref.read(appInitializeProvider).execute();
    } catch (e) {
      debugPrint('初期化失敗: $e');
      if (!mounted) return;
      _showErrorDialog();
      return;
    }

    final auth = ref.read(authProvider);

    if (!mounted) return;
    _debugPrint(auth);

    if (auth.status == AuthStatus.onlineAuthenticated) {
      try {
        await ref.read(syncUserDataUseCaseProvider).execute(auth.userId!);
        debugPrint("ユーザー設定を取得完了");
      } catch (e) {
        debugPrint('ユーザーデータ同期失敗: $e');
      }
    }

    if (!mounted) return;

    switch (auth.status) {
      case AuthStatus.unknown:
        debugPrint("Go to login page...");
        context.go('/login');
        break;
      case AuthStatus.nonToken:
        debugPrint("Go to login page...");
        context.go('/login');
        break;
      case AuthStatus.onlineAuthenticated:
        debugPrint("Go to training page...");
        context.go('/training');
        break;
      case AuthStatus.onlineAuthExpired:
        debugPrint("Go to login page...");
        context.go('/login');
        break;
      case AuthStatus.offlineAuthenticated:
        debugPrint("Go to training page...");
        context.go('/training');
        break;
      case AuthStatus.offlineAuthExpired:
        debugPrint("Go to training page...");
        context.go('/training');
        break;
    }
    // context.go('/login');
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text('初期化エラー'),
          content: const Text('アプリの初期化に失敗しました。'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _initialize();
              },
              child: const Text('再試行'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/flash_english_title.png',
              width: screenWidth * 0.7,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                debugPrint('画像エラー: $error');
                return const Icon(Icons.error);
              },
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('FlashEnglish 起動中...'),
          ],
        ),
      ),
    );
  }
}
