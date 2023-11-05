// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  AuthRepository({
    required this.firebaseAuth,
  });
  FirebaseAuth firebaseAuth;

  Stream<User?> authStateChanges() => firebaseAuth.authStateChanges();
  User? getCurrentUser() => firebaseAuth.currentUser;

  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      debugPrint('#### sign out error ####');
      rethrow;
    }
  }
}

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(
    firebaseAuth: ref.read(firebaseAuthProvider),
  );
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
