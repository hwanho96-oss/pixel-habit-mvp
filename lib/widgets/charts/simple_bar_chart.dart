import 'package:flutter/material.dart';

/// Minimal bar chart drawn with [Container] heights (no chart library).
/// [values] are raw magnitudes; bars scale to the max value (or 1 if all zero).
class SimpleBarChart extends StatelessWidget {
  const SimpleBarChart({
    super.key,
    required this.values,
    this.labels = const [],
    this.maxBarHeight = 72,
    this.barColor,
  });

  final List<int> values;
  final List<String> labels;
  final double maxBarHeight;
  final Color? barColor;

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const SizedBox.shrink();

    final scheme = Theme.of(context).colorScheme;
    final color = barColor ?? scheme.primary;
    final maxValue = values.fold<int>(0, (a, b) => a > b ? a : b);
    final scale = maxValue <= 0 ? 1 : maxValue;

    return SizedBox(
      height: maxBarHeight + (labels.isEmpty ? 0 : 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < values.length; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: maxBarHeight * (values[i] / scale),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: values[i] > 0 ? 0.85 : 0.2),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ),
                    if (labels.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        i < labels.length ? labels[i] : '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
