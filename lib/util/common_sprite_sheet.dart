import 'package:bonfire/bonfire.dart';

class CommonSpriteSheet {
  static Future<SpriteAnimation> get battlePlayer => SpriteAnimation.load(
        "characters/character_1-3_back.png",
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.6,
          textureSize: Vector2(48, 64),
        ),
      );
  static Future<SpriteAnimation> get battleRival => SpriteAnimation.load(
        "characters/_srw_free_character_2.png",
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.6,
          textureSize: Vector2(48, 64),
        ),
      );
  static Future<SpriteAnimation> get battleMonster => SpriteAnimation.load(
        "monsters/DinoSprites+-+vita (1).png",
        SpriteAnimationData.sequenced(
          amount: 7,
          stepTime: 0.6,
          textureSize: Vector2(24, 64),
        ),
      );
}
