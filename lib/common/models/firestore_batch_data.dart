// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

// dataクラス作成

class FirestoreBatchData {
  const FirestoreBatchData({
    required this.collection,
    this.uid,
    required this.data,
    required this.merge,
  });

  final String collection;
  final String? uid;
  final Map<String, dynamic>? data;
  final bool merge;

  FirestoreBatchData copyWith({
    String? collection,
    String? uid,
    Map<String, dynamic>? data,
    bool? merge,
  }) {
    return FirestoreBatchData(
      collection: collection ?? this.collection,
      uid: uid ?? this.uid,
      data: data ?? this.data,
      merge: merge ?? this.merge,
    );
  }

  @override
  String toString() {
    return 'FirestoreBatchData(collection: $collection, uid: $uid, data: $data, merge: $merge)';
  }

  @override
  bool operator ==(covariant FirestoreBatchData other) {
    if (identical(this, other)) return true;

    return other.collection == collection &&
        other.uid == uid &&
        mapEquals(other.data, data) &&
        other.merge == merge;
  }

  @override
  int get hashCode {
    return collection.hashCode ^ uid.hashCode ^ data.hashCode ^ merge.hashCode;
  }
}
