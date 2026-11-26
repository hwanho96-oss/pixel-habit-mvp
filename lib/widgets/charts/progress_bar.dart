import 'package:flutter/material.dart';

/// Thin wrapper so future chart types can live beside progress visuals.
class ChartProgressBar extends StatelessWidget {
  const ChartProgressBar({
    super.key,
    required this.value,
    this.minHeight = 8,
  });

  /// 0.0 – 1.0
  final double value;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: minHeight,
      ),
    );
  }
}
