import 'package:bonfire/bonfire.dart';

class CommonSpriteSheet {
  static Future<SpriteAnimation> get battleCharacter => SpriteAnimation.load(
        "characters/_srw_free_character_1-3.png",
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.6,
          textureSize: Vector2(48, 64),
        ),
      );
}
