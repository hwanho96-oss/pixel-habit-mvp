import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/tag_palette.dart';
import '../l10n/app_localizations.dart';
import '../models/tag.dart';
import '../providers/app_state.dart';

/// Opens the main/sub tag picker. Returns the selected ids, or null if dismissed.
Future<Set<String>?> showTagPicker({
  required BuildContext context,
  required Set<String> initiallySelected,
  bool allowCreate = true,
}) async {
  final result = await showModalBottomSheet<Object>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) {
      return TagPickerSheet(
        initiallySelected: initiallySelected,
        onCreateTag: allowCreate
            ? () => Navigator.pop(ctx, '__create__')
            : null,
      );
    },
  );
  if (!context.mounted) return null;
  if (result == '__create__') {
    final createdId = await context.push<String>('/tag/create');
    if (!context.mounted) return null;
    final next = {...initiallySelected};
    if (createdId != null) next.add(createdId);
    return showTagPicker(
      context: context,
      initiallySelected: next,
      allowCreate: allowCreate,
    );
  }
  if (result is Set<String>) return result;
  return null;
}

class TagPickerSheet extends StatefulWidget {
  const TagPickerSheet({
    super.key,
    required this.initiallySelected,
    this.onCreateTag,
  });

  final Set<String> initiallySelected;
  final VoidCallback? onCreateTag;

  @override
  State<TagPickerSheet> createState() => _TagPickerSheetState();
}

class _TagPickerSheetState extends State<TagPickerSheet> {
  late Set<String> _selected;
  final Set<String> _expanded = {};

  @override
  void initState() {
    super.initState();
    _selected = {...widget.initiallySelected};
  }

  void _toggle(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected = {..._selected}..remove(id);
      } else {
        _selected = {..._selected, id};
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<AppState>();
    final mains = state.mainTags;
    final presets = [
      for (final id in TagPresets.ids)
        if (state.tagById(id) != null) state.tagById(id)!,
    ];

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final tag in presets) ...[
                          FilterChip(
                            avatar: CircleAvatar(
                              backgroundColor: Color(tag.colorValue),
                              radius: 8,
                            ),
                            label: Text(
                              TagPresets.displayName(l10n, tag),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            selected: _selected.contains(tag.id),
                            onSelected: (_) => _toggle(tag.id),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ],
                    ),
                  ),
                ),
                if (widget.onCreateTag != null)
                  IconButton(
                    tooltip: l10n.tagCreateTitle,
                    onPressed: widget.onCreateTag,
                    icon: const Icon(Icons.add),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.45,
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final main in mains)
                    _MainTagTile(
                      main: main,
                      subTags: state.subTagsOf(main.id),
                      selected: _selected,
                      expanded: _expanded.contains(main.id),
                      onToggleExpand: () {
                        setState(() {
                          if (_expanded.contains(main.id)) {
                            _expanded.remove(main.id);
                          } else {
                            _expanded.add(main.id);
                          }
                        });
                      },
                      onToggle: _toggle,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => Navigator.pop(context, _selected),
              child: Text(l10n.confirm),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainTagTile extends StatelessWidget {
  const _MainTagTile({
    required this.main,
    required this.subTags,
    required this.selected,
    required this.expanded,
    required this.onToggleExpand,
    required this.onToggle,
  });

  final Tag main;
  final List<Tag> subTags;
  final Set<String> selected;
  final bool expanded;
  final VoidCallback onToggleExpand;
  final void Function(String id) onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final name = TagPresets.displayName(l10n, main);
    final color = Color(main.colorValue);

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(backgroundColor: color, radius: 10),
          title: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: selected.contains(main.id),
                onChanged: (_) => onToggle(main.id),
              ),
              if (subTags.isNotEmpty)
                IconButton(
                  onPressed: onToggleExpand,
                  icon: Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                  ),
                ),
            ],
          ),
          onTap: () => onToggle(main.id),
        ),
        if (expanded)
          for (final sub in subTags)
            ListTile(
              contentPadding: const EdgeInsets.only(left: 28),
              leading: CircleAvatar(
                backgroundColor: Color(sub.colorValue),
                radius: 8,
              ),
              title: Text(
                TagPresets.chipLabel(l10n, sub, parent: main),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Checkbox(
                value: selected.contains(sub.id),
                onChanged: (_) => onToggle(sub.id),
              ),
              onTap: () => onToggle(sub.id),
            ),
      ],
    );
  }
}
