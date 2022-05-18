import 'package:cloud_firestore/cloud_firestore.dart';

class MyFirebase {
  static FirebaseFirestore f = FirebaseFirestore.instance;

  static void read(String path) {
    f.collection(path).snapshots();
  }

  static Future write(String path, String id, Map<String, dynamic> data) async {
    await f.collection(path).doc(id).set(data);
  }
}