import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tamer_game/common/models/firestore_batch_data.dart';
import 'package:tamer_game/common/providers/app_providers.dart';

class FirestoreRepository {
  FirestoreRepository({required this.firestore});
  final FirebaseFirestore firestore;

  Future<String> addData({
    required String path,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    final reference = firestore.collection(path);
    final documentSnapshot = await reference.add(data);
    return documentSnapshot.id;
  }

  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    final reference = firestore.doc(path);
    await reference.set(data, SetOptions(merge: merge));
  }

  Future<bool> setDataMultiCollection(List<Map<String, dynamic>> data) async {
    return firestore
        .runTransaction((transaction) async {
          for (final m in data) {
            final reference = firestore.doc(m['path']);
            transaction.set(reference, m['data']);
          }
        })
        .then((_) => true)
        .catchError((_) {
          return false;
        });
  }

  Future<void> batchWrite({
    required String path,
    required List<Map<String, dynamic>> dataList,
    bool merge = false,
  }) async {
    final batch = firestore.batch();
    for (final data in dataList) {
      final reference = firestore.doc('$path/${data['id']}');
      batch.set(reference, data);
    }
    await batch.commit();
  }

  Future<void> batchWriteMultiCollection({
    required List<FirestoreBatchData> dataList,
  }) async {
    final batch = firestore.batch();
    for (final data in dataList) {
      final reference = data.uid == null
          ? firestore.collection(data.collection).doc()
          : firestore.collection(data.collection).doc(data.uid);
      batch.set(reference, data.data, SetOptions(merge: data.merge));
    }
    await batch.commit();
  }

  Future<void> deleteData({required String path}) async {
    final reference = firestore.doc(path);
    await reference.delete();
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentId) builder,
    Query<Map<String, dynamic>>? Function(Query<Map<String, dynamic>>? query)?
        queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    Query<Map<String, dynamic>> query = firestore.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query)!;
    }
    final Stream<QuerySnapshot<Map<String, dynamic>>> snapshots =
        query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .whereType<T>()
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Stream<T> documentStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentId) builder,
  }) {
    final DocumentReference<Map<String, dynamic>> reference =
        firestore.doc(path);
    final Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots =
        reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }

  Future<T> getData<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentId) builder,
  }) async {
    final DocumentReference<Map<String, dynamic>> reference =
        firestore.doc(path);
    final doc = await reference.get();
    return builder(doc.data(), doc.id);
  }

  Future<List<T>> getCollection<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentId) builder,
    Query<Map<String, dynamic>>? Function(Query<Map<String, dynamic>>? query)?
        queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) async {
    Query<Map<String, dynamic>> query = firestore.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query)!;
    }
    final QuerySnapshot<Map<String, dynamic>> snapshots = await query.get();
    final result = snapshots.docs
        .map((element) => builder(element.data(), element.id))
        .where((value) => value != null)
        .toList();
    if (sort != null) {
      result.sort(sort);
    }
    return result;
  }
}

final firestoreRepositoryProvider = Provider<FirestoreRepository>(
  (ref) => FirestoreRepository(
    firestore: ref.read(firestoreProvider),
  ),
);
