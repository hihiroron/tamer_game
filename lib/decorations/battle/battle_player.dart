import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:tamer_game/util/common_sprite_sheet.dart';
import 'package:tamer_game/util/multi_menu.dart';

class BattlePlayer extends GameDecoration with TapGesture {
  // bool _observedPlayer = false;

  // late TextPaint _textConfig;
  BattlePlayer(Vector2 position, this.showPlayerMenu)
      : super.withAnimation(
          animation: CommonSpriteSheet.battlePlayer,
          size: Vector2(8, 16) * 4,
          position: position,
        );
  final MultiMenu showPlayerMenu;

  @override
  void onTap() {
    _menu();
  }

  void _menu() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return showPlayerMenu;
      },
    );
    // TalkDialog.show(
    //   context,
    //   [
    //     Say(
    //       text: [const TextSpan(text: 'マスター')],
    //     ),
    //     Say(
    //       text: [const TextSpan(text: '行動を選択できます')],
    //     )
    //   ],
    //   style:
    //       Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
    // );
  }
}
