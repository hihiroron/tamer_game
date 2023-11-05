import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tamer_game/common/models/monster.dart';
import 'package:tamer_game/common/providers/app_providers.dart';
import 'package:tamer_game/common/repository/monsters_repository.dart';
import 'package:tamer_game/map/state/battle_map_state.dart';

class BattleMapController extends AutoDisposeAsyncNotifier<BattleMapState> {
  @override
  FutureOr<BattleMapState> build() async {
    // モンスター情報取得
    final monsters = await ref.read(monstersStreamProvider.future);
    // ユーザー情報取得
    // final user = await ref.watch(userStreamProvider.future);
    // モンスター召喚場所更新
    // 最初はブランクにしておく
    final numList = [1, 2, 3, 4, 5, 6, 7, 8];
    List<FieldInfo> fieldInfos = [];
    for (var num in numList) {
      // if (num == 3) {
      //   fieldInfos.add(FieldInfo(
      //     fieldNumber: num,
      //     fieldStatus: FieldStatus.monsterSummon,
      //     monsterId: 1,
      //   ));
      // } else {
      fieldInfos
          .add(FieldInfo(fieldNumber: num, fieldStatus: FieldStatus.blank));
      // }
    }
    // TODO:デッキをデータベースから取得
    // final deckPlayer = user.deck;

    // TODO:デッキをシャッフルする
    // (monsters.toList()..shuffle());
    // final deck = ;

    // ドロー:カードを５枚取得する(デッキのリストをシャッフルしたら良い？やったらクラスリストじゃなくてid管理に方が良さそう)
    // List<Monster> handCardsPlayer = [];
    // for (final cardId in deckPlayer) {
    //   handCardsPlayer
    //       .add(monsters.firstWhere((element) => element.id == cardId));
    // }
    List<Monster> handCardsPlayer = monsters.sublist(0, 2);

    // ライバルドロー:カードを５枚取得する(とりあえずモンスター型やけど帰る必要ありそう)
    List<Monster> handCardsRival = monsters.sublist(0, 2);

    return BattleMapState(
      monsters: monsters,
      handCardsPlayer: handCardsPlayer,
      handCardsRival: handCardsRival,
      hitPointPlayer: 5,
      hitPointRival: 5,
      fieldInfos: fieldInfos,
      isPlayerTurn: true,
      turnNum: 1,
    );
  }

