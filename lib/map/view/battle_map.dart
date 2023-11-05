import 'package:flutter/material.dart';
import 'package:bonfire/bonfire.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tamer_game/common/list/monster_map.dart';
import 'package:tamer_game/common/models/monster.dart';
import 'package:tamer_game/decorations/battle/bar_life_controller.dart';
import 'package:tamer_game/decorations/battle/bar_life_widget.dart';
import 'package:tamer_game/decorations/battle/battle_map_deco_controller.dart';
import 'package:tamer_game/decorations/battle/battle_monster_field.dart';
import 'package:tamer_game/decorations/battle/battle_monster_preparation.dart';
import 'package:tamer_game/decorations/battle/battle_player.dart';
import 'package:tamer_game/decorations/battle/battle_player_monster.dart';
import 'package:tamer_game/decorations/battle/battle_rival.dart';
import 'package:tamer_game/decorations/battle/knight_interface.dart';
import 'package:tamer_game/util/multi_menu.dart';
import 'package:tamer_game/map/controller/battle_map_controller.dart';
import 'package:tamer_game/map/state/battle_map_state.dart';
import 'package:tamer_game/map/view/home_map.dart';
import 'package:tamer_game/util/extension.dart';
import 'package:tamer_game/util/single_menu.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
    // BonfireInjector().put((i) => BarLifeController());
    BonfireInjector().put((i) => BattleMapDecoController());
  }

  @override
  Widget build(BuildContext context) {
    // ゲーム画面Widget
    // final a = ref.watch();
    ref.listen<AsyncValue<BattleMapState?>>(
        battleMapControllerProvider, (prev, next) {});
    final state = ref.watch(battleMapControllerProvider);
    // 書き込み用
    final controller = ref.watch(battleMapControllerProvider.notifier);
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
                decorations: decorations(data, controller),
                // コンポーネントしか追加できん
                // onReady: (game) {
                //   _addField(game, data);
                // },
                // カメラ設定
                // overlayBuilderMap: {
                //   'barLife': (context, game) => const BarLifeWidget(
                //         left: 30,
                //         top: 110,
                //       ),
                //   'barLife2': (context, game) => const BarLifeWidget(
                //         left: 290,
                //         top: 560,
                //       ),
                // },
                // initialActiveOverlays: const [
                //   'barLife',
                //   'barLife2',
                // ],
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
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'ターン：${data.turnNum.toString()}',
                        style: TextStyle(
                          backgroundColor: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        '相手手札：${data.handCardsRival.length}',
                        style: TextStyle(
                          backgroundColor: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        '行動中：${data.isPlayerTurn ? '自分' : '相手'}',
                        style: TextStyle(
                          backgroundColor: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Center(
              //   child: Text(
              //     state.value!.fieldInfos[2]!.fieldStatus.name +
              //         "  ~   " +
              //         data.fieldInfos[2]!.fieldNumber.toString() +
              //         " : " +
              //         data.fieldInfos[2]!.fieldStatus.name +
              //         'turnNum' +
              //         data.turnNum.toString(),
              //     style: TextStyle(
              //       backgroundColor: Colors.white,
              //       fontWeight: FontWeight.bold,
              //       fontSize: 10,
              //       color: Colors.black,
              //     ),
              //   ),
              // ),
              Stack(
                children: _addField(data, controller),
              ),
              Align(
                alignment: Alignment(-0.80, -0.60),
                child: Text(
                  '💙: ${data.hitPointRival}/5',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),

              Align(
                alignment: Alignment(0.75, 0.57),
                child: Text(
                  '❤️: ${data.hitPointPlayer}/5',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  context.goTo(const HomeMap());
                  // List<Monster>? list = data.monstersOfHandCards;
                  // list.removeRange(0, 1);
                  // state = AsyncData(data.copyWith(monstersOfHandCards: list));
                },
                child: Text('マップ画面へ'),
              ),
              // ターン数表示
              Align(
                alignment: Alignment(0.85, -0.50),
                child: Text(data.turnNum.toString()),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  // decoration: BoxDecoration(
                  //   border: Border.all(color: Colors.white, width: 2),
                  // ),
                  width: double.infinity,
                  height: 120,
                  margin: const EdgeInsets.fromLTRB(8, 0, 8, 15),
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  // margin: const EdgeInsets.all(3),
                  // color: Colors.pink,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                      ),
                    ),
                    child: Scaffold(
                      backgroundColor: Colors.blueGrey,
                      body: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: _getCardList(controller, data),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.black,
          color: Colors.black,
        ),
      ),
      error: (e, _) => Dialog(
        child: Text(
          "エラーです\n$e",
          style: const TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }

  List<Widget> dialogOptionMonsterAttackField({
    required Map<int, String> location,
    required BattleMapState data,
    required int fieldNumMe,
    required int monsterIdMe,
    required BattleMapController controller,
    required String attackRange,
  }) {
    // 攻撃する相手フィールドの情報を取得
    final List<Widget> itemListRivalMonster = [];
    // range外消したよフラグ
    bool isDeleteChoice = false;
    // 相手フィールド４つのループ
    for (final fieldInfo in data.fieldInfos.sublist(4, 8)) {
      // モンスターがいるフィールドのみメニューに表示
      if (fieldInfo!.fieldStatus == FieldStatus.monsterSummon ||
          fieldInfo.fieldStatus == FieldStatus.monsterAlreadyActed) {
        if (controller.isAttackRange(
          isPlayer: true,
          fieldNum1: fieldNumMe,
          fieldNum2: fieldInfo.fieldNumber,
          attackRange: attackRange,
        )) {
          itemListRivalMonster.insert(
            0,
            SimpleDialogOption(
              child: Text(
                "${location[fieldInfo.fieldNumber]}",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                // ２画面戻る
                int count = 0;
                Navigator.popUntil(context, (_) => count++ >= 2);
                await controller.attackMonster(
                  isPlayer: true,
                  fNumber1: fieldNumMe,
                  fNumber2: fieldInfo.fieldNumber,
                  hitPoint2: fieldInfo.hitPoint!,
                  power: data.monsters
                      .firstWhere((e) => e.id == monsterIdMe)
                      .skill1['power'],
                );
              },
            ),
          );
        } else {
          isDeleteChoice = true;
        }
      }
    }
    if (itemListRivalMonster.isEmpty && !isDeleteChoice) {
      // 直接攻撃
      itemListRivalMonster.insert(
        0,
        SimpleDialogOption(
          child: const Text(
            "相手プレイヤー",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          onPressed: () async {
            // ２画面戻る
            int count = 0;
            Navigator.popUntil(context, (_) => count++ >= 2);
            await controller.attackDirect(
              isPlayer: true,
              fNumberMe: fieldNumMe,
              hitPointMaster: data.hitPointRival,
              power: data.monsters
                  .firstWhere((e) => e.id == monsterIdMe)
                  .skill1['power'],
            );
          },
        ),
      );
    }
    return itemListRivalMonster;
  }

  SimpleDialogOption dialogOptionMonsterAttack({
    required String skillName,
    required List<Widget> itemList,
  }) {
    return SimpleDialogOption(
      child: Text(
        skillName,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return MultiMenu(
              title: const Text(
                "攻撃する敵の場所",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              itemList: itemList,
            );
          },
        );
      },
    );
  }

  List<Widget> dialogOptionMonsterMoveField({
    required Map<int, String> location,
    required List<FieldInfo?> fieldInfoCanMove,
    required int fieldNumMe,
    required int monsterIdMe,
    required BattleMapController controller,
    required int? hitPoint,
  }) {
    // 移動するフィールドの情報を取得
    final List<Widget> itemListMonsterMove = [];
    // 移動可能なフィールドのループ
    for (final fieldInfo in fieldInfoCanMove) {
      itemListMonsterMove.insert(
        0,
        SimpleDialogOption(
          child: Text(
            "${location[fieldInfo!.fieldNumber]}",
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          onPressed: () async {
            // ２画面戻る
            int count = 0;
            Navigator.popUntil(context, (_) => count++ >= 2);
            controller.monsterMoveField(
              fNumber1: fieldNumMe,
              fNumber2: fieldInfo.fieldNumber,
              monsterId: monsterIdMe,
              hitPoint: hitPoint,
            );
          },
        ),
      );
    }
    return itemListMonsterMove;
  }

  SimpleDialogOption dialogOptionMonsterMove({
    required String skillName,
    required List<Widget> itemList,
  }) {
    return SimpleDialogOption(
      child: Text(
        skillName,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return MultiMenu(
              title: const Text(
                "移動する場所",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              itemList: itemList,
            );
          },
        );
      },
    );
  }

  // void _addField(BonfireGame game, BattleMapState data) {
  //   final Map<int, dynamic> positionMonsterX = {
  List<Widget> _addField(BattleMapState data, BattleMapController controller) {
    List<Widget> list = [];
    final Map<int, String> location1 = {
      1: "左下 : ↙",
      2: "右下 : ↘︎",
      3: "左上 : ↖︎",
      4: "右上 : ↗︎",
    };
    final Map<int, String> location2 = {
      5: "左下 : ↙",
      6: "右下 : ↘︎",
      7: "左上 : ↖︎",
      8: "右上 : ↗︎",
    };
    final Map<int, dynamic> positionMonsterX = {
      1: -0.80,
      2: 0.15, // 3: -0.57,
      3: -0.34, // 4: 0.39,
      4: 0.15, // 5: -0.34,
      5: -0.11, // 6: 0.63,
      6: 0.39,
      7: -0.11,
      8: 0.85,
    };
    final Map<int, dynamic> positionMonsterY = {
      1: 0.36,
      2: 0.57, // 3: 0.04,
      3: 0.10, // 4: 0.25,
      4: 0.19, // 5: -0.28,
      5: -0.22, // 6: -0.07,
      6: -0.13,
      7: -0.60,
      8: -0.39,
    };
    // final Map<int, dynamic> positionPreX = {
    //   1: 0.9,
    //   2: 5.3,
    //   3: 2.0,
    //   4: 6.4,
    //   5: 3.1,
    //   6: 7.5,
    //   7: 4.2,
    //   8: 8.6,
    // };
    // final Map<int, dynamic> positionPreY = {
    //   1: 13.0,
    //   2: 15.0,
    //   3: 10.0,
    //   4: 12.0,
    //   5: 7.0,
    //   6: 9.0,
    //   7: 4.0,
    //   8: 6.0,
    // };

    for (final fieldInfo in data.fieldInfos) {
      if (fieldInfo!.fieldStatus == FieldStatus.monsterSummon ||
          fieldInfo.fieldStatus == FieldStatus.monsterAlreadyActed) {
        final monster =
            data.monsters.firstWhere((e) => e.id == fieldInfo.monsterId);
        // モンスター召喚時はモンスターを描画
        // モンスターはプレイヤーとライバルので分けて、向き替える
        final List<Widget> itemList = [];
        // モンスタータップ時のメニュー
        itemList.add(
          dialogOptionMonsterAttack(
            skillName: '攻撃1 : ${monster.skill1['name']}',
            itemList: dialogOptionMonsterAttackField(
              location: location2,
              data: data,
              fieldNumMe: fieldInfo.fieldNumber,
              monsterIdMe: fieldInfo.monsterId!,
              controller: controller,
              attackRange: monster.skill1['range'],
            ),
          ),
        );
        if (monster.skill2 != null) {
          itemList.add(
            dialogOptionMonsterAttack(
              skillName: '攻撃2 : ${monster.skill2!['name']}',
              itemList: dialogOptionMonsterAttackField(
                location: location2,
                data: data,
                fieldNumMe: fieldInfo.fieldNumber,
                monsterIdMe: fieldInfo.monsterId!,
                controller: controller,
                attackRange: monster.skill2!['range'],
              ),
            ),
          );
        }
        if (monster.skill3 != null) {
          itemList.add(
            dialogOptionMonsterAttack(
              skillName: '攻撃3 : ${monster.skill3!['name']}',
              itemList: dialogOptionMonsterAttackField(
                location: location2,
                data: data,
                fieldNumMe: fieldInfo.fieldNumber,
                monsterIdMe: fieldInfo.monsterId!,
                controller: controller,
                attackRange: monster.skill3!['range'],
              ),
            ),
          );
        }
        itemList.add(
          dialogOptionMonsterMove(
            skillName: '移動',
            itemList: dialogOptionMonsterMoveField(
              location: location1,
              fieldInfoCanMove: data.fieldInfos
                  .sublist(0, 4)
                  .where(
                      (element) => (element!.fieldStatus == FieldStatus.blank))
                  .toList(),
              fieldNumMe: fieldInfo.fieldNumber,
              monsterIdMe: fieldInfo.monsterId!,
              controller: controller,
              hitPoint: fieldInfo.hitPoint,
            ),
          ),
        );
        itemList.add(SimpleDialogOption(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "もどる",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ));
        list.add(
          Align(
            alignment: Alignment(positionMonsterX[fieldInfo.fieldNumber],
                positionMonsterY[fieldInfo.fieldNumber]),
            child: SizedBox(
              height: 50,
              child: GestureDetector(
                onTap: () {
                  // 行動済みのモンスターはタップしても反応しないようにする
                  // 相手モンスターのメニューは表示されない
                  if (fieldInfo.fieldStatus !=
                          FieldStatus.monsterAlreadyActed &&
                      fieldInfo.fieldNumber <= 4) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return MultiMenu(
                          title: Text(
                            monster.monsterName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          itemList: itemList,
                        );
                      },
                    );
                  }
                },
                child: ColorFiltered(
                  colorFilter: fieldInfo.fieldStatus ==
                          FieldStatus.monsterAlreadyActed
                      ? const ColorFilter.mode(Colors.grey, BlendMode.modulate)
                      : ColorFilter.mode(
                          Colors.white.withOpacity(0), BlendMode.srcATop),
                  child: Image.asset(
                    "assets/images/monsters/${monsterMap[fieldInfo.monsterId]}.png",
                    fit: BoxFit.contain,
                  )
                      .animate(
                        onPlay: (controller) => controller.repeat(),
                      )
                      .shakeY(
                        // delay: 1.seconds,
                        duration: 1.seconds,
                        hz: 1.4,
                        amount: 3,
                      ),
                ),
              ),
            ),
          ),
        );
        list.add(
          Align(
            alignment: Alignment(positionMonsterX[fieldInfo.fieldNumber] - 0.1,
                positionMonsterY[fieldInfo.fieldNumber] + 0.11),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(177, 255, 255, 255),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                // border: Border.all(color: Colors.blueGrey),
              ),
              height: 17,
              width: 50,
              child: Text(
                "HP:${fieldInfo.hitPoint.toString()}",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      } else if (fieldInfo.fieldStatus == FieldStatus.preparation) {
        // 準備中は準備エフェクト？描画
        // とりあえずフィールドと同じにしてます
        list.add(
          Align(
            alignment: Alignment(positionMonsterX[fieldInfo.fieldNumber],
                positionMonsterY[fieldInfo.fieldNumber]),
            child: Image.asset("assets/images/maps/component/SpriteSheet.png")
                .animate(
                  onPlay: (controller) => controller.repeat(),
                )
                .shakeY(
                  // delay: 1.seconds,
                  duration: 1.seconds,
                  hz: 1.4,
                  amount: 3,
                ),
          ),
        );
      } else if (fieldInfo.fieldStatus == FieldStatus.blank) {
        // 非召喚時はフィールドオブジェクトを描画
        list.add(
          Align(
            alignment: Alignment(positionMonsterX[fieldInfo.fieldNumber],
                positionMonsterY[fieldInfo.fieldNumber]),
            child: SizedBox(
              height: 50,
              child: Image.asset(
                  "assets/images/maps/component/blacknwhite_p=1_s=2.png"),
            ),
          ),
        );
      }
    }
    return list;
  }

  List<GameDecoration> decorations(
      BattleMapState data, BattleMapController controller) {
    // キャラクター配置
    final list = [
      BattlePlayer(
        getRelativeTilePosition(3.2, 13.5),
        MultiMenu(
          title: Text(
            "プレイヤー名",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          itemList: [
            SimpleDialogOption(
              child: const Text(
                '行動終了',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                controller.turnEndPlayer();
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      BattleRival(getRelativeTilePosition(6, 4.9)),
      // BattlePlayer(getRelativeTilePosition(6, 10)),
      // BattleRival(getRelativeTilePosition(5, 8)),
    ];

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

  List<Widget> _getCardList(
      BattleMapController controller, BattleMapState data) {
    // 手札取得
    final List<Widget> cards = [];
    final Map<int, String> location = {
      1: "左下 : ↙",
      2: "右下 : ↘︎",
      3: "左上 : ↖︎",
      4: "右上 : ↗︎",
    };

    // モンスター、マジックストリームからカード情報を読み取る

    // ここでドローして手札のリストを更新する

    // 手札１枚１枚の設定ループ
    for (final handCard in data.handCardsPlayer) {
      // カードを召喚するフィールドの情報を取得
      final List<Widget> itemList = [];
      // 手札からフィールドに召喚するための召喚先のフィールド４つのループ
      for (final fieldInfo in data.fieldInfos.sublist(0, 4)) {
        // 空のフィールドのみメニューに表示
        if (fieldInfo!.fieldStatus == FieldStatus.blank) {
          itemList.insert(
            0,
            SimpleDialogOption(
              child: Text(
                "${location[fieldInfo.fieldNumber]}",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                controller.useHandCard(
                  isPlayer: true,
                  fNumber: fieldInfo.fieldNumber,
                  monsterId: handCard.id,
                  hitPoint: handCard.hitPoint,
                );
                // ２画面戻る
                int count = 0;
                Navigator.popUntil(context, (_) => count++ >= 2);
              },
            ),
          );
        }
      }

      cards.add(
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
                return SingleMenu(
                  title: Text(
                    handCard.monsterName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text(
                    "召喚",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return MultiMenu(
                          title: const Text(
                            "召喚場所",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          itemList: itemList,
                        );
                      },
                    );
                  },
                );
              },
            );
          },
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(6.0)),
              border: Border.all(color: Colors.black, width: 2.3),
              // boxShadow: const [cardBoxShadow],
              color: Colors.black26,
            ),
            height: double.infinity,
            width: 62,
            child: Image.asset(
              "assets/images/monsters/${monsterMap[handCard.id]}.png",
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
    return cards;
  }
}
