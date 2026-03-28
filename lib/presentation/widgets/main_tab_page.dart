import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainTabPage extends StatefulWidget {
  final Widget child;

  const MainTabPage({super.key, required this.child});

  @override
  State<MainTabPage> createState() => _MainTabPageState();
}

class _MainTabPageState extends State<MainTabPage> {
  final routes = [
    '/training',
    '/dashboard',
    '/chat',
    '/weak',
  ];

  int _calculateIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/training')) return 0;
    if (location.startsWith('/dashboard')) return 1;
    if (location.startsWith('/chat')) return 2;
    if (location.startsWith('/weak')) return 3;

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateIndex(context);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue, // ← 選択中
        unselectedItemColor: Colors.grey, // ← 未選択
        backgroundColor: Colors.white, // ← 背景
        currentIndex: currentIndex, // ← ここ重要
        onTap: (index) {
          context.go(routes[index]);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'トレーニング'),
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'ダッシュボード'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: 'カレンダー'),
          BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events), label: 'チャレンジ'),
        ],
      ),
    );
  }
}
