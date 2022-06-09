import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class MyFirebase {
  static FirebaseFirestore f = FirebaseFirestore.instance;
  static FirebaseStorage s = FirebaseStorage.instance;

  static Future<List<Map<String, dynamic>>> readCollection(String path) async {
    var snapshot = await f.collection(path).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  static Future<Map<String, dynamic>?> readData(String path, String id) async {
    var snapshot = await f.collection(path).doc(id).get();
    return snapshot.data();
  }

  static Future<List<Map<String, dynamic>>> readSubCollection(String firstPath, String id, String secondPath) async {
    var snapshot = await f.collection(firstPath).doc(id).collection(secondPath).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  static Widget readOnce({
    required String path,
    String? id,
    required AsyncWidgetBuilder<dynamic> builder,
  }) {
    Future<Object> future = id == null
        ? f.collection(path).get()
        : f.collection(path).doc(id).get();

    return FutureBuilder(
      future: future,
      builder: builder,
    );
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

  static Future remove(String path, String id) async {
    f.collection(path).doc(id).delete();
  }

  static Future<String> uploadImage(String path, String id, File? file) async {
    if (file == null) return '';
    Reference ref = s.ref('$path/$id');
    TaskSnapshot task = await ref.putFile(file);
    return await task.ref.getDownloadURL();
  }

  static Future removeImage(String path, String id) async {
    await s.ref('$path/$id').delete();
  }
}