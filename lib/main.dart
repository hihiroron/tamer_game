import 'dart:async';

import 'package:bonfire/bonfire.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tamer_game/decorations/battle/bar_life_controller.dart';
import 'package:tamer_game/map/view/home_map.dart';
import 'package:tamer_game/npc/npc_girl_sprite.dart';
import 'package:tamer_game/player/player_sprite.dart';

Future<void> main() async {
  // 最初に初期化することを保証することをFlutterに通知
  WidgetsFlutterBinding.ensureInitialized();
  // membersアプリで使用されてる
  // await runZonedGuarded(() => null, (error, stack) {});
  // iOSでは横画面にする
  if (!kIsWeb) {
    // await Flame.device.setLandscape();
    // TODO:画面からプレイヤーが出ないようにする
    await Flame.device.fullScreen();
  }
  // firebase初期化
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );

  BonfireInjector().put((i) => BarLifeController());

  // TODO:mapとかキャラ全部をfuture実行したsnapshot.dataとかに入れて、ロードするようにする。
  // アセットからSpriteSheetを生成
  await PlayerSpriteSheet.load();
  await NpcGirlSprite.load();
  // プレイヤーの状態管理で必要？
  // BonfireInjector().put((i) => BearedDudeController());
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tamer_game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // TODO:Homeみたいなん作ってmapはmapだけにする。
      home: const HomeMap(),
    );
  }
}
