import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/tag_palette.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_state.dart';

/// Compact colored chips for routine/todo lists. Overflow → ellipsis.
class TagChipsRow extends StatelessWidget {
  const TagChipsRow({super.key, required this.tagIds});

  final List<String> tagIds;

  @override
  Widget build(BuildContext context) {
    if (tagIds.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<AppState>();
    final chips = <Widget>[];
    for (final id in tagIds) {
      final tag = state.tagById(id);
      if (tag == null) continue;
      final parent =
          tag.parentId == null ? null : state.tagById(tag.parentId!);
      final label = TagPresets.chipLabel(l10n, tag, parent: parent);
      final color = Color(tag.colorValue);
      chips.add(
        Container(
          constraints: const BoxConstraints(maxWidth: 140),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.65)),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }
    if (chips.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < chips.length; i++) ...[
                if (i > 0) const SizedBox(width: 4),
                chips[i],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
