import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/shop_items.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_state.dart';
import '../ui/layout_config.dart';
import '../widgets/character_preview.dart';

// --- Shop panel / grid constants (easy to tweak) ---
const int kShopGridCrossAxisCount = 3;
const double kShopGridSpacing = 10;
const double kShopPanelRadius = 24;
const Color kShopPanelColor = Color(0xFF455A64);
const double kShopCardRadius = 12;
const Color kShopCardColor = Colors.white;
const Color kShopEquippedBorderColor = Color(0xFFFFB300);
const double kShopEquippedBorderWidth = 2.5;
const Color kShopCategorySelectedBg = Color(0xFF263238);
const Color kShopCategorySelectedFg = Colors.white;
const Color kShopCategoryIdleBg = Colors.white;
const Color kShopCategoryIdleFg = Color(0xFF263238);

/// Shop body inside the character tab (no outer Scaffold).
class CharacterShopScreen extends StatefulWidget {
  const CharacterShopScreen({super.key});

  @override
  State<CharacterShopScreen> createState() => _CharacterShopScreenState();
}

class _CharacterShopScreenState extends State<CharacterShopScreen> {
  ShopCategory _category = ShopCategory.top;

  Future<void> _onItemTap(ShopItem item) async {
    final state = context.read<AppState>();
    final l10n = AppLocalizations.of(context)!;

    if (!state.ownsItem(item.id)) {
      final name = ShopCatalog.itemName(l10n, item.nameKey);
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              l10n.shopBuyConfirmTitle,
              softWrap: true,
            ),
            content: Text(
              l10n.shopBuyConfirmMessage(name, item.price),
              softWrap: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(l10n.shopBuy),
              ),
            ],
          );
        },
      );
      if (confirmed != true || !mounted) return;

      final ok = await state.buyItem(item.id);
      if (!mounted) return;
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.shopNotEnoughGold)),
        );
      }
      return;
    }

    if (state.isEquipped(item.id)) {
      await state.unequip(item.category);
    } else {
      await state.equipItem(item.id);
    }
  }

  IconData _categoryIcon(ShopCategory category) {
    switch (category) {
      case ShopCategory.top:
        return Icons.checkroom;
      case ShopCategory.bottom:
        return Icons.accessibility_new;
      case ShopCategory.weapon:
        return Icons.sports_martial_arts;
      case ShopCategory.background:
        return Icons.landscape;
      case ShopCategory.pet:
        return Icons.pets;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<AppState>();
    final items = ShopCatalog.byCategory(_category);

    final equippedTitleName = () {
      final id = state.equippedTitleId;
      if (id == null) return null;
      final title = state.titleById(id);
      if (title == null) return null;
      return title.localizedName(
        Localizations.localeOf(context).languageCode,
      );
    }();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: (LayoutConfig.shopCharacterAreaRatio * 100).round(),
          child: CharacterPreview(
            equipped: state.equipped,
            equippedTitleName: equippedTitleName,
          ),
        ),
        Expanded(
          flex: ((1 - LayoutConfig.shopCharacterAreaRatio) * 100).round(),
          child: Container(
            decoration: const BoxDecoration(
              color: kShopPanelColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(kShopPanelRadius),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 14, 12, 8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final category in ShopCategory.values) ...[
                          _CategoryPill(
                            label: ShopCatalog.categoryLabel(l10n, category),
                            selected: _category == category,
                            onTap: () => setState(() => _category = category),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: kShopGridCrossAxisCount,
                      crossAxisSpacing: kShopGridSpacing,
                      mainAxisSpacing: kShopGridSpacing,
                      childAspectRatio: 0.78,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final owned = state.ownsItem(item.id);
                      final equipped = state.isEquipped(item.id);
                      return _ShopItemCard(
                        name: ShopCatalog.itemName(l10n, item.nameKey),
                        icon: _categoryIcon(item.category),
                        priceLabel: l10n.shopItemPrice(item.price),
                        owned: owned,
                        equipped: equipped,
                        equippedLabel: l10n.shopEquipped,
                        onTap: () => _onItemTap(item),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? kShopCategorySelectedBg : kShopCategoryIdleBg,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: selected
                      ? kShopCategorySelectedFg
                      : kShopCategoryIdleFg,
                  fontWeight: FontWeight.w600,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ),
      ),
    );
  }
}

class _ShopItemCard extends StatelessWidget {
  const _ShopItemCard({
    required this.name,
    required this.icon,
    required this.priceLabel,
    required this.owned,
    required this.equipped,
    required this.equippedLabel,
    required this.onTap,
  });

  final String name;
  final IconData icon;
  final String priceLabel;
  final bool owned;
  final bool equipped;
  final String equippedLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kShopCardColor,
      borderRadius: BorderRadius.circular(kShopCardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(kShopCardRadius),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kShopCardRadius),
            border: equipped
                ? Border.all(
                    color: kShopEquippedBorderColor,
                    width: kShopEquippedBorderWidth,
                  )
                : null,
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Center(
                        child: Icon(
                          icon,
                          size: 36,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      owned
                          ? (equipped
                              ? equippedLabel
                              : AppLocalizations.of(context)!.shopEquip)
                          : priceLabel,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: equipped
                                ? kShopEquippedBorderColor
                                : Colors.black54,
                          ),
                    ),
                  ],
                ),
              ),
              if (equipped)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: kShopEquippedBorderColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      equippedLabel,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 9,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
