import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NpcGirl extends SimpleNpc
    with ObjectCollision, JoystickListener, AutomaticRandomMovement, Pushable {
  NpcGirl(Vector2 position, SpriteSheet spriteSheet, {required initDirection})
      : super(
          // アニメーションの設定
          animation: SimpleDirectionAnimation(
            idleDown: spriteSheet
                .createAnimation(row: 0, stepTime: 0.4, from: 4, to: 6)
                .asFuture(),
            idleLeft: spriteSheet
                .createAnimation(row: 1, stepTime: 0.4, from: 4, to: 6)
                .asFuture(),
            idleRight: spriteSheet
                .createAnimation(row: 2, stepTime: 0.4, from: 4, to: 6)
                .asFuture(),
            idleUp: spriteSheet
                .createAnimation(row: 3, stepTime: 0.4, from: 4, to: 6)
                .asFuture(),
            runDown: spriteSheet
                .createAnimation(row: 0, stepTime: 0.1, from: 4, to: 6)
                .asFuture(),
            runLeft: spriteSheet
                .createAnimation(row: 1, stepTime: 0.1, from: 4, to: 6)
                .asFuture(),
            runRight: spriteSheet
                .createAnimation(row: 2, stepTime: 0.1, from: 4, to: 6)
                .asFuture(),
            runUp: spriteSheet
                .createAnimation(row: 3, stepTime: 0.1, from: 4, to: 6)
                .asFuture(),
          ),
          // 表示サイズ、初期位置と方向、移動スピード (歩行時)
          size: Vector2(8, 16) * 4,
          position: position,
          initDirection: initDirection,
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

  static final sizeNpc = Vector2(16, 23) * 3;

  // 視野の半径
  static const radiusVision = 54.0;
  // プレイヤーが近くにいるかどうか
  bool _seePlayer = false;

  @override
  void update(double dt) {
    // 会話したいのにNPCが勝手に離れていくのを防ぐ
    if (!_seePlayer) {
      runRandomMovement(
        dt,
        speed: 80,
        maxDistance: (speed * 3).toInt(),
        timeKeepStopped: 200,
      );
    }
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
        _faceToPlayer(player);
      },
      // プレイヤーが視野内にいない時
      notObserved: () {
        if (_seePlayer) {
          _seePlayer = false;
        }
      },
    );
    super.update(dt);
  }

  // キーボードやボタンの押下で実行する処理
  @override
  void joystickAction(JoystickActionEvent event) {
    if ((event.id == 1 || event.id == LogicalKeyboardKey.space.keyId) &&
        event.event == ActionEvent.DOWN &&
        _seePlayer) {
      _showTalk();
    }
    super.joystickAction(event);
  }

  // プレイヤーの方向を見る
  void _faceToPlayer(GameComponent player) {
    // プレイヤーとの位置の差
    final displacement = player.center - center;

    // プレイヤーの位置に応じてアニメーションを変更
    if (displacement.x.abs() > displacement.y.abs()) {
      if (0 < displacement.x) {
        animation!.play(SimpleAnimationEnum.idleRight);
      } else {
        animation!.play(SimpleAnimationEnum.idleLeft);
      }
    } else {
      if (0 < displacement.y) {
        animation!.play(SimpleAnimationEnum.idleDown);
      } else {
        animation!.play(SimpleAnimationEnum.idleUp);
      }
    }
  }

  // TODO:会話を簡単に追加できるような実装を作る
  // 会話テキストを表示するメソッド
  void _showTalk() {
    gameRef.camera.moveToTargetAnimated(this); // カメラをNPCに向ける
    TalkDialog.show(
      context,
      // テキストの量だけ`Say()`を配列に追加する
      [
        Say(
          text: [const TextSpan(text: 'お前は、、？')], // 表示するテキスト
          personSayDirection: PersonSayDirection.LEFT, // NPCをテキストの左に表示
          person: SizedBox(
            width: size.x,
            height: size.y,
            child: animation!.idleDown!.asFuture().asWidget(),
          ), // 表示するアニメーション
        ),
        Say(
          text: [const TextSpan(text: 'こんな森の中で何をしている？')], // 表示するテキスト
          personSayDirection: PersonSayDirection.LEFT, // NPCをテキストの左に表示
          person: SizedBox(
            width: size.x,
            height: size.y,
            child: animation!.idleDown!.asFuture().asWidget(),
          ), // 表示するアニメーション
        ),
        // 必要な数だけSay()を追加
      ],
      // 会話を次に進めるキーの追加
      logicalKeyboardKeysToNext: [LogicalKeyboardKey.space],
      // テキストのスタイル
      style:
          Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
      // 会話終了後にカメラをプレイヤーに戻す
      onFinish: () {
        gameRef.camera.moveToTargetAnimated(gameRef.player!);
      },
    );
  }
}
