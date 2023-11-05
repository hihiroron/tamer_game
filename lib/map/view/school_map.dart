import 'package:bonfire/base/bonfire_game_interface.dart';
import 'package:flutter/material.dart';
import 'package:bonfire/bonfire.dart';
import 'package:tamer_game/map/view/home_map.dart';
import 'package:tamer_game/map/view/old_map.dart';
import 'package:tamer_game/map/view/store_city_map.dart';
import 'package:tamer_game/npc/npc_common.dart';
import 'package:tamer_game/sprite/ncp1_sprite.dart';
import 'package:tamer_game/sprite/ncp2_sprite.dart';
import 'package:tamer_game/sprite/ncp3_sprite.dart';
import 'package:tamer_game/sprite/ncp4_sprite.dart';
import 'package:tamer_game/sprite/ncp5_sprite.dart';
import 'package:tamer_game/sprite/ncp6_sprite.dart';
import 'package:tamer_game/sprite/npc_girl_sprite.dart';
import 'package:tamer_game/player/player_beared_dude.dart';
import 'package:tamer_game/player/player_sprite.dart';
import 'package:tamer_game/util/exit_map_sensor.dart';
import 'package:tamer_game/util/extension.dart';
import 'package:tamer_game/util/multi_menu.dart';

import '../../sprite/npc_gothGuy_sprite.dart';

class SchoolMap extends StatefulWidget {
  const SchoolMap({Key? key}) : super(key: key);
  @override
  State<SchoolMap> createState() => _SchoolMapState();
}

class _SchoolMapState extends State<SchoolMap> {
  final tileSize = 48.0; // タイルのサイズ定義
  late NpcCommon npc1;
  late NpcCommon npc2;
  late NpcCommon npc3;
  late NpcCommon npc4;
  late NpcCommon npc5;
  late NpcCommon npc6;
  late NpcCommon npc7;
  // TODO main修正の際にLayoutBuilder導入
  // ゲーム画面Widget
  // TODO:Mapいっぱい作ると思うからutilとかに雛形クラス作りたい

  @override
  Widget build(BuildContext context) {
    return BonfireWidget(
      onReady: (game) {
        game.addJoystickObserver(npc1);
        game.addJoystickObserver(npc2);
        game.addJoystickObserver(npc3);
        game.addJoystickObserver(npc4);
        game.addJoystickObserver(npc5);
        game.addJoystickObserver(npc6);
        game.addJoystickObserver(npc7);
      },
      showCollisionArea: false, // 当たり判定の可視化
      // マップ用jsonファイル読み込み
      map: WorldMapByTiled(
        'maps/school_map.json',
        forceTileSize: Vector2(tileSize, tileSize),
        objectsBuilder: {
          // デコレーションを追加
          'npc1': (properties) {
            npc1 = NpcCommon(
              properties.position,
              NpcGothGuySprite.sheet,
              // 'ここは？',
              initDirection: Direction.right,
              npcFunc: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return MultiMenu(
                      title: const Text(
                        "移動しますか？",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      itemList: [
                        SimpleDialogOption(
                          child: const Text(
                            'はい',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            context.goTo(const StoreCityMap());
                          },
                        ),
                        SimpleDialogOption(
                          child: const Text(
                            'いいえ',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            // gameRef.camera
                            //     .moveToTargetAnimated(gameRef.player!);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              sayList: [
                Say(
                  text: [const TextSpan(text: '放課後はカード買いに行く約束だろ？')], // 表示するテキスト
                ),
                Say(
                  text: [const TextSpan(text: '早く行こうぜ！')], // 表示するテキスト
                ),
              ],
            );
            return npc1;
          },
          'npc2': (properties) {
            npc2 = NpcCommon(
              properties.position,
              Npc1Sprite.sheet,
              // 'ここは？',
              initDirection: Direction.right,
              sayList: [
                Say(
                  text: [const TextSpan(text: 'やっと授業終わったね。')], // 表示するテキスト
                ),
              ],
            );
            return npc2;
          },
          'npc3': (properties) {
            npc3 = NpcCommon(
              properties.position,
              Npc2Sprite.sheet,
              // 'ここは？',
              initDirection: Direction.down,
              sayList: [
                Say(
                  text: [const TextSpan(text: '今日はどこ行こっかなぁ。')], // 表示するテキスト
                ),
              ],
            );
            return npc3;
          },
          'npc4': (properties) {
            npc4 = NpcCommon(
              properties.position,
              Npc3Sprite.sheet,
              // 'ここは？',
              initDirection: Direction.right,
              sayList: [
                Say(
                  text: [const TextSpan(text: 'フンフンフーン')], // 表示するテキスト
                ),
              ],
            );
            return npc4;
          },
          'npc5': (properties) {
            npc5 = NpcCommon(
              properties.position,
              Npc4Sprite.sheet,
              // 'ここは？',
              initDirection: Direction.left,
              sayList: [
                Say(
                  text: [const TextSpan(text: 'どうしたの？')], // 表示するテキスト
                ),
              ],
            );
            return npc5;
          },
          'npc6': (properties) {
            npc6 = NpcCommon(
              properties.position,
              Npc5Sprite.sheet,
              // 'ここは？',
              initDirection: Direction.left,
              sayList: [
                Say(
                  text: [const TextSpan(text: 'あぁ疲れたね。')], // 表示するテキスト
                ),
              ],
            );
            return npc6;
          },
          'npc7': (properties) {
            npc7 = NpcCommon(
              properties.position,
              Npc6Sprite.sheet,
              // 'ここは？',
              initDirection: Direction.left,
              sayList: [
                Say(
                  text: [const TextSpan(text: 'カラオケでも行こっかなぁ。')], // 表示するテキスト
                ),
              ],
            );
            return npc7;
          },
        },
      ),
      // プレイヤーキャラクター
      player: PlayerBeardedDude(
        Vector2(tileSize * 8, tileSize * 9),
        spriteSheet: PlayerSpriteSheet.all,
        initDirection: Direction.left,
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
