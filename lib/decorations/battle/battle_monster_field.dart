import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:tamer_game/util/common_sprite_sheet.dart';
import 'package:tamer_game/util/empty_sprite_sheet.dart';
import 'package:tamer_game/util/simple_menu.dart';

class BattleMonsterField extends GameDecoration with TapGesture {
  bool _observedPlayer = false;

  late TextPaint _textConfig;
  BattleMonsterField(Vector2 position)
      : super.withAnimation(
          animation: EmptySpriteSheet.battleField,
          size: Vector2(8, 16) * 4,
          position: position,
        );

  @override
  void onTap() {
    _menu();
  }

  void _menu() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const SimpleMenu();
      },
    );
  }
}
