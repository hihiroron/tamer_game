import 'dart:async';

import 'package:bonfire/bonfire.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamer_game/common/providers/app_providers.dart';
import 'package:tamer_game/common/services/package_info_service.dart';
import 'package:tamer_game/decorations/battle/bar_life_controller.dart';
import 'package:tamer_game/decorations/battle/battle_monster_preparation.dart';
import 'package:tamer_game/map/view/home_map.dart';
import 'package:tamer_game/map/view/school_map.dart';
import 'package:tamer_game/sprite/ncp1_sprite.dart';
import 'package:tamer_game/sprite/ncp2_sprite.dart';
import 'package:tamer_game/sprite/ncp3_sprite.dart';
import 'package:tamer_game/sprite/ncp4_sprite.dart';
import 'package:tamer_game/sprite/ncp5_sprite.dart';
import 'package:tamer_game/sprite/ncp6_sprite.dart';
import 'package:tamer_game/sprite/npc_girl_sprite.dart';
import 'package:tamer_game/player/player_sprite.dart';
import 'package:tamer_game/sprite/npc_gothGuy_sprite.dart';

import 'decorations/battle/battle_map_deco_controller.dart';

Future<void> main() async {
  // ios Bundle identifier
  // com.example.tamerGame

  // 最初に初期化することを保証することをFlutterに通知
  WidgetsFlutterBinding.ensureInitialized();
  const deviceKey = String.fromEnvironment('DEVICE_KEY');
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

  if (deviceKey != '') {
    final pref = await SharedPreferences.getInstance();
    pref.setString('device_key', deviceKey);
  }
  final sharedPreferences = await SharedPreferences.getInstance();
  final packageInfoService = PackageInfoService();
  packageInfoService.init();

  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      packageInfoServiceProvider.overrideWithValue(packageInfoService),
    ],
  );

  // container.read(deviceObserverServiceProvider);

  BonfireInjector().put((i) => BarLifeController());
  BonfireInjector().put((i) => BattleMapDecoController());

  // TODO:mapとかキャラ全部をfuture実行したsnapshot.dataとかに入れて、ロードするようにする。
  // アセットからSpriteSheetを生成
  await PlayerSpriteSheet.load();
  await NpcGirlSprite.load();
  await NpcGothGuySprite.load();
  await Npc1Sprite.load();
  await Npc2Sprite.load();
  await Npc3Sprite.load();
  await Npc4Sprite.load();
  await Npc5Sprite.load();
  await Npc6Sprite.load();
  // プレイヤーの状態管理で必要？
  // BonfireInjector().put((i) => BearedDudeController());
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
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
      // home: const HomeMap(),
      home: const SchoolMap(),
    );
  }
}
