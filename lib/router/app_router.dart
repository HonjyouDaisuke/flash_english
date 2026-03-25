import 'package:flash_english/domain/enums/training_mode.dart';
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
              path: 'normal',
              builder: (context, state) =>
                  const TrainingPage(mode: TrainingMode.level1),
            ),
            GoRoute(
              path: 'shuffle',
              builder: (context, state) =>
                  const TrainingPage(mode: TrainingMode.shuffle),
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