  Future<void> turnEndPlayer() async {
    // 相手ターンの行動
    // ライバル：手札からフィールドに召喚するための召喚先のフィールド４つのループ(ブランクのみ)
    final fieldListTurnStartRival = state.value!.fieldInfos
        .sublist(4, 8)
        .where((element) =>
            (element!.fieldStatus == FieldStatus.monsterAlreadyActed) ||
            (element.fieldStatus == FieldStatus.preparation))
        .toList();
    turnStartField(
      fieldList: fieldListTurnStartRival,
      isPlayer: false,
    );
    // ライバルドロー
    await Future.delayed(const Duration(seconds: 1));
    final random = Random();
    drawCard(
      isPlayer: false,
      handCards: state.value!.handCardsRival,
      deck: state.value!.monsters,
    );

    // ライバル：手札１枚１枚の設定ループ
    final fieldList = state.value!.fieldInfos
        .sublist(4, 8)
        .where((element) => element!.fieldStatus == FieldStatus.blank)
        .toList();
    List toRemove = [];
    for (final handCard in state.value!.handCardsRival) {
      await Future.delayed(const Duration(seconds: 2));
      // ライバル：空いてるフィールドにモンスター召喚
      if (fieldList.isNotEmpty) {
        useHandCard(
          isPlayer: false,
          fNumber: fieldList[random.nextInt(fieldList.length)]!.fieldNumber,
          monsterId: handCard.id,
          hitPoint: handCard.hitPoint,
          toRemove: toRemove,
        );
      }
    }
    // ライバル：ループの中で直接削除したらだめとエラーが出るのでまとめて削除
    state.value!.handCardsRival.removeWhere((e) => toRemove.contains(e));

    // ライバル：動けるモンスターのループ、攻撃してくる。
    for (final fieldInfoRival in state.value!.fieldInfos
        .sublist(4, 8)
        .where((element) => (element!.fieldStatus == FieldStatus.monsterSummon))
        .toList()) {
      await Future.delayed(const Duration(seconds: 2));
      // 届くモンスターだけ入れる
      final fieldListPlayerTarget = state.value!.fieldInfos
          .sublist(0, 4)
          .where((element) =>
              (element!.fieldStatus == FieldStatus.monsterAlreadyActed) ||
              (element.fieldStatus == FieldStatus.monsterSummon))
          .toList();
      // 召喚されてる相手にランダムに攻撃する
      if (fieldListPlayerTarget.isNotEmpty) {
        // 攻撃範囲で届かない場合は選択肢から削除
        final newFieldListPlayerTarget = fieldListPlayerTarget
            .where((element) => isAttackRange(
                  isPlayer: false,
                  fieldNum1: fieldInfoRival!.fieldNumber,
                  fieldNum2: element!.fieldNumber,
                  attackRange: state.value!.monsters
                      .firstWhere((e) => e.id == fieldInfoRival.monsterId)
                      .skill1['range'],
                ))
            .toList();
        // 攻撃可能範囲内にモンスターがいたら攻撃してくる
        if (newFieldListPlayerTarget.isNotEmpty) {
          final targetInfo = fieldListPlayerTarget[
              random.nextInt(fieldListPlayerTarget.length)];
          if (fieldInfoRival != null && targetInfo != null) {
            attackMonster(
              isPlayer: false,
              fNumber1: fieldInfoRival.fieldNumber,
              fNumber2: targetInfo.fieldNumber,
              hitPoint2: targetInfo.hitPoint!,
              power: state.value!.monsters
                  .firstWhere((e) => e.id == fieldInfoRival.monsterId)
                  .skill1['power'],
            );
          }
        } else {
          // 攻撃可能なモンスターがいない場合は空いてる場所に移動する
          final fieldInfoCanMove = state.value!.fieldInfos
              .sublist(4, 8)
              .where((element) => (element!.fieldStatus == FieldStatus.blank))
              .toList();
          if (fieldInfoCanMove.isNotEmpty) {
            monsterMoveField(
              fNumber1: fieldInfoRival!.fieldNumber,
              fNumber2:
                  fieldInfoCanMove[random.nextInt(fieldInfoCanMove.length)]!
                      .fieldNumber,
              monsterId: fieldInfoRival.monsterId,
              hitPoint: fieldInfoRival.hitPoint,
            );
          }
        }
      } else {
        if (fieldInfoRival != null) {
          await attackDirect(
            isPlayer: false,
            fNumberMe: fieldInfoRival.fieldNumber,
            hitPointMaster: state.value!.hitPointPlayer,
            power: state.value!.monsters
                .firstWhere((e) => e.id == fieldInfoRival.monsterId)
                .skill1['power'],
          );
        }
      }
    }

    // ターン数プラス
    await Future.delayed(const Duration(seconds: 1));
    state = AsyncData(state.value!.copyWith(turnNum: state.value!.turnNum + 1));
    // ターンスタートみたいなメソッド、準備中のモンスターは召喚される
    // ターンスタートの時に画面に横長の帯(ターン数の通知みたいなん)出したい、できればターンエンド時も
    final fieldListTurnStartPlayer = state.value!.fieldInfos
        .sublist(0, 4)
        .where((element) =>
            (element!.fieldStatus == FieldStatus.monsterAlreadyActed) ||
            (element.fieldStatus == FieldStatus.preparation))
        .toList();
    await turnStartField(
      fieldList: fieldListTurnStartPlayer,
      isPlayer: true,
    );

    // プレイヤードロー
    await Future.delayed(const Duration(seconds: 2));
    drawCard(
      isPlayer: true,
      handCards: state.value!.handCardsPlayer,
      deck: state.value!.monsters,
    );
  }

