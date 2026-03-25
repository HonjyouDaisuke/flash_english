import 'package:flash_english/router/app_router.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FlashEnglishApp());
}

class FlashEnglishApp extends StatelessWidget {
  const FlashEnglishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
    );
  }
}
