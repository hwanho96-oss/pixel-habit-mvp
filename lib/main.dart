import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'data/storage.dart';
import 'l10n/app_localizations.dart';
import 'providers/app_state.dart';
import 'router/app_router.dart';
import 'widgets/mobile_frame.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = AppStorage();
  final appState = AppState(storage);
  await appState.load();

  runApp(
    ChangeNotifierProvider.value(
      value: appState,
      child: const PixelHabitApp(),
    ),
  );
}

class PixelHabitApp extends StatelessWidget {
  const PixelHabitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      builder: (context, child) => MobileFrame(child: child!),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) return const Locale('ko');
        for (final supported in supportedLocales) {
          if (supported.languageCode == locale.languageCode) {
            return supported;
          }
        }
        return const Locale('ko');
      },
    );
  }
}