  Future<void> turnStartField({
    required List<FieldInfo?> fieldList,
    required bool isPlayer,
  }) async {
    // 行動(ターン)中切り替え
    state = AsyncData(state.value!.copyWith(isPlayerTurn: isPlayer));
    await Future.delayed(const Duration(milliseconds: 300));
    // 行動済をリセット
    for (final field in fieldList) {
      changeField(
        fNumber1: field!.fieldNumber,
        status1: FieldStatus.monsterSummon,
      );
    }
  }

  void drawCard({
    required bool isPlayer,
    required List<Monster> handCards,
    required List<Monster> deck,
  }) {
    if (handCards.length <= 5) {
      final random = Random();
      final newHandCards = handCards;
      Monster newCard = deck[random.nextInt(deck.length)];
      newHandCards.add(newCard);
      state = AsyncData(isPlayer
          ? state.value!.copyWith(handCardsPlayer: newHandCards)
          : state.value!.copyWith(handCardsRival: newHandCards));
    }
  }

  Future<void> attackDirect({
    required bool isPlayer,
    required int fNumberMe,
    required int hitPointMaster,
    required int power,
  }) async {
    // プレイヤー直接攻撃
    // HPを減らす、０以下にならないようにする
    if (isPlayer) {
      state = AsyncData(state.value!.copyWith(
          hitPointRival:
              (hitPointMaster - power) <= 0 ? 0 : (hitPointMaster - power)));
    } else {
      state = AsyncData(state.value!.copyWith(
          hitPointPlayer:
              (hitPointMaster - power) <= 0 ? 0 : (hitPointMaster - power)));
    }

    await Future.delayed(const Duration(milliseconds: 200));
    // 行動済みに変更
    changeField(
      fNumber1: fNumberMe,
      status1: FieldStatus.monsterAlreadyActed,
    );
    if (hitPointMaster == 0) {
      // HPが０になったら演出だして戦闘終了
      // await Future.delayed(const Duration(seconds: 1));
    }
  }

  Future<void> attackMonster({
    required bool isPlayer,
    required int fNumber1,
    required int fNumber2,
    int? hitPoint1,
    required int hitPoint2,
    required int power,
  }) async {
    // HPを減らす、０以下にならないようにする
    final newHitPoint2 = (hitPoint2 - power) <= 0 ? 0 : (hitPoint2 - power);
    // 行動済みに変更、HPが０になったらフィールドから削除
    changeField(
      fNumber1: fNumber1,
      fNumber2: fNumber2,
      status1: FieldStatus.monsterAlreadyActed,
      hitPoint2: newHitPoint2,
    );
    if (newHitPoint2 == 0) {
      // モンスター死亡
      await Future.delayed(const Duration(milliseconds: 200));
      changeField(
        fNumber1: fNumber2,
        status1: FieldStatus.blank,
        monsterId1: null,
        hitPoint1: null,
      );
    }
  }

  Future<void> monsterMoveField({
    required int fNumber1,
    required int fNumber2,
    required int? monsterId,
    required int? hitPoint,
  }) async {
    changeField(
      fNumber1: fNumber1,
      status1: FieldStatus.blank,
      monsterId1: null,
      hitPoint1: null,
      fNumber2: fNumber2,
      status2: FieldStatus.monsterAlreadyActed,
      monsterId2: monsterId,
      hitPoint2: hitPoint,
      // 手札に被りがあった場合引数増やす必要ありそう
    );
  }

  Monster pickMonsterFromId(List<Monster> monsters, int monsterId) {
    return monsters.firstWhere((monster) {
      return monster.id == monsterId;
    });
  }

  void useHandCard({
    required bool isPlayer,
    required int fNumber,
    int? monsterId,
    int? hitPoint,
    List? toRemove,
  }) {
    // フィールドに召喚
    if (monsterId != null) {
      changeField(
        fNumber1: fNumber,
        status1: FieldStatus.preparation,
        monsterId1: monsterId,
        hitPoint1: hitPoint,
        // 手札に被りがあった場合引数増やす必要ありそう
      );
    }
    // 手札からカード削除
    if (isPlayer) {
      state.value!.handCardsPlayer.remove(state.value!.handCardsPlayer
          .firstWhere((element) => element.id == monsterId));
    } else if (toRemove != null) {
      toRemove.add(state.value!.handCardsRival
          .firstWhere((element) => element.id == monsterId));
    }
  }

