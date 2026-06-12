import 'package:firebase_core/firebase_core.dart';
import 'package:flash_english/infrastructure/persistence/app_database.dart';
import 'package:flash_english/presentation/providers/theme_provider.dart';
import 'package:flash_english/presentation/theme/app_theme.dart';
import 'package:flash_english/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint("① Firebase前");
  await Firebase.initializeApp();
  debugPrint("② Firebase後");
  await AppDatabase.instance.init();

  final container = ProviderContainer();
  final themeState = container.read(themeStateProvider);
  await themeState.load();

  runApp(
    const ProviderScope(
      child: FlashEnglishApp(),
    ),
  );
}

class FlashEnglishApp extends ConsumerWidget {
  const FlashEnglishApp({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final themeState = ref.watch(themeStateProvider);

    return MaterialApp.router(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeState.themeMode,
      routerConfig: appRouter,
    );
  }
}
