import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

typedef L10nTitleBuilder = String Function(AppLocalizations l10n);

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.titleBuilder});

  final L10nTitleBuilder titleBuilder;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            titleBuilder(l10n),
            textAlign: TextAlign.center,
            softWrap: true,
          ),
        ),
      ),
    );
  }
}
