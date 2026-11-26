import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/title_def.dart';
import '../providers/app_state.dart';

// --- Map layout constants (easy to tweak later) ---
const double kTitleMapCanvasSize = 1200;
const double kTitleMapUnit = 100;
const double kTitleMapNodeSize = 72;
const double kTitleMapNodeFontSize = 12;
const double kTitleMapBgLabelOpacity = 0.08;
const double kTitleMapBgLabelFontSize = 56;
const double kTitleMapEdgeWidth = 1.5;
const double kTitleMapOwnedEdgeWidth = 2.5;
const Color kTitleMapLockedColor = Color(0xFF9E9E9E);
const Color kTitleMapAvailableColor = Color(0xFF64B5F6);
const Color kTitleMapOwnedColor = Color(0xFF43A047);
const Color kTitleMapEquippedBorder = Color(0xFFFFB300);
const Color kTitleMapEdgeColor = Color(0xFFBDBDBD);
const Color kTitleMapOwnedEdgeColor = Color(0xFF66BB6A);

enum _NodeStatus { locked, available, owned, equipped }

class PersonalityScreen extends StatefulWidget {
  const PersonalityScreen({super.key});

  @override
  State<PersonalityScreen> createState() => _PersonalityScreenState();
}

class _PersonalityScreenState extends State<PersonalityScreen> {
  final TransformationController _transform = TransformationController();
  bool _didCenter = false;

  @override
  void dispose() {
    _transform.dispose();
    super.dispose();
  }

  Offset _canvasPoint(TitleDef title) {
    final cx = kTitleMapCanvasSize / 2 + title.x * kTitleMapUnit;
    final cy = kTitleMapCanvasSize / 2 - title.y * kTitleMapUnit;
    return Offset(cx, cy);
  }

  void _centerOnMe(Size viewport) {
    final meX = kTitleMapCanvasSize / 2;
    final meY = kTitleMapCanvasSize / 2;
    final dx = viewport.width / 2 - meX;
    final dy = viewport.height / 2 - meY;
    _transform.value = Matrix4.translationValues(dx, dy, 0);
  }

  _NodeStatus _status(AppState state, TitleDef title) {
    if (state.equippedTitleId == title.id) return _NodeStatus.equipped;
    if (state.ownsTitle(title.id)) return _NodeStatus.owned;
    if (state.isTitleReachable(title)) return _NodeStatus.available;
    return _NodeStatus.locked;
  }

  String _tendencyText(AppLocalizations l10n, AppState state) {
    final dominant = state.dominantTendency();
    if (dominant == null) return l10n.myTendencyBalanced;
    return l10n.myTendency(TitleDef.directionLabel(l10n, dominant));
  }

  Future<void> _openTitleSheet(BuildContext context, TitleDef title) async {
    final l10n = AppLocalizations.of(context)!;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return Consumer<AppState>(
          builder: (context, state, _) {
            final status = _status(state, title);
            final name = TitleDef.titleName(l10n, title.nameKey);
            final direction = TitleDef.directionLabel(l10n, title.direction);
            final canAfford = state.canAffordTitle(title);
            final isOwned = status == _NodeStatus.owned ||
                status == _NodeStatus.equipped;

            Widget? action;
            if (status == _NodeStatus.available) {
              action = Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton(
                    onPressed: canAfford
                        ? () async {
                            final ok = await state.buyTitle(title.id);
                            if (!ctx.mounted) return;
                            if (!ok) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.titleCannotBuy)),
                              );
                            }
                          }
                        : null,
                    child: Text(l10n.shopBuy),
                  ),
                  if (!canAfford) ...[
                    const SizedBox(height: 8),
                    Text(
                      l10n.titleNotEnoughPoints,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                      softWrap: true,
                    ),
                  ],
                ],
              );
            } else if (isOwned) {
              final equipped = status == _NodeStatus.equipped;
              action = FilledButton.tonal(
                onPressed: () => state.equipTitle(title.id),
                child: Text(equipped ? l10n.titleUnequip : l10n.shopEquip),
              );
            }

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleLarge,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      direction,
                      style: Theme.of(context).textTheme.bodyMedium,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.titlePriceLabel(title.cost),
                      style: Theme.of(context).textTheme.bodyMedium,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (action != null) ...[
                      const SizedBox(height: 16),
                      action,
                    ],
                  ],
                ),
              ),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.unspentPointsLabel(state.unspentPoints),
                style: Theme.of(context).textTheme.titleMedium,
                softWrap: true,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                _tendencyText(l10n, state),
                style: Theme.of(context).textTheme.bodySmall,
                softWrap: true,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (!_didCenter) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted || _didCenter) return;
                  _centerOnMe(Size(constraints.maxWidth, constraints.maxHeight));
                  setState(() => _didCenter = true);
                });
              }

              return InteractiveViewer(
                transformationController: _transform,
                constrained: false,
                boundaryMargin: const EdgeInsets.all(200),
                minScale: 0.4,
                maxScale: 2.5,
                child: SizedBox(
                  width: kTitleMapCanvasSize,
                  height: kTitleMapCanvasSize,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Positioned.fill(child: _DirectionBackground()),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _TitleEdgePainter(
                            titles: state.titles,
                            ownedIds: state.ownedTitleIds,
                            canvasPoint: _canvasPoint,
                          ),
                        ),
                      ),
                      for (final title in state.titles)
                        _TitleNode(
                          title: title,
                          center: _canvasPoint(title),
                          status: _status(state, title),
                          label: TitleDef.titleName(l10n, title.nameKey),
                          onTap: () => _openTitleSheet(context, title),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DirectionBackground extends StatelessWidget {
  const _DirectionBackground();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final style = TextStyle(
      fontSize: kTitleMapBgLabelFontSize,
      fontWeight: FontWeight.w700,
      color: Theme.of(context)
          .colorScheme
          .onSurface
          .withValues(alpha: kTitleMapBgLabelOpacity),
    );
    const inset = 80.0;

    return Stack(
      children: [
        Positioned(
          top: inset,
          right: inset,
          child: Text(l10n.dirExtro, style: style),
        ),
        Positioned(
          top: inset,
          left: inset,
          child: Text(l10n.dirCreative, style: style),
        ),
        Positioned(
          bottom: inset,
          left: inset,
          child: Text(l10n.dirIntro, style: style),
        ),
        Positioned(
          bottom: inset,
          right: inset,
          child: Text(l10n.dirLogic, style: style),
        ),
      ],
    );
  }
}

