import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class MyFirebase {
  static FirebaseFirestore f = FirebaseFirestore.instance;
  static FirebaseStorage s = FirebaseStorage.instance;

  static Future<Map<String, dynamic>?> readOnce(String path, String id) async {
    var snapshot = await f.collection(path).doc(id).get();
    return snapshot.data();
  }

  static Widget readContinuously({
    required String path,
    String? id,
    required AsyncWidgetBuilder<dynamic> builder,
  }) {
    Stream<Object> stream = id == null
        ? f.collection(path).snapshots()
        : f.collection(path).doc(id).snapshots();

    return StreamBuilder(
      stream: stream,
      builder: builder,
    );
  }

  static Future write(String path, String id, Map<String, dynamic> data) async {
    await f.collection(path).doc(id).set(data);
  }

  static void uploadImage(String imageUrl) {

  }
}