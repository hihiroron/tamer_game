import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tamer_game/common/models/monster.dart';
import 'package:tamer_game/common/repository/monsters_repository.dart';
import 'package:tamer_game/map/state/battle_map_state.dart';

class BattleMapController extends AutoDisposeAsyncNotifier<BattleMapState> {
  @override
  FutureOr<BattleMapState> build() async {
    // モンスター情報取得
    final monsters = await ref.read(monstersStreamProvider.future);
    // モンスター召喚場所更新
    // 最初はブランクにしておく
    final numList = [1, 2, 3, 4, 5, 6, 7, 8];
    List<FieldInfo> fieldInfo = [];
    for (var num in numList) {
      fieldInfo
          .add(FieldInfo(fieldNumber: num, fieldStatus: FieldStatus.blank));
    }
    return BattleMapState(
      monsters: monsters,
      fieldInfo: fieldInfo,
    );
  }

  Monster pickMonsterFromId(List<Monster> monsters, int monsterId) {
    return monsters.firstWhere((monster) {
      return monster.id == monsterId;
    });
  }
}

final battleMapControllerProvider =
    AsyncNotifierProvider.autoDispose<BattleMapController, BattleMapState>(() {
  final notifier = BattleMapController();
  return notifier;
});
