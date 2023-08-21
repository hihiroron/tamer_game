import 'package:flutter/material.dart';

// dataクラス作成

class FirebaseBatchData {
  const FirebaseBatchData({
    required this.collection,
    this.uid,
    required this.data,
    required this.merge,
  });

  final String collection;
  final String? uid;
  final Map<String, dynamic>? data;
  final bool merge;
}
