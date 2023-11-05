import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:tamer_game/map/state/battle_map_state.dart';
import 'package:tamer_game/util/common_sprite_sheet.dart';
import 'package:tamer_game/util/single_menu.dart';

class BattleMonsterField extends GameDecoration with TapGesture {
  // bool _observedPlayer = false;

  // late TextPaint _textConfig;
  BattleMonsterField({required position, required this.data})
      : super.withAnimation(
          animation: CommonSpriteSheet.battleField,
          size: Vector2(8, 16) * 4,
          position: position,
        );

  BattleMapState data;

  @override
  void onTap() {
    _menu();
  }

  // @override
  // void update(dt) async {
  //   for (final fieldInfo in data.fieldInfos) {
  //     if (fieldInfo!.fieldStatus == FieldStatus.monsterSummon) {
  //       // 画像を変更
  //       animation = await CommonSpriteSheet.battleMonster1;
  //     }
  //   }
  //   super.update(dt);
  // }

  void _menu() {
    // for (final fieldInfo in data.fieldInfos) {
    // if (fieldInfo!.fieldStatus == FieldStatus.monsterSummon) {
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return const SingleMenu(
    //         title: Text("模写"),
    //         child: Text("モンスタ"),
    //       );
    //     },
    //   );
    // } else if (fieldInfo.fieldStatus == FieldStatus.blank) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const SingleMenu(
          title: Text("ブランク"),
          child: Text("ブランク"),
        );
      },
    );
    // }
    // }
  }
}
