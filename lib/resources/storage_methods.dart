import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //adding image

  Future<String> uploadImageToStorage(
    String childName,
    Uint8List file,
    bool isPost,
  ) async {
    String downloadUrl = '';
    try {
      Reference referance =
          _storage.ref().child(childName).child(_auth.currentUser!.uid);

      UploadTask uploadTask = referance.putData(file);

      TaskSnapshot snapshot = await uploadTask;
      downloadUrl = await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint('storage image $e');
    }
    return downloadUrl;
  }

  Future<String> uploadImageToStorages(Uint8List file) async {
    try {
      Reference ref = _storage.ref("profileImage/${_auth.currentUser!.uid}");

      UploadTask uploadTask = ref.putData(file);
      final ss = await uploadTask;
      final link = await ss.ref.getDownloadURL();
      return link;
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
    }

    return "error";
  }
}
