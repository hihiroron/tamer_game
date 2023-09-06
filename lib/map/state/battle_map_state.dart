// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tamer_game/common/models/monster.dart';

enum FieldStatus { blank, preparation, monsterSummon }

@immutable
class BattleMapState {
  const BattleMapState({
    required this.monsters,
    required this.fieldInfo,
  });
  final List<Monster> monsters;
  final List<FieldInfo?> fieldInfo;
  // final AsyncValue<void> value;

  BattleMapState copyWith({
    List<Monster>? monsters,
    List<FieldInfo?>? fieldInfo,
  }) {
    return BattleMapState(
      monsters: monsters ?? this.monsters,
      fieldInfo: fieldInfo ?? this.fieldInfo,
    );
  }

  @override
  String toString() =>
      'BattleMapState(monster: $monsters, fieldInfo: $fieldInfo)';

  @override
  bool operator ==(covariant BattleMapState other) {
    if (identical(this, other)) return true;

    return other.monsters == monsters && listEquals(other.fieldInfo, fieldInfo);
  }

  @override
  int get hashCode => monsters.hashCode ^ fieldInfo.hashCode;
}

class FieldInfo {
  FieldInfo({
    required this.fieldNumber,
    required this.fieldStatus,
    this.monsterId,
  });
  final int fieldNumber;
  final FieldStatus fieldStatus;
  final int? monsterId;

  FieldInfo copyWith({
    int? fieldNumber,
    FieldStatus? fieldStatus,
    int? monsterId,
  }) {
    return FieldInfo(
      fieldNumber: fieldNumber ?? this.fieldNumber,
      fieldStatus: fieldStatus ?? this.fieldStatus,
      monsterId: monsterId ?? this.monsterId,
    );
  }

  @override
  String toString() =>
      'FieldInfo(fieldNumber: $fieldNumber, fieldStatus: $fieldStatus, monsterId: $monsterId)';

  @override
  bool operator ==(covariant FieldInfo other) {
    if (identical(this, other)) return true;

    return other.fieldNumber == fieldNumber &&
        other.fieldStatus == fieldStatus &&
        other.monsterId == monsterId;
  }

  @override
  int get hashCode =>
      fieldNumber.hashCode ^ fieldStatus.hashCode ^ monsterId.hashCode;
}
