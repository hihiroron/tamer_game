// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class AppUser {
  AppUser({
    required this.name,
    required this.deck,
    required this.uid,
  });
  final String name;
  final List<dynamic> deck;
  final String uid;

  AppUser copyWith({
    String? name,
    List<dynamic>? deck,
    String? uid,
  }) {
    return AppUser(
      name: name ?? this.name,
      deck: deck ?? this.deck,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'deck': deck,
      'uid': uid,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map, String uid) {
    return AppUser(
      uid: uid,
      name: map['name'] as String,
      deck: List<dynamic>.from(map['deck'] as List<dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'User(name: $name, deck: $deck, uid: $uid)';

  @override
  bool operator ==(covariant AppUser other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        listEquals(other.deck, deck) &&
        other.uid == uid;
  }

  @override
  int get hashCode => name.hashCode ^ deck.hashCode ^ uid.hashCode;
}
