import 'package:flutter/material.dart';

import '../data/shop_items.dart';
import '../l10n/app_localizations.dart';

/// Shared character stage used by home and shop.
///
/// Shows equipped gear as layered placeholders (colored blocks / icons + names)
/// until real art assets exist. Title sits above the head; pet nameplate sits
/// above the pet.
class CharacterPreview extends StatelessWidget {
  const CharacterPreview({
    super.key,
    required this.equipped,
    this.equippedTitleName,
  });

  final Map<String, String> equipped;
  final String? equippedTitleName;

  String? _itemName(AppLocalizations l10n, ShopCategory category) {
    final id = equipped[category.name];
    if (id == null) return null;
    final item = ShopCatalog.byId(id);
    if (item == null) return null;
    return ShopCatalog.itemName(l10n, item.nameKey);
  }

  Color _slotColor(ShopCategory category) {
    switch (category) {
      case ShopCategory.top:
        return const Color(0xFF64B5F6);
      case ShopCategory.bottom:
        return const Color(0xFF81C784);
      case ShopCategory.weapon:
        return const Color(0xFFFFB74D);
      case ShopCategory.pet:
        return const Color(0xFFF06292);
      case ShopCategory.background:
        return const Color(0xFFB0BEC5);
    }
  }

  IconData _slotIcon(ShopCategory category) {
    switch (category) {
      case ShopCategory.top:
        return Icons.checkroom;
      case ShopCategory.bottom:
        return Icons.accessibility_new;
      case ShopCategory.weapon:
        return Icons.sports_martial_arts;
      case ShopCategory.pet:
        return Icons.pets;
      case ShopCategory.background:
        return Icons.landscape;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bgId = equipped[ShopCategory.background.name];
    final bgColor = ShopCatalog.backgroundColor(bgId) ??
        Theme.of(context).colorScheme.surfaceContainerHighest;

    final topName = _itemName(l10n, ShopCategory.top);
    final bottomName = _itemName(l10n, ShopCategory.bottom);
    final weaponName = _itemName(l10n, ShopCategory.weapon);
    final petName = _itemName(l10n, ShopCategory.pet);

    return ColoredBox(
      color: bgColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (equippedTitleName != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: _Nameplate(text: equippedTitleName!),
                  ),
                SizedBox(
                  width: 160,
                  height: 150,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        Icons.person,
                        size: 72,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      if (topName != null)
                        Positioned(
                          top: 28,
                          child: _GearChip(
                            color: _slotColor(ShopCategory.top),
                            icon: _slotIcon(ShopCategory.top),
                            label: topName,
                          ),
                        ),
                      if (bottomName != null)
                        Positioned(
                          bottom: 8,
                          child: _GearChip(
                            color: _slotColor(ShopCategory.bottom),
                            icon: _slotIcon(ShopCategory.bottom),
                            label: bottomName,
                          ),
                        ),
                      if (weaponName != null)
                        Positioned(
                          right: 0,
                          top: 40,
                          child: _GearChip(
                            color: _slotColor(ShopCategory.weapon),
                            icon: _slotIcon(ShopCategory.weapon),
                            label: weaponName,
                            compact: true,
                          ),
                        ),
                      if (petName != null)
                        Positioned(
                          left: -8,
                          bottom: 0,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _Nameplate(text: petName, small: true),
                              const SizedBox(height: 4),
                              _GearChip(
                                color: _slotColor(ShopCategory.pet),
                                icon: _slotIcon(ShopCategory.pet),
                                label: petName,
                                compact: true,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Nameplate extends StatelessWidget {
  const _Nameplate({required this.text, this.small = false});

  final String text;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: small ? 88 : 160),
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6 : 10,
        vertical: small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Text(
        text,
        style: (small
                ? Theme.of(context).textTheme.labelSmall
                : Theme.of(context).textTheme.labelMedium)
            ?.copyWith(fontWeight: FontWeight.w600),
        softWrap: true,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _GearChip extends StatelessWidget {
  const _GearChip({
    required this.color,
    required this.icon,
    required this.label,
    this.compact = false,
  });

  final Color color;
  final IconData icon;
  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 36.0 : 48.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color),
          ),
          child: Icon(icon, color: Colors.white, size: compact ? 18 : 22),
        ),
        const SizedBox(height: 2),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: compact ? 64 : 90),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                  shadows: const [
                    Shadow(color: Colors.white70, blurRadius: 4),
                  ],
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
