import 'package:flutter/material.dart';
import 'package:bonfire/bonfire.dart';
import 'package:tamer_game/util/extension.dart';

class ExitMapSensor extends GameDecoration with Sensor {
  ExitMapSensor(
      {required Vector2 position, required Vector2 size, required this.nextMap})
      : super(position: position, size: size);
  // 移動先のマップ
  Widget nextMap;
  // 連続実行防止用
  bool hasContact = false;

  @override
  void onContact(component) {
    if (!hasContact && component is Player) {
      hasContact = true;
      context.goTo(nextMap);
    }
  }
}
