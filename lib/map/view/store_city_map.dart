import 'package:bonfire/base/bonfire_game_interface.dart';
import 'package:flutter/material.dart';
import 'package:bonfire/bonfire.dart';
import 'package:tamer_game/map/view/home_map.dart';
import 'package:tamer_game/map/view/old_map.dart';
import 'package:tamer_game/map/view/school_map.dart';
import 'package:tamer_game/npc/npc_common.dart';
import 'package:tamer_game/npc/store_master.dart';
import 'package:tamer_game/object/gacha.dart';
import 'package:tamer_game/sprite/ncp1_sprite.dart';
import 'package:tamer_game/sprite/ncp2_sprite.dart';
import 'package:tamer_game/sprite/ncp3_sprite.dart';
import 'package:tamer_game/sprite/ncp4_sprite.dart';
import 'package:tamer_game/sprite/ncp5_sprite.dart';
import 'package:tamer_game/sprite/ncp6_sprite.dart';
import 'package:tamer_game/sprite/npc_girl_sprite.dart';
import 'package:tamer_game/player/player_beared_dude.dart';
import 'package:tamer_game/player/player_sprite.dart';
import 'package:tamer_game/sprite/store_master_sprite.dart';
import 'package:tamer_game/util/exit_map_sensor.dart';
import 'package:tamer_game/util/extension.dart';
import 'package:tamer_game/util/multi_menu.dart';
import 'package:tamer_game/util/yes_no_menu.dart';

import '../../sprite/npc_gothGuy_sprite.dart';

class StoreCityMap extends StatefulWidget {
  const StoreCityMap({Key? key}) : super(key: key);
  @override
  State<StoreCityMap> createState() => _StoreCityMapState();
}

class _StoreCityMapState extends State<StoreCityMap> {
  final tileSize = 48.0; // タイルのサイズ定義
  late NpcCommon npc1;
  late StoreMaster storeMaster;
  // TODO main修正の際にLayoutBuilder導入
  // ゲーム画面Widget
  // TODO:Mapいっぱい作ると思うからutilとかに雛形クラス作りたい

  @override
  void initState() {
    // BonfireWidgetにgameControllerオプションも考慮
    super.initState();
    Npc1Sprite.load();
    StoreMasterSprite.load();
  }

  @override
  Widget build(BuildContext context) {
    return BonfireWidget(
      showCollisionArea: false, // 当たり判定の可視化
      // マップ用jsonファイル読み込み
      map: WorldMapByTiled(
        'maps/store_city.json',
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
                    return YesNoMenu(
                      title: "移動しますか？",
                      onPressedYes: () => context.goTo(const HomeMap()),
                      onPressedNo: () {
                        Navigator.pop(context);
                        // gameRef.camera.moveToTargetAnimated(gameRef.player!);
                      },
                    );
                  },
                );
              },
              sayList: [
                Say(
                  text: [const TextSpan(text: 'カード買えたか？')], // 表示するテキスト
                ),
                Say(
                  text: [const TextSpan(text: '買えたんならお前ん家行こうぜ。')], // 表示するテキスト
                ),
              ],
            );
            return npc1;
          },
          'storeMaster': (properties) {
            storeMaster = StoreMaster(
              properties.position,
              StoreMasterSprite.sheet,
              // 'ここは？',
              // storeMaster: properties.,
              sayList: [
                Say(
                  text: [const TextSpan(text: 'いらっしゃい。')], // 表示するテキスト
                ),
                Say(
                  text: [const TextSpan(text: '好きに見ていきなさい。')], // 表示するテキスト
                ),
                Say(
                  text: [
                    const TextSpan(text: 'そういえば、店内にたまに見たことのないカードガチャがあるらしい。')
                  ], // 表示するテキスト
                ),
                Say(
                  text: [
                    const TextSpan(text: '1度見た者は2度と見れないそうだから見つけたら逃さんようにな。')
                  ], // 表示するテキスト
                ),
              ],
            );
            return storeMaster;
          },
        },
      ),
      onReady: (game) {
        game.addJoystickObserver(npc1);
        game.addJoystickObserver(storeMaster);
        game.add(
          Gacha(
            initPosition: Vector2(tileSize * 14, tileSize * 6),
            objectFunc: () {
              // ガチャ画面に移動
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return YesNoMenu(
                    title: "ガチャを回しますか？",
                    onPressedYes: () => context.goTo(const SchoolMap()),
                    onPressedNo: () {
                      Navigator.pop(context);
                    },
                  );
                },
              );
            },
            sayList: [
              Say(
                text: [const TextSpan(text: 'カードショップへようこそ。')], // 表示するテキスト
              ),
              Say(
                text: [
                  const TextSpan(text: 'ここでは1度だけ無料で10連ガチャが回せます。')
                ], // 表示するテキスト
              ),
            ],
          ),
        );
      },
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
