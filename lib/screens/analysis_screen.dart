import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// Temporary empty analysis tab — rebuilt in a later step.
class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              l10n.analysisComingSoon,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        ),
      ),
    );
  }
}
