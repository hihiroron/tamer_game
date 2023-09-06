// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum MonsterAttackRange { normal, skipOne, skipTwo, knight }

class Monster {
  Monster({
    required this.uid,
    required this.id,
    required this.monsterName,
    required this.hitPoint,
    required this.skill1,
    this.skill2,
    this.skill3,
    required this.createdAt,
  });
  final String uid;
  final int id;
  final String monsterName;
  final int hitPoint;
  final Map<String, dynamic> skill1;
  final Map<String, dynamic>? skill2;
  final Map<String, dynamic>? skill3;
  final Timestamp createdAt;

  Monster copyWith({
    String? uid,
    int? id,
    String? monsterName,
    int? hitPoint,
    Map<String, dynamic>? skill1,
    Map<String, dynamic>? skill2,
    Map<String, dynamic>? skill3,
    Timestamp? createdAt,
  }) {
    return Monster(
      uid: uid ?? this.uid,
      id: id ?? this.id,
      monsterName: monsterName ?? this.monsterName,
      hitPoint: hitPoint ?? this.hitPoint,
      skill1: skill1 ?? this.skill1,
      skill2: skill2 ?? this.skill2,
      skill3: skill3 ?? this.skill3,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'id': id,
      'monsterName': monsterName,
      'hitPoint': hitPoint,
      'skill1': skill1,
      'skill2': skill2,
      'skill3': skill3,
      'createdAt': createdAt,
    };
  }

  factory Monster.fromMap(Map<String, dynamic> map, String uid) {
    return Monster(
      uid: uid,
      id: map['id'] as int,
      monsterName: map['monsterName'] as String,
      hitPoint: map['hitPoint'] as int,
      skill1: Map<String, dynamic>.from(map['skill1'] as Map<String, dynamic>),
      skill2: map['skill2'] != null
          ? Map<String, dynamic>.from(map['skill2'] as Map<String, dynamic>)
          : null,
      skill3: map['skill3'] != null
          ? Map<String, dynamic>.from(map['skill3'] as Map<String, dynamic>)
          : null,
      createdAt: map['createdAt'] as Timestamp,
    );
  }
}