class _TitleEdgePainter extends CustomPainter {
  _TitleEdgePainter({
    required this.titles,
    required this.ownedIds,
    required this.canvasPoint,
  });

  final List<TitleDef> titles;
  final Set<String> ownedIds;
  final Offset Function(TitleDef title) canvasPoint;

  @override
  void paint(Canvas canvas, Size size) {
    final byId = {for (final t in titles) t.id: t};
    final drawn = <String>{};

    for (final title in titles) {
      final from = canvasPoint(title);
      for (final neighborId in title.neighbors) {
        final key = title.id.compareTo(neighborId) < 0
            ? '${title.id}|$neighborId'
            : '$neighborId|${title.id}';
        if (drawn.contains(key)) continue;
        drawn.add(key);

        final neighbor = byId[neighborId];
        if (neighbor == null) continue;
        final to = canvasPoint(neighbor);
        final ownedLink =
            ownedIds.contains(title.id) && ownedIds.contains(neighborId);
        final paint = Paint()
          ..color = ownedLink ? kTitleMapOwnedEdgeColor : kTitleMapEdgeColor
          ..strokeWidth =
              ownedLink ? kTitleMapOwnedEdgeWidth : kTitleMapEdgeWidth
          ..style = PaintingStyle.stroke;
        canvas.drawLine(from, to, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TitleEdgePainter oldDelegate) {
    return oldDelegate.titles != titles || oldDelegate.ownedIds != ownedIds;
  }
}

class _TitleNode extends StatelessWidget {
  const _TitleNode({
    required this.title,
    required this.center,
    required this.status,
    required this.label,
    required this.onTap,
  });

  final TitleDef title;
  final Offset center;
  final _NodeStatus status;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color fill;
    final Color border;
    final double borderWidth;

    switch (status) {
      case _NodeStatus.locked:
        fill = kTitleMapLockedColor.withValues(alpha: 0.35);
        border = kTitleMapLockedColor;
        borderWidth = 1.5;
      case _NodeStatus.available:
        fill = kTitleMapAvailableColor.withValues(alpha: 0.85);
        border = kTitleMapAvailableColor;
        borderWidth = 2;
      case _NodeStatus.owned:
        fill = kTitleMapOwnedColor.withValues(alpha: 0.9);
        border = kTitleMapOwnedColor;
        borderWidth = 3;
      case _NodeStatus.equipped:
        fill = kTitleMapOwnedColor;
        border = kTitleMapEquippedBorder;
        borderWidth = 3.5;
    }

    final left = center.dx - kTitleMapNodeSize / 2;
    final top = center.dy - kTitleMapNodeSize / 2;

    return Positioned(
      left: left,
      top: top,
      width: kTitleMapNodeSize,
      height: kTitleMapNodeSize,
      child: Material(
        color: fill,
        shape: CircleBorder(
          side: BorderSide(color: border, width: borderWidth),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: TextStyle(
                  fontSize: kTitleMapNodeFontSize,
                  fontWeight: FontWeight.w600,
                  color: status == _NodeStatus.locked
                      ? Colors.black45
                      : Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
