import 'package:flutter/material.dart' show Color;

import '../l10n/app_localizations.dart';

enum ShopCategory {
  top,
  bottom,
  weapon,
  background,
  pet,
}

class ShopItem {
  const ShopItem({
    required this.id,
    required this.category,
    required this.nameKey,
    required this.price,
  });

  final String id;
  final ShopCategory category;
  final String nameKey;
  final int price;
}

/// Shop catalog — [shopName] and item [ShopItem.nameKey] are arb keys.
class ShopCatalog {
  /// Arb key for the shop title.
  static const String shopName = 'shopName';

  static const List<ShopItem> items = [
    // Top
    ShopItem(
      id: 'top_plain_shirt',
      category: ShopCategory.top,
      nameKey: 'itemTopPlainShirt',
      price: 30,
    ),
    ShopItem(
      id: 'top_hoodie',
      category: ShopCategory.top,
      nameKey: 'itemTopHoodie',
      price: 80,
    ),
    ShopItem(
      id: 'top_armor',
      category: ShopCategory.top,
      nameKey: 'itemTopArmor',
      price: 150,
    ),
    // Bottom
    ShopItem(
      id: 'bottom_shorts',
      category: ShopCategory.bottom,
      nameKey: 'itemBottomShorts',
      price: 30,
    ),
    ShopItem(
      id: 'bottom_jeans',
      category: ShopCategory.bottom,
      nameKey: 'itemBottomJeans',
      price: 70,
    ),
    ShopItem(
      id: 'bottom_armor_pants',
      category: ShopCategory.bottom,
      nameKey: 'itemBottomArmorPants',
      price: 140,
    ),
    // Weapon
    ShopItem(
      id: 'weapon_stick',
      category: ShopCategory.weapon,
      nameKey: 'itemWeaponStick',
      price: 40,
    ),
    ShopItem(
      id: 'weapon_sword',
      category: ShopCategory.weapon,
      nameKey: 'itemWeaponSword',
      price: 100,
    ),
    ShopItem(
      id: 'weapon_staff',
      category: ShopCategory.weapon,
      nameKey: 'itemWeaponStaff',
      price: 180,
    ),
    // Background
    ShopItem(
      id: 'bg_meadow',
      category: ShopCategory.background,
      nameKey: 'itemBgMeadow',
      price: 50,
    ),
    ShopItem(
      id: 'bg_city',
      category: ShopCategory.background,
      nameKey: 'itemBgCity',
      price: 90,
    ),
    ShopItem(
      id: 'bg_castle',
      category: ShopCategory.background,
      nameKey: 'itemBgCastle',
      price: 160,
    ),
    // Pet
    ShopItem(
      id: 'pet_cat',
      category: ShopCategory.pet,
      nameKey: 'itemPetCat',
      price: 60,
    ),
    ShopItem(
      id: 'pet_dog',
      category: ShopCategory.pet,
      nameKey: 'itemPetDog',
      price: 100,
    ),
    ShopItem(
      id: 'pet_dragon',
      category: ShopCategory.pet,
      nameKey: 'itemPetDragon',
      price: 200,
    ),
  ];

  static ShopItem? byId(String id) {
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

  static List<ShopItem> byCategory(ShopCategory category) {
    return items.where((e) => e.category == category).toList();
  }

  static String categoryLabel(AppLocalizations l10n, ShopCategory category) {
    switch (category) {
      case ShopCategory.top:
        return l10n.categoryTop;
      case ShopCategory.bottom:
        return l10n.categoryBottom;
      case ShopCategory.weapon:
        return l10n.categoryWeapon;
      case ShopCategory.background:
        return l10n.categoryBackground;
      case ShopCategory.pet:
        return l10n.categoryPet;
    }
  }

  static String itemName(AppLocalizations l10n, String nameKey) {
    switch (nameKey) {
      case 'itemTopPlainShirt':
        return l10n.itemTopPlainShirt;
      case 'itemTopHoodie':
        return l10n.itemTopHoodie;
      case 'itemTopArmor':
        return l10n.itemTopArmor;
      case 'itemBottomShorts':
        return l10n.itemBottomShorts;
      case 'itemBottomJeans':
        return l10n.itemBottomJeans;
      case 'itemBottomArmorPants':
        return l10n.itemBottomArmorPants;
      case 'itemWeaponStick':
        return l10n.itemWeaponStick;
      case 'itemWeaponSword':
        return l10n.itemWeaponSword;
      case 'itemWeaponStaff':
        return l10n.itemWeaponStaff;
      case 'itemBgMeadow':
        return l10n.itemBgMeadow;
      case 'itemBgCity':
        return l10n.itemBgCity;
      case 'itemBgCastle':
        return l10n.itemBgCastle;
      case 'itemPetCat':
        return l10n.itemPetCat;
      case 'itemPetDog':
        return l10n.itemPetDog;
      case 'itemPetDragon':
        return l10n.itemPetDragon;
      default:
        return nameKey;
    }
  }

  /// Placeholder tint when a background item is equipped on home.
  static Color? backgroundColor(String? itemId) {
    switch (itemId) {
      case 'bg_meadow':
        return const Color(0xFFA8D5A2);
      case 'bg_city':
        return const Color(0xFFB0BEC5);
      case 'bg_castle':
        return const Color(0xFFD7CCC8);
      default:
        return null;
    }
  }
}
