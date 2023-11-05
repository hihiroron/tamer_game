import 'package:bonfire/bonfire.dart';

class NpcGothGuySprite {
  static late SpriteSheet sheet;

  // ゲーム起動時に実行するメソッド
  static Future<void> load() async {
    sheet = await _create('characters/gothGuy.png');
  }

  // 画像からSpriteSheetを生成するメソッド
  static Future<SpriteSheet> _create(String path) async {
    final image = await Flame.images.load(path);
    return SpriteSheet.fromColumnsAndRows(image: image, columns: 3, rows: 4);
  }
}
