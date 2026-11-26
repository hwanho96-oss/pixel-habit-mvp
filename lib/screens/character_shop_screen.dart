import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/shop_items.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_state.dart';

class CharacterShopScreen extends StatefulWidget {
  const CharacterShopScreen({super.key});

  @override
  State<CharacterShopScreen> createState() => _CharacterShopScreenState();
}

class _CharacterShopScreenState extends State<CharacterShopScreen>
    with SingleTickerProviderStateMixin {
  static const _categories = ShopCategory.values;

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _onItemAction(ShopItem item) async {
    final state = context.read<AppState>();
    final l10n = AppLocalizations.of(context)!;

    if (!state.ownsItem(item.id)) {
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

  String _equippedSummary(AppLocalizations l10n, AppState state) {
    final parts = <String>[];
    for (final category in _categories) {
      final id = state.equippedId(category);
      final catLabel = ShopCatalog.categoryLabel(l10n, category);
      if (id == null) {
        parts.add('$catLabel: —');
        continue;
      }
      final item = ShopCatalog.byId(id);
      final name = item == null
          ? id
          : ShopCatalog.itemName(l10n, item.nameKey);
      parts.add('$catLabel: $name');
    }
    return parts.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<AppState>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.shopName,
                    style: Theme.of(context).textTheme.titleLarge,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.goldAmount(state.gold),
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.shopEquippedSummary,
                    style: Theme.of(context).textTheme.titleSmall,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _equippedSummary(l10n, state),
                    style: Theme.of(context).textTheme.bodySmall,
                    softWrap: true,
                  ),
                ],
              ),
            ),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: [
                for (final category in _categories)
                  Tab(
                    child: Text(
                      ShopCatalog.categoryLabel(l10n, category),
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  for (final category in _categories)
                    _ItemList(
                      items: ShopCatalog.byCategory(category),
                      ownedIds: state.ownedItemIds,
                      equippedId: state.equippedId(category),
                      onAction: _onItemAction,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemList extends StatelessWidget {
  const _ItemList({
    required this.items,
    required this.ownedIds,
    required this.equippedId,
    required this.onAction,
  });

  final List<ShopItem> items;
  final Set<String> ownedIds;
  final String? equippedId;
  final Future<void> Function(ShopItem item) onAction;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final owned = ownedIds.contains(item.id);
        final equipped = equippedId == item.id;

        final String actionLabel;
        if (!owned) {
          actionLabel = l10n.shopBuy;
        } else if (equipped) {
          actionLabel = l10n.shopEquipped;
        } else {
          actionLabel = l10n.shopEquip;
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ShopCatalog.itemName(l10n, item.nameKey),
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.goldAmount(item.price),
                        style: Theme.of(context).textTheme.bodySmall,
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: TextButton(
                    onPressed: () => onAction(item),
                    child: Text(
                      actionLabel,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
