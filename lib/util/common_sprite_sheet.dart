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
  static Future<SpriteAnimation> get battleMonster1 => SpriteAnimation.load(
        "monsters/DinoSprites+-+vita (1).png",
        SpriteAnimationData.sequenced(
          amount: 7,
          stepTime: 0.6,
          textureSize: Vector2(24, 64),
        ),
      );
  static Future<SpriteAnimation> get battleField => SpriteAnimation.load(
        "maps/component/blacknwhite_p=1_s=2.png",
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.2,
          textureSize: Vector2(32, 64),
        ),
      );
  static Future<SpriteAnimation> get battleMonsterPreparation =>
      SpriteAnimation.load(
        "maps/component/SpriteSheet.png",
        SpriteAnimationData.sequenced(
          amount: 5,
          stepTime: 0.2,
          textureSize: Vector2(32, 64),
        ),
      );
  static Future<SpriteAnimation> get storeMaster => SpriteAnimation.load(
        "characters/store_master.png",
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.6,
          textureSize: Vector2(48, 48),
        ),
      );
}
