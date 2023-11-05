import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:tamer_game/decorations/battle/battle_map_deco_controller.dart';
import 'package:tamer_game/map/state/battle_map_state.dart';
import 'package:tamer_game/util/common_sprite_sheet.dart';
import 'package:tamer_game/util/single_menu.dart';

class BattleMonsterPreparation extends GameDecoration
    with TapGesture, UseStateController<BattleMapDecoController> {
  // bool _observedPlayer = false;

  // late TextPaint _textConfig;
  BattleMonsterPreparation({required position, required this.data})
      : super.withAnimation(
          animation: CommonSpriteSheet.battleMonsterPreparation,
          size: Vector2(8, 16) * 4,
          position: position,
        );

  BattleMapState data;

  @override
  void onTap() {
    _menu();
  }

  @override
  void onMount() {
    _menu();
  }

  @override
  void update(dt) async {
    for (final fieldInfo in data.fieldInfos) {
      if (fieldInfo!.fieldStatus == FieldStatus.monsterSummon) {
        // 画像を変更
        animation = await CommonSpriteSheet.battleMonster1;
        super.update(dt);
      } else if (fieldInfo.fieldStatus == FieldStatus.preparation) {
        super.update(dt);
      }
    }
  }

  void _menu() {
    for (final fieldInfo in data.fieldInfos) {
      if (fieldInfo!.fieldStatus == FieldStatus.monsterSummon) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const SingleMenu(
              title: Text("data"),
              child: Text("data"),
            );
          },
        );
      } else if (fieldInfo.fieldStatus == FieldStatus.preparation) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const SingleMenu(
              title: Text("data"),
              child: Text("data"),
            );
          },
        );
      }
    }
  }
}
