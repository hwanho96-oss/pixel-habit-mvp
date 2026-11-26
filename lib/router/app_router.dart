import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/result_table.dart';
import '../screens/analysis_screen.dart';
import '../screens/character_tab_screen.dart';
import '../screens/home_screen.dart';
import '../screens/placeholder_screen.dart';
import '../screens/result_table_form_screen.dart';
import '../screens/routine_form_screen.dart';
import '../screens/shell_scaffold.dart';
import '../screens/tag_create_screen.dart';

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
              builder: (context, state) => const CharacterTabScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/analysis',
              builder: (context, state) => const AnalysisScreen(),
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
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/tag/create',
      builder: (context, state) => const TagCreateScreen(),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/result-table/form',
      builder: (context, state) {
        final initial = state.extra as ResultTable?;
        return ResultTableFormScreen(initial: initial);
      },
    ),
  ],
);
