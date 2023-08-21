import 'package:flutter/material.dart';
import 'package:bonfire/bonfire.dart';
import 'package:tamer_game/decorations/battle/battle_monster_field.dart';
import 'package:tamer_game/decorations/battle/battle_player.dart';
import 'package:tamer_game/decorations/battle/battle_player_monster.dart';
import 'package:tamer_game/decorations/battle/battle_rival.dart';
import 'package:tamer_game/util/simple_menu.dart';

class BattleMap extends StatefulWidget {
  const BattleMap({Key? key}) : super(key: key);

  @override
  State<BattleMap> createState() => _BattleMapState();
}

class _BattleMapState extends State<BattleMap> {
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
  }

  @override
  Widget build(BuildContext context
      // , WidgetRef ref
      ) {
    // ゲーム画面Widget
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
            decorations: decorations(),
            // コンポーネントしか追加できん
            // onReady: (game) {game.add(component)},
            // カメラ設定
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
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
              ),
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
  }

  static List<GameDecoration> decorations() {
    // キャラクター配置
    final list = [
      BattlePlayer(getRelativeTilePosition(4, 10)),
      BattleRival(getRelativeTilePosition(5, 8)),
    ];
    if (field1) {
      // モンスター召喚時はモンスターを描画
    } else {
      // 非召喚時はフィールドオブジェクトを描画
      list.add(BattleMonsterField(getRelativeTilePosition(2, 10)));
    }

    return list;
  }

  static Vector2 getRelativeTilePosition(int x, int y) {
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
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
            ),
            height: double.infinity,
            width: 61.4,
            child: const Text(
              "カード",
              style: TextStyle(
                backgroundColor: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: Colors.black,
              ),
            ),
          ),
        ),
      );
    }
    return list;
  }
}