  void changeField({
    required int fNumber1,
    int? fNumber2,
    FieldStatus? status1,
    FieldStatus? status2,
    int? monsterId1,
    int? monsterId2,
    int? hitPoint1,
    int? hitPoint2,
  }) {
    final battleMapState = state.value!;
    final fieldInfosStates = state.value!.fieldInfos;
    List<FieldInfo> fieldInfoList = [];
    for (final fieldInfoState in fieldInfosStates) {
      // await Future.delayed(const Duration(milliseconds: 100));
      // 変更されたフィールド番号だけstateを更新
      if (fieldInfoState!.fieldNumber == fNumber1) {
        // モンスター死ぬのはこっちだけ(演出でディレイかけるため)
        fieldInfoList.add(
          fieldInfoState.copyWith(
            fieldNumber: fNumber1,
            fieldStatus: status1 ?? fieldInfoState.fieldStatus,
            monsterId: monsterId1 ?? fieldInfoState.monsterId,
            hitPoint: hitPoint1 ?? fieldInfoState.hitPoint,
          ),
        );
      } else if (fieldInfoState.fieldNumber == fNumber2) {
        // １回のアクションで２つ目のフィールド変更がある場合
        fieldInfoList.add(
          fieldInfoState.copyWith(
            fieldNumber: fNumber2,
            fieldStatus: status2 ?? fieldInfoState.fieldStatus,
            monsterId: monsterId2 ?? fieldInfoState.monsterId,
            hitPoint: hitPoint2 ?? fieldInfoState.hitPoint,
          ),
        );
      } else {
        fieldInfoList.add(fieldInfoState);
      }
    }
    // if (turnEnd ?? false) {
    //   state = AsyncData(battleMapState.copyWith(
    //       fieldInfos: fieldInfoList, turnNum: battleMapState.turnNum + 1));
    // } else {
    state = AsyncData(battleMapState.copyWith(fieldInfos: fieldInfoList));
    // }
  }

  bool isAttackRange({
    required bool isPlayer,
    required int fieldNum1,
    required int fieldNum2,
    required String attackRange,
  }) {
    // 攻撃可能な範囲にいない場合はfalseを返す
    if (attackRange == MonsterAttackRange.normal.name) {
      if (fieldNum1 == 1 || fieldNum1 == 5) {
        if (!(fieldNum2 == 3 || fieldNum2 == 4)) return false;
      }
      if (fieldNum1 == 2 || fieldNum1 == 6) {
        if (!(fieldNum2 == 3 || fieldNum2 == 4)) return false;
      }
      if (fieldNum1 == 3 || fieldNum1 == 7) {
        if (!(fieldNum2 == 5 || fieldNum2 == 6)) return false;
      }
      if (fieldNum1 == 4 || fieldNum1 == 8) {
        if (!(fieldNum2 == 5 || fieldNum2 == 6)) return false;
      }
    } else if (attackRange == MonsterAttackRange.skipOne.name) {
      if (fieldNum1 == 7 || fieldNum1 == 8) {
        if (!(fieldNum2 == 3 || fieldNum2 == 4)) return false;
      }
      if (fieldNum1 == 1 || fieldNum1 == 2) {
        if (!(fieldNum2 == 5 || fieldNum2 == 6)) return false;
      }
      if (fieldNum1 == 3 || fieldNum1 == 4) {
        if (!(fieldNum2 == 7 || fieldNum2 == 8)) return false;
      }
      if (fieldNum1 == 5 || fieldNum1 == 6) {
        if (!(fieldNum2 == 1 || fieldNum2 == 2)) return false;
      }
    } else if (attackRange == MonsterAttackRange.skipTwo.name) {
    } else if (attackRange == MonsterAttackRange.frontRow.name) {
    } else if (attackRange == MonsterAttackRange.backRow.name) {}
    return true;
  }
}

final battleMapControllerProvider =
    AsyncNotifierProvider.autoDispose<BattleMapController, BattleMapState>(() {
  final notifier = BattleMapController();
  return notifier;
});
