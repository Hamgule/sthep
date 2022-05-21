import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyFirebase {
  static FirebaseFirestore f = FirebaseFirestore.instance;

  static void readOnce(String path) {
    f.collection(path).snapshots();
  }

  static Widget readContinuously(String path, AsyncWidgetBuilder<dynamic> builder) {
    var stream = f.collection(path).snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: builder,
    );
  }

  static Future write(String path, String id, Map<String, dynamic> data) async {
    await f.collection(path).doc(id).set(data);
  }
}