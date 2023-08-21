import 'package:bonfire/bonfire.dart';

class EmptySpriteSheet {
  static Future<SpriteAnimation> get battleField => SpriteAnimation.load(
        "maps/component/SpriteSheet.png",
        SpriteAnimationData.sequenced(
          amount: 5,
          stepTime: 0.2,
          textureSize: Vector2(32, 64),
        ),
      );
}
