import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/home_screen.dart';
import '../screens/placeholder_screen.dart';
import '../screens/routine_form_screen.dart';
import '../screens/shell_scaffold.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ShellScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/character',
              builder: (context, state) => PlaceholderScreen(
                titleBuilder: (l10n) => l10n.tabCharacter,
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/analysis',
              builder: (context, state) => PlaceholderScreen(
                titleBuilder: (l10n) => l10n.tabAnalysis,
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => PlaceholderScreen(
                titleBuilder: (l10n) => l10n.tabSettings,
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/item/form',
      builder: (context, state) {
        final args = state.extra as ItemFormArgs? ??
            const ItemFormArgs(type: FormItemType.routine);
        return ItemFormScreen.fromArgs(args);
      },
    ),
  ],
);
