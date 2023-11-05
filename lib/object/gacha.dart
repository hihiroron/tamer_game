import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

class Gacha extends GameDecoration with ObjectCollision, Sensor {
  Gacha({
    required this.initPosition,
    this.objectFunc,
    required this.sayList,
  }) : super.withSprite(
          sprite: Sprite.load(imagePath),
          position: initPosition - Vector2(0, -48),
          size: Vector2(8, 16) * 4,
        ) {
    setupSensorArea(areaSensor: [
      CollisionArea.rectangle(size: size, align: Vector2.zero()),
    ]);
  }

  final Vector2 initPosition;
  final List<Say> sayList;
  final void Function()? objectFunc;

  bool _contactPlayer = false;

  static const imagePath = 'objects/seven+eleven+large+example.png';

  @override
  void onContact(GameComponent component) {
    // プレイヤーが接触したら
    if (component is Player) {
      if (!_contactPlayer) {
        // ガチャイベント
        _showTalk();
      }
      _contactPlayer = true;
    }
  }

  void _showTalk() {
    isObjectCollision();
    TalkDialog.show(
      context,
      // テキストの量だけ`Say()`を配列に追加する
      sayList,
      // テキストのスタイル
      style:
          Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
      // 会話終了後にカメラをプレイヤーに戻す
      onFinish: () {
        if (objectFunc != null) {
          Future(() {
            return objectFunc!();
          });
        }
        // 画面から消える
        removeFromParent();
      },
    );
  }
}
