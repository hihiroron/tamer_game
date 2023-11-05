import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tamer_game/common/models/monster.dart';
import 'package:tamer_game/common/models/app_user.dart';
import 'package:tamer_game/common/providers/app_providers.dart';
import 'package:tamer_game/common/repository/firestore_repository.dart';

class UserRepository extends FirestoreRepository {
  UserRepository({required super.firestore});
  final collection = 'user';
  String get collectionName => collection;

  Stream<AppUser> userStream({required String uid}) => documentStream(
      path: 'users/$uid',
      builder: (data, documentId) {
        if (data == null) throw Exception();
        return AppUser.fromMap(data, uid);
      });

  Stream<List<AppUser>> getUserStream() {
    return collectionStream(
      path: collection,
      builder: (data, documentId) {
        return AppUser.fromMap(data!, documentId);
      },
      // queryBuilder: (query) => query.where('field', whereIn: [
      //   MonsterAttackRange.normal.name,
      // ]),
      // sort: (lhs, rhs) {
      //   return rhs.id.compareTo(lhs.id);
      // },
    );
  }
}

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(
    firestore: ref.read(firestoreProvider),
  ),
);

// final userStreamProvider = StreamProvider.autoDispose<List<AppUser>>((ref) {
//   return ref.watch(userRepositoryProvider).getUserStream();
// });
