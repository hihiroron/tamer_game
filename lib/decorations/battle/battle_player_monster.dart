import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:tamer_game/common/models/monster.dart';
import 'package:tamer_game/util/common_sprite_sheet.dart';

class BattlePlayerMonster extends GameDecoration with TapGesture {
  // bool _observedPlayer = false;
  final Monster monster;

  // late TextPaint _textConfig;
  BattlePlayerMonster(Vector2 position, {required this.monster})
      : super.withAnimation(
          animation: CommonSpriteSheet.battleMonster,
          size: Vector2(8, 20) * 10,
          position: position,
        );

  @override
  void onTap() {
    _menu();
  }

  void _menu() {
    TalkDialog.show(
      context,
      [
        Say(
          text: [TextSpan(text: 'モンスター/${monster.monsterName}')],
        ),
        Say(
          text: [const TextSpan(text: '行動を選択できます')],
        )
      ],
      style:
          Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
    );
  }
}
