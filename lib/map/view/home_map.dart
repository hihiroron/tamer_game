import 'package:flutter/material.dart';
import 'package:bonfire/bonfire.dart';
import 'package:tamer_game/map/view/old_map.dart';
import 'package:tamer_game/npc/npc_common.dart';
import 'package:tamer_game/npc/npc_girl2.dart';
import 'package:tamer_game/sprite/npc_girl_sprite.dart';
import 'package:tamer_game/player/player_beared_dude.dart';
import 'package:tamer_game/player/player_sprite.dart';
import 'package:tamer_game/util/exit_map_sensor.dart';

class HomeMap extends StatefulWidget {
  const HomeMap({Key? key}) : super(key: key);
  @override
  State<HomeMap> createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> {
  final tileSize = 48.0; // タイルのサイズ定義
  late NpcGirl2 npcGirl2;
  // TODO main修正の際にLayoutBuilder導入
  // ゲーム画面Widget
  // TODO:Mapいっぱい作ると思うからutilとかに雛形クラス作りたい

  @override
  Widget build(BuildContext context) {
    return BonfireWidget(
      onReady: (game) {
        game.addJoystickObserver(npcGirl2);
      },
      showCollisionArea: false, // 当たり判定の可視化
      // マップ用jsonファイル読み込み
      map: WorldMapByTiled(
        'maps/field_map1.json',
        forceTileSize: Vector2(tileSize, tileSize),
        objectsBuilder: {
          // デコレーションを追加
          'girl2': (properties) {
            npcGirl2 = NpcGirl2(
              properties.position, NpcGirlSprite.sheet,
              // 'ここは？',
              initDirection: Direction.left,
              sayList: [
                Say(
                  text: [TextSpan(text: 'ここはどこ？')], // 表示するテキスト
                  personSayDirection: PersonSayDirection.LEFT, // NPCをテキストの左に表示
                ),
                Say(
                  text: [const TextSpan(text: 'さっきまで家にいたはずなのに、、')], // 表示するテキスト
                  personSayDirection: PersonSayDirection.LEFT, // NPCをテキストの左に表示
                ),
              ],
            );
            return npcGirl2;
          },
          'leftSensor': (properties) => ExitMapSensor(
                position: properties.position, // jsonから取得
                size: properties.size, // jsonから取得
                nextMap: const OldMap(), // 移動先のマップ
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
          isFixed: false, // この設定でスティックの固定がなくなる(左半分？)？
          color: Colors.white,
        ),
        actions: [
          // 画面上のアクションボタン追加
          // 以下の場合、アクションボタンはなし？
          // NPCとの会話とかはTiledMapとかを参考に近づいたら話す系かなぁ
          JoystickAction(
            color: Colors.white,
            // ここのIDをNPCとかのjoystickActionと合わせないとトリガーできない
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
