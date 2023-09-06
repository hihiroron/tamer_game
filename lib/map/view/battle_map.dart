import 'package:flutter/material.dart';
import 'package:bonfire/bonfire.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tamer_game/common/models/monster.dart';
import 'package:tamer_game/decorations/battle/bar_life_controller.dart';
import 'package:tamer_game/decorations/battle/bar_life_widget.dart';
import 'package:tamer_game/decorations/battle/battle_monster_field.dart';
import 'package:tamer_game/decorations/battle/battle_player.dart';
import 'package:tamer_game/decorations/battle/battle_player_monster.dart';
import 'package:tamer_game/decorations/battle/battle_rival.dart';
import 'package:tamer_game/decorations/battle/knight_interface.dart';
import 'package:tamer_game/map/controller/battle_map_controller.dart';
import 'package:tamer_game/map/state/battle_map_state.dart';
import 'package:tamer_game/util/simple_menu.dart';

class BattleMap extends ConsumerStatefulWidget {
  const BattleMap({Key? key}) : super(key: key);

  @override
  BattleMapSt createState() => BattleMapSt();
}

class BattleMapSt extends ConsumerState<BattleMap> {
  static double tileSize = 40.0; // タイルのサイズ定義
  // モンスター状況
  static bool field1 = false;

  @override
  void initState() {
    // BonfireWidgetにgameControllerオプションも考慮
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TalkDialog.show(
        context,
        [
          Say(
            text: [const TextSpan(text: '戦闘開始！')],
          ),
        ],
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Colors.white),
      );
    });
    BonfireInjector().put((i) => BarLifeController());
  }

  @override
  Widget build(BuildContext context) {
    // ゲーム画面Widget
    // final a = ref.watch();
    final state = ref.watch(battleMapControllerProvider);
    return state.when(
      data: (data) {
        return Scaffold(
          body: Stack(
            children: <Widget>[
              BonfireWidget(
                showCollisionArea: false, // 当たり判定の可視化
                // マップ用jsonファイル読み込み
                map: WorldMapByTiled(
                  'maps/forestBackGround.json',
                  forceTileSize: Vector2(tileSize, tileSize),
                  objectsBuilder: {},
                ),
                decorations: decorations(data),
                // コンポーネントしか追加できん
                // onReady: (game) {game.add(component)},
                // カメラ設定
                overlayBuilderMap: {
                  'barLife': (context, game) => const BarLifeWidget(
                        left: 30,
                        top: 110,
                      ),
                  'barLife2': (context, game) => const BarLifeWidget(
                        left: 290,
                        top: 560,
                      ),
                },
                initialActiveOverlays: const [
                  'barLife',
                  'barLife2',
                ],
                interface: MasterInterface(),
                cameraConfig: CameraConfig(
                  moveOnlyMapArea: true,
                  sizeMovementWindow: Vector2.zero(),
                  smoothCameraEnabled: true,
                  smoothCameraSpeed: 10,
                ),
                // エラーになる
                // overlayBuilderMap: TalkDialog.show(
                //   context,
                //   [
                //     Say(
                //       text: [const TextSpan(text: '戦闘開始！')], // 表示するテキスト
                //     ),
                //     Say(
                //       text: [const TextSpan(text: '戦闘中・・・')], // 表示するテ
                //     ), // 表示するアニメーション
                //   ],
                //   style: Theme.of(context)
                //       .textTheme
                //       .titleLarge!
                //       .copyWith(color: Colors.white),
                // ),
                // 結局インターフェイスしか追加できん
                // interface: GameInterface(),
                // ロード中の画面の設定
                progress: Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  color: Colors.black,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                ),
                width: double.infinity,
                height: 100,
                // margin: const EdgeInsets.all(3),
                // color: Colors.pink,
                child: const Text(
                  "汎用エリア",
                  style: TextStyle(
                    backgroundColor: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  // decoration: BoxDecoration(
                  //   border: Border.all(color: Colors.white, width: 2),
                  // ),
                  width: double.infinity,
                  height: 120,
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 15),
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  // margin: const EdgeInsets.all(3),
                  // color: Colors.pink,
                  child: Scaffold(
                    body: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: getCardList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Dialog(
        child: Text("エラーです：$e"),
      ),
    );
  }

  List<GameDecoration> decorations(BattleMapState data) {
    // final controller = await ref.read(battleMapControllerProvider.future);
    // キャラクター配置
    final list = [
      BattlePlayer(getRelativeTilePosition(4, 10)),
      BattleRival(getRelativeTilePosition(5, 8)),
    ];
    if (field1) {
      // モンスター召喚時はモンスターを描画
    } else {
      // 非召喚時はフィールドオブジェクトを描画
      // list.add(BattleMonsterField(getRelativeTilePosition(2, 10)));
      list.add(
        BattlePlayerMonster(
          getRelativeTilePosition(1.3, 10),
          monster: pickMonsterFromId(data.monsters, 2),
        ),
      );
    }

    return list;
  }

  Monster pickMonsterFromId(List<Monster> monsters, int monsterId) {
    return monsters.firstWhere((monster) {
      return monster.id == monsterId;
    });
  }

  static Vector2 getRelativeTilePosition(double x, double y) {
    return Vector2(
      (x * tileSize).toDouble(),
      (y * tileSize).toDouble(),
    );
  }

  List<Widget> getCardList() {
    // 手札取得
    final List<Widget> list = [];

    // モンスター、マジックストリームからカード情報を読み取る

    for (int i = 0; i < 6; i++) {
      list.add(
        // GestureDetector( 色変えたいのでinkWellを使用
        InkWell(
          highlightColor: Colors.pink,
          splashColor: Colors.red,
          focusColor: Colors.yellow,
          hoverColor: Colors.blue,
          onTap: () {
            // 押されたらメニューと、カードがちょっと上がりたい
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const SimpleMenu();
              },
            );
          },
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              border: Border.all(color: Colors.white, width: 1.3),
              // boxShadow: const [cardBoxShadow],
              color: Colors.black26,
            ),
            height: double.infinity,
            width: 62,
            child: Image.asset(
              "assets/images/monsters/DinoSprites+-+vita.png",
              fit: BoxFit.contain,
            ),
            // const Text(
            //   "カード",
            //   style: TextStyle(
            //     backgroundColor: Colors.white,
            //     fontWeight: FontWeight.bold,
            //     fontSize: 10,
            //     color: Colors.black,
            //   ),
            // ),
          ),
        ),
      );
    }
    return list;
  }
}
