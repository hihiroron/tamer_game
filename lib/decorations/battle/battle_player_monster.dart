import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:tamer_game/common/models/monster.dart';
import 'package:tamer_game/util/common_sprite_sheet.dart';

class BattlePlayerMonster extends GameDecoration
    with TapGesture, ObjectCollision {
  // bool _observedPlayer = false;
  final Monster monster;

  // late TextPaint _textConfig;
  BattlePlayerMonster(Vector2 position, {required this.monster})
      : super.withAnimation(
          animation: CommonSpriteSheet.battleMonster1,
          size: Vector2(8, 20) * 10,
          position: position,
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
              size: Vector2(12, 18), align: Vector2(18, 78)),
        ],
      ),
    );
  }

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

  @override
  void update(dt) async {
    setupCollision(
      CollisionConfig(collisions: []),
    );
    // キノコ取得済みなら
    super.update(dt);
  }
}
