import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:tamer_game/util/common_sprite_sheet.dart';

class BattleRival extends GameDecoration with TapGesture {
  BattleRival(Vector2 position)
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
          text: [const TextSpan(text: '相手マスター')],
        ),
        Say(
          text: [const TextSpan(text: '情報を確認できます')],
        )
      ],
      style:
          Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
    );
  }
}
