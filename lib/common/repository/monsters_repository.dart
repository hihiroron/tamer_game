import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tamer_game/common/models/monster.dart';
import 'package:tamer_game/common/providers/app_providers.dart';
import 'package:tamer_game/common/repository/firestore_repository.dart';

class MonstersRepository extends FirestoreRepository {
  MonstersRepository({required super.firestore});
  final collection = 'monsters';
  String get collectionName => collection;

  Stream<List<Monster>> getMonstersStream() {
    return collectionStream(
      path: collection,
      builder: (data, documentId) {
        return Monster.fromMap(data!, documentId);
      },
      // queryBuilder: (query) => query.where('field', whereIn: [
      //   MonsterAttackRange.normal.name,
      // ]),
      sort: (lhs, rhs) {
        return rhs.id.compareTo(lhs.id);
      },
    );
  }
}

final monstersRepositoryProvider = Provider<MonstersRepository>(
  (ref) => MonstersRepository(
    firestore: ref.read(firestoreProvider),
  ),
);

final monstersStreamProvider = StreamProvider.autoDispose<List<Monster>>((ref) {
  return ref.watch(monstersRepositoryProvider).getMonstersStream();
});
