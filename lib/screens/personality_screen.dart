import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/title_def.dart';
import '../providers/app_state.dart';

enum _TitleCardStatus { locked, available, owned, equipped }

class PersonalityScreen extends StatelessWidget {
  const PersonalityScreen({super.key});

  String _axisLabel(AppLocalizations l10n, AxisId axis) {
    switch (axis) {
      case AxisId.relation:
        return l10n.axisRelation;
      case AxisId.emotion:
        return l10n.axisEmotion;
      case AxisId.action:
        return l10n.axisAction;
    }
  }

  _TitleCardStatus _status(AppState state, TitleDef title) {
    if (state.equippedTitleId == title.id) return _TitleCardStatus.equipped;
    if (state.ownsTitle(title.id)) return _TitleCardStatus.owned;
    if (!state.meetsTitleRequires(title)) return _TitleCardStatus.locked;
    return _TitleCardStatus.available;
  }

  String _statusLabel(AppLocalizations l10n, _TitleCardStatus status) {
    switch (status) {
      case _TitleCardStatus.locked:
        return l10n.titleStatusLocked;
      case _TitleCardStatus.available:
        return l10n.titleStatusAvailable;
      case _TitleCardStatus.owned:
        return l10n.titleStatusOwned;
      case _TitleCardStatus.equipped:
        return l10n.titleStatusEquipped;
    }
  }

  Future<void> _openTitleDialog(
    BuildContext context,
    TitleDef title,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return Consumer<AppState>(
          builder: (context, state, _) {
            final status = _status(state, title);
            final name = title.localizedName(locale);

            String? actionLabel;
            VoidCallback? onAction;
            switch (status) {
              case _TitleCardStatus.locked:
                actionLabel = null;
              case _TitleCardStatus.available:
                actionLabel = l10n.shopBuy;
                onAction = () async {
                  final ok = await state.buyTitle(title.id);
                  if (!ctx.mounted) return;
                  if (!ok) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.titleCannotBuy)),
                    );
                  }
                };
              case _TitleCardStatus.owned:
                actionLabel = l10n.shopEquip;
                onAction = () => state.equipTitle(title.id);
              case _TitleCardStatus.equipped:
                actionLabel = l10n.titleStatusEquipped;
                onAction = () => state.equipTitle(title.id);
            }

            return AlertDialog(
              title: Text(
                name,
                softWrap: true,
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.titleTierLabel(title.tier),
                      softWrap: true,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.titleCostHeading,
                      style: Theme.of(context).textTheme.titleSmall,
                      softWrap: true,
                    ),
                    const SizedBox(height: 4),
                    for (final axis in AxisId.values)
                      if (title.costOf(axis) > 0)
                        Text(
                          l10n.titleCostLine(
                            _axisLabel(l10n, axis),
                            title.costOf(axis),
                            state.axisPointOf(axis),
                            state.axisPointOf(axis) >= title.costOf(axis)
                                ? l10n.titleCostMet
                                : l10n.titleCostShort,
                          ),
                          softWrap: true,
                        ),
                    if (title.requires.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        l10n.titleRequiresHeading,
                        style: Theme.of(context).textTheme.titleSmall,
                        softWrap: true,
                      ),
                      const SizedBox(height: 4),
                      for (final reqId in title.requires)
                        Text(
                          l10n.titleRequireLine(
                            state.titleById(reqId)?.localizedName(locale) ??
                                reqId,
                            state.ownsTitle(reqId)
                                ? l10n.titleCostMet
                                : l10n.titleCostShort,
                          ),
                          softWrap: true,
                        ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(l10n.close),
                ),
                if (actionLabel != null)
                  TextButton(
                    onPressed: onAction == null
                        ? null
                        : () async {
                            onAction!();
                          },
                    child: Text(
                      actionLabel,
                      softWrap: true,
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<AppState>();
    final locale = Localizations.localeOf(context).languageCode;

    final byTier = <int, List<TitleDef>>{};
    for (final title in state.titles) {
      byTier.putIfAbsent(title.tier, () => []).add(title);
    }
    final tiers = byTier.keys.toList()..sort();

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
      children: [
        Text(
          l10n.unspentPointsLabel(state.unspentPoints),
          style: Theme.of(context).textTheme.titleMedium,
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        for (final axis in AxisId.values)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${_axisLabel(l10n, axis)}: ${state.axisPointOf(axis)}',
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: state.unspentPoints > 0
                      ? () => state.allocatePoint(axis)
                      : null,
                  child: Text(l10n.allocatePointPlusOne),
                ),
              ],
            ),
          ),
        const SizedBox(height: 8),
        for (final tier in tiers) ...[
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: Text(
              l10n.titleTierLabel(tier),
              style: Theme.of(context).textTheme.titleSmall,
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          for (final title in byTier[tier]!)
            Card(
              child: ListTile(
                title: Text(
                  title.localizedName(locale),
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  _statusLabel(l10n, _status(state, title)),
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => _openTitleDialog(context, title),
              ),
            ),
        ],
      ],
    );
  }
}
