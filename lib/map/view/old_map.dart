import 'package:flutter/material.dart';
import 'package:bonfire/bonfire.dart';
import 'package:tamer_game/map/view/battle_map.dart';
import 'package:tamer_game/npc/npc_girl.dart';
import 'package:tamer_game/npc/npc_girl_sprite.dart';
import 'package:tamer_game/player/player_beared_dude.dart';
import 'package:tamer_game/player/player_sprite.dart';
import 'package:tamer_game/util/exit_map_sensor.dart';

class OldMap extends StatefulWidget {
  const OldMap({Key? key}) : super(key: key);
  @override
  State<OldMap> createState() => _OldMapState();
}

class _OldMapState extends State<OldMap> {
  final tileSize = 48.0; // タイルのサイズ定義

  @override
  Widget build(BuildContext context) {
    late NpcGirl npcGirl;
    // TODO main修正の際にLayoutBuilder導入
    // ゲーム画面Widget
    return BonfireWidget(
      onReady: (game) {
        game.addJoystickObserver(npcGirl);
      },
      showCollisionArea: false, // 当たり判定の可視化
      // マップ用jsonファイル読み込み
      map: WorldMapByTiled(
        'maps/old_map1.json',
        forceTileSize: Vector2(tileSize, tileSize),
        objectsBuilder: {
          // デコレーションを追加
          'girl': (properties) {
            npcGirl = NpcGirl(
              properties.position,
              NpcGirlSprite.sheet,
              initDirection: Direction.left,
            );
            return npcGirl;
          },
          'leftSensor': (properties) => ExitMapSensor(
                position: properties.position, // jsonから取得
                size: properties.size, // jsonから取得
                nextMap: const BattleMap(), // 移動先のマップ
              ),
        },
      ),
      // プレイヤーキャラクター
      player: PlayerBeardedDude(
        Vector2(tileSize * 2, tileSize * 7),
        spriteSheet: PlayerSpriteSheet.all,
        initDirection: Direction.right,
      ),
      // カメラ設定
      cameraConfig: CameraConfig(
        moveOnlyMapArea: true,
        sizeMovementWindow: Vector2.zero(),
        smoothCameraEnabled: true,
        smoothCameraSpeed: 10,
      ),
      // 入力インターフェースの設定
      joystick: Joystick(
        // 画面上のジョイスティック追加
        directional: JoystickDirectional(
          color: Colors.white,
        ),
        actions: [
          // 画面上のアクションボタン追加
          JoystickAction(
            color: Colors.white,
            actionId: 1,
            margin: const EdgeInsets.all(65),
          ),
        ],
      ),
      // ロード中の画面の設定
      progress: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        color: Colors.black,
      ),
    );
  }
}
