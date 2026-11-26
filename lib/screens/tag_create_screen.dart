import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/tag_palette.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_state.dart';

enum _TagCreateKind { main, sub }

class TagCreateScreen extends StatefulWidget {
  const TagCreateScreen({super.key});

  @override
  State<TagCreateScreen> createState() => _TagCreateScreenState();
}

class _TagCreateScreenState extends State<TagCreateScreen> {
  final TextEditingController _nameController = TextEditingController();
  int _colorValue = kTagPaletteColors.first;
  _TagCreateKind _kind = _TagCreateKind.main;
  String? _parentId;
  bool _parentInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_parentInitialized) return;
    _parentInitialized = true;
    final mains = context.read<AppState>().mainTags;
    if (mains.isNotEmpty) {
      _parentId = mains.first.id;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _canSave {
    if (_nameController.text.trim().isEmpty) return false;
    if (_kind == _TagCreateKind.sub && _parentId == null) return false;
    return true;
  }

  Future<void> _save() async {
    if (!_canSave) return;
    final state = context.read<AppState>();
    final tag = await state.addTag(
      name: _nameController.text.trim(),
      colorValue: _colorValue,
      parentId: _kind == _TagCreateKind.sub ? _parentId : null,
    );
    if (!mounted) return;
    Navigator.of(context).pop(tag.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<AppState>();
    final mains = state.mainTags;
    final selectedParent =
        mains.any((t) => t.id == _parentId) ? _parentId : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.tagCreateTitle,
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text(l10n.tagNameLabel),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: l10n.tagNameHint,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Text(l10n.tagColorLabel),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final color in kTagPaletteColors)
                InkWell(
                  onTap: () => setState(() => _colorValue = color),
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Color(color),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _colorValue == color
                            ? Theme.of(context).colorScheme.onSurface
                            : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text(l10n.tagTypeLabel),
          const SizedBox(height: 8),
          SegmentedButton<_TagCreateKind>(
            segments: [
              ButtonSegment(
                value: _TagCreateKind.main,
                label: Text(
                  l10n.tagTypeMain,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ButtonSegment(
                value: _TagCreateKind.sub,
                label: Text(
                  l10n.tagTypeSub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            selected: {_kind},
            onSelectionChanged: (next) {
              setState(() {
                _kind = next.first;
                if (_kind == _TagCreateKind.sub &&
                    _parentId == null &&
                    mains.isNotEmpty) {
                  _parentId = mains.first.id;
                }
              });
            },
            showSelectedIcon: false,
          ),
          if (_kind == _TagCreateKind.sub) ...[
            const SizedBox(height: 16),
            Text(l10n.tagParentLabel),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              key: ValueKey<String?>(selectedParent),
              initialValue: selectedParent,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: [
                for (final tag in mains)
                  DropdownMenuItem(
                    value: tag.id,
                    child: Text(
                      TagPresets.displayName(l10n, tag),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: mains.isEmpty
                  ? null
                  : (value) => setState(() => _parentId = value),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _canSave ? _save : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  l10n.routineSave,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
