import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/app_state.dart';
import 'character_shop_screen.dart';
import 'personality_screen.dart';

enum _CharacterPane { shop, personality }

class CharacterTabScreen extends StatefulWidget {
  const CharacterTabScreen({super.key});

  @override
  State<CharacterTabScreen> createState() => _CharacterTabScreenState();
}

class _CharacterTabScreenState extends State<CharacterTabScreen> {
  _CharacterPane _pane = _CharacterPane.shop;

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
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: SegmentedButton<_CharacterPane>(
                      segments: [
                        ButtonSegment(
                          value: _CharacterPane.shop,
                          label: Text(
                            l10n.characterPaneShop,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                        ),
                        ButtonSegment(
                          value: _CharacterPane.personality,
                          label: Text(
                            l10n.characterPanePersonality,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                        ),
                      ],
                      selected: {_pane},
                      onSelectionChanged: (next) {
                        setState(() => _pane = next.first);
                      },
                      showSelectedIcon: false,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      l10n.goldAmount(state.gold),
                      textAlign: TextAlign.end,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _pane == _CharacterPane.shop
                  ? const CharacterShopScreen()
                  : const PersonalityScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
