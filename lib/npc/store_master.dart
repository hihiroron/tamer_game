import 'package:bonfire/base/bonfire_game_interface.dart';
import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:tamer_game/util/common_sprite_sheet.dart';

class StoreMaster extends SimpleNpc with ObjectCollision, JoystickListener {
  StoreMaster(
    Vector2 position,
    SpriteSheet spriteSheet, {
    this.npcFunc,
    required this.sayList,
    // required this.storeMaster,
  }) : super(
          // アニメーションの設定
          animation: SimpleDirectionAnimation(
            idleDown: spriteSheet
                .createAnimation(row: 0, stepTime: 0.4, from: 1, to: 3)
                .asFuture(),
            idleLeft: spriteSheet
                .createAnimation(row: 0, stepTime: 0.4, from: 1, to: 3)
                .asFuture(),
            idleRight: spriteSheet
                .createAnimation(row: 0, stepTime: 0.4, from: 1, to: 3)
                .asFuture(),
            idleUp: spriteSheet
                .createAnimation(row: 0, stepTime: 0.4, from: 1, to: 3)
                .asFuture(),
            runDown: spriteSheet
                .createAnimation(row: 0, stepTime: 0.1, from: 1, to: 3)
                .asFuture(),
            runLeft: spriteSheet
                .createAnimation(row: 0, stepTime: 0.1, from: 1, to: 3)
                .asFuture(),
            runRight: spriteSheet
                .createAnimation(row: 0, stepTime: 0.1, from: 1, to: 3)
                .asFuture(),
            runUp: spriteSheet
                .createAnimation(row: 0, stepTime: 0.1, from: 1, to: 3)
                .asFuture(),
          ), // 表示サイズ、初期位置と方向、移動スピード (歩行時)
          size: Vector2(8, 16) * 4,
          position: position,
          speed: 32,
        ) {
    // 当たり判定の設定
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(sizeNpc.x, sizeNpc.y * 0.5),
            align: Vector2(0, sizeNpc.y * 0.5),
          ),
        ],
      ),
    );
  }

  final List<Say> sayList;
  final void Function()? npcFunc;
  // final StoreMaster storeMaster;
  // プレイヤーが近くにいるかどうか
  bool _seePlayer = false;
  // 視野の半径
  static const radiusVision = 54.0;
  static final sizeNpc = Vector2(16, 23) * 2;

  @override
  void update(double dt) {
    super.update(dt);

    // Playerとの距離に応じて処理を実行
    seePlayer(
      // 視野の半径
      radiusVision: radiusVision,
      // プレイヤーが視野内にいる時
      observed: (player) {
        // 接近時に一度だけ実行する処理
        if (!_seePlayer) {
          _seePlayer = true;
        }
      },
      // プレイヤーが視野内にいない時
      notObserved: () {
        if (_seePlayer) {
          _seePlayer = false;
        }
      },
    );
  }

  // @override
  // void onContact(GameComponent component) {
  //   // プレイヤーが接触したら
  //   if (component is storeMaster) {
  //     // 画面から消える
  //     removeFromParent();
  //   }
  // }

  // キーボードやボタンの押下で実行する処理
  @override
  void joystickAction(JoystickActionEvent event) async {
    if ((event.id == 1 || event.id) &&
        event.event == ActionEvent.DOWN &&
        _seePlayer) {
      _showTalk();
    }
    super.joystickAction(event);
  }

  void _showTalk() {
    gameRef.camera.moveToTargetAnimated(this); // カメラをNPCに向ける
    TalkDialog.show(
      context,
      // テキストの量だけ`Say()`を配列に追加する
      sayList,
      // テキストのスタイル
      style:
          Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
      // 会話終了後にカメラをプレイヤーに戻す
      onFinish: () {
        if (npcFunc != null) {
          Future(() {
            return npcFunc!();
          });
        }
        gameRef.camera.moveToTargetAnimated(gameRef.player!);
      },
    );
  }
}
