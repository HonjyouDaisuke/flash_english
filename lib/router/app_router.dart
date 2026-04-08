import 'dart:collection';

import 'package:flash_english/presentation/pages/category_select_page.dart';
import 'package:flash_english/presentation/pages/unit_select_page.dart';
import 'package:go_router/go_router.dart';

import '../presentation/pages/training_menu_page.dart';
import '../presentation/pages/training_page.dart';
import '../presentation/pages/dashboard_page.dart';
import '../presentation/pages/chat_page.dart';
import '../presentation/pages/weak_menu_page.dart';
import '../presentation/widgets/main_tab_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/training',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainTabPage(child: child);
      },
      routes: [
        /// トレーニング
        GoRoute(
          path: '/training',
          builder: (context, state) => const TrainingMenuPage(),
          routes: [
            GoRoute(
                path: 'category',
                builder: (context, state) => const CategorySelectPage(),
                routes: [
                  GoRoute(
                      path: 'unit',
                      builder: (context, state) => UnitSelectPage(
                            categoryId: 1,
                          ),
                      routes: [
                        GoRoute(
                          path: 'training',
                          builder: (context, state) {
                            final categoryId = int.parse(
                                state.uri.queryParameters['categoryId'] ?? '0');
                            final unitId = int.parse(
                                state.uri.queryParameters['unitId'] ?? '0');
                            return TrainingPage(
                                categoryId: categoryId, unitId: unitId);
                          },
                        ),
                      ]),
                ]),
            GoRoute(
              path: 'shuffle',
              builder: (context, state) => const TrainingPage(),
            ),
          ],
        ),

        /// ダッシュボード
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardPage(),
        ),

        /// チャット
        GoRoute(
          path: '/chat',
          builder: (context, state) => const ChatPage(),
        ),

        /// 苦手
        GoRoute(
          path: '/weak',
          builder: (context, state) => const WeakMenuPage(),
        ),
      ],
    ),
  ],
);
