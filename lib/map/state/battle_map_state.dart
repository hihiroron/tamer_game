// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:tamer_game/common/models/monster.dart';

enum FieldStatus { blank, preparation, monsterSummon, monsterAlreadyActed }

@immutable
class BattleMapState {
  const BattleMapState({
    required this.monsters,
    required this.handCardsPlayer,
    required this.handCardsRival,
    required this.fieldInfos,
    required this.isPlayerTurn,
    required this.turnNum,
    required this.hitPointPlayer,
    required this.hitPointRival,
  });
  final List<Monster> monsters;
  final List<Monster> handCardsPlayer;
  final List<Monster> handCardsRival;
  final List<FieldInfo?> fieldInfos;
  final bool isPlayerTurn;
  final int turnNum;
  final int hitPointPlayer;
  final int hitPointRival;
  // final AsyncValue<void> value;

  BattleMapState copyWith({
    List<Monster>? monsters,
    List<Monster>? handCardsPlayer,
    List<Monster>? handCardsRival,
    List<FieldInfo?>? fieldInfos,
    bool? isPlayerTurn,
    int? turnNum,
    int? hitPointPlayer,
    int? hitPointRival,
  }) {
    return BattleMapState(
      monsters: monsters ?? this.monsters,
      handCardsPlayer: handCardsPlayer ?? this.handCardsPlayer,
      handCardsRival: handCardsRival ?? this.handCardsRival,
      fieldInfos: fieldInfos ?? this.fieldInfos,
      isPlayerTurn: isPlayerTurn ?? this.isPlayerTurn,
      turnNum: turnNum ?? this.turnNum,
      hitPointPlayer: hitPointPlayer ?? this.hitPointPlayer,
      hitPointRival: hitPointRival ?? this.hitPointRival,
    );
  }

  @override
  String toString() {
    return 'BattleMapState(monsters: $monsters, handCardsPlayer: $handCardsPlayer, handCardsRival: $handCardsRival, fieldInfos: $fieldInfos, isPlayerTurn: $isPlayerTurn, turnNum: $turnNum, hitPointPlayer: $hitPointPlayer, hitPointRival: $hitPointRival)';
  }

  // @override
  // bool operator ==(covariant BattleMapState other) {
  //   if (identical(this, other)) return true;

  //   return other.monsters == monsters &&
  //       listEquals(other.fieldInfos, fieldInfos);
  // }

//   @override
//   int get hashCode => monsters.hashCode ^ fieldInfos.hashCode;

  @override
  bool operator ==(covariant BattleMapState other) {
    if (identical(this, other)) return true;

    return listEquals(other.monsters, monsters) &&
        listEquals(other.handCardsPlayer, handCardsPlayer) &&
        listEquals(other.handCardsRival, handCardsRival) &&
        listEquals(other.fieldInfos, fieldInfos) &&
        other.isPlayerTurn == isPlayerTurn &&
        other.turnNum == turnNum &&
        other.hitPointPlayer == hitPointPlayer &&
        other.hitPointRival == hitPointRival;
  }

  @override
  int get hashCode {
    return monsters.hashCode ^
        handCardsPlayer.hashCode ^
        handCardsRival.hashCode ^
        fieldInfos.hashCode ^
        isPlayerTurn.hashCode ^
        turnNum.hashCode ^
        hitPointPlayer.hashCode ^
        hitPointRival.hashCode;
  }
}

class FieldInfo {
  FieldInfo({
    required this.fieldNumber,
    required this.fieldStatus,
    this.monsterId,
    this.hitPoint,
  });
  final int fieldNumber;
  final FieldStatus fieldStatus;
  final int? monsterId;
  final int? hitPoint;

  FieldInfo copyWith({
    int? fieldNumber,
    FieldStatus? fieldStatus,
    int? monsterId,
    int? hitPoint,
  }) {
    return FieldInfo(
      fieldNumber: fieldNumber ?? this.fieldNumber,
      fieldStatus: fieldStatus ?? this.fieldStatus,
      monsterId: monsterId ?? this.monsterId,
      hitPoint: hitPoint ?? this.hitPoint,
    );
  }

  @override
  String toString() {
    return 'FieldInfo(fieldNumber: $fieldNumber, fieldStatus: $fieldStatus, monsterId: $monsterId, hitPoint: $hitPoint)';
  }

  @override
  bool operator ==(covariant FieldInfo other) {
    if (identical(this, other)) return true;

    return other.fieldNumber == fieldNumber &&
        other.fieldStatus == fieldStatus &&
        other.monsterId == monsterId &&
        other.hitPoint == hitPoint;
  }

  @override
  int get hashCode {
    return fieldNumber.hashCode ^
        fieldStatus.hashCode ^
        monsterId.hashCode ^
        hitPoint.hashCode;
  }
}
