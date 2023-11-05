import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamer_game/common/models/app_user.dart';
import 'package:tamer_game/common/repository/auth_repository.dart';
import 'package:tamer_game/common/repository/user_repository.dart';
import 'package:tamer_game/common/services/package_info_service.dart';

final firestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final functionsProvider = Provider<FirebaseFunctions>(
    (ref) => FirebaseFunctions.instanceFor(region: "asia-northeast1"));

final storageProvider =
    Provider<FirebaseStorage>((ref) => FirebaseStorage.instance);

final storageRefProvider =
    Provider<Reference>((ref) => FirebaseStorage.instance.ref());

final functionsCallableProvider =
    Provider.family<HttpsCallable, String>((ref, name) {
  return ref.read(functionsProvider).httpsCallable(name);
});

final userStreamProvider = StreamProvider<AppUser>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) return const Stream.empty();
  return ref.read(userRepositoryProvider).userStream(uid: user.uid);
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final packageInfoServiceProvider = Provider<PackageInfoService>((ref) {
  throw UnimplementedError();
});

final remoteConfigProvider = Provider<FirebaseRemoteConfig>((ref) {
  final rc = FirebaseRemoteConfig.instance;
  const interval = Duration(minutes: 15);
  rc.setConfigSettings((RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: interval,
  )));
  return rc;
});
