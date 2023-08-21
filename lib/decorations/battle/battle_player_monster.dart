import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:tamer_game/util/common_sprite_sheet.dart';

class BattlePlayerMonster extends GameDecoration with TapGesture {
  bool _observedPlayer = false;

  late TextPaint _textConfig;
  BattlePlayerMonster(Vector2 position)
      : super.withAnimation(
          animation: CommonSpriteSheet.battleCharacter,
          size: Vector2(8, 16) * 4,
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
          text: [const TextSpan(text: 'モンスター')],
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
