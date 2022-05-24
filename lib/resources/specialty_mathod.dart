import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doc_side_appoinment/get_controller/get_controller.dart';
import 'package:doc_side_appoinment/models/doctor_model.dart';
import 'package:doc_side_appoinment/resources/auth_method.dart';
import 'package:doc_side_appoinment/resources/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

User currentUser = _auth.currentUser!;

Future<List<QueryDocumentSnapshot<Object?>>> getSpeciality() async {
  final snap = await _fireStore.collection('speciality').get();

  final docSnap = snap.docs;

  //final newlist = docSnap.toList();
  // print(newlist);
  return docSnap;
}

updateDoctor({
  required String email,
  //required String password,
  required String userName,
  required String phoneNumber,
  //Uint8List? file,
  required String photoUrl,
  required Map<String, dynamic> speciality,
  required String about,
  required String experience,
}) async {
  //String? photoUrl;

  final currentUser = AuthMethods().getUserDetails();
  currentUser.then((value) async {
    // if (file != null) {
    //   photoUrl = await StorageMethods()
    //       .uploadImageToStorage('profilePics', file, false);
    // } else {
    //   photoUrl = value.photoUrl;
    // }

    Doctor doctor = Doctor(
      userName: userName,
      uid: value.uid,
      photoUrl: photoUrl,
      email: email,
      phoneNumber: phoneNumber,
      speciality: speciality,
      about: about,
      experience: experience,
      rating: 0,
      patients: 0,
    );
    await _fireStore
        .collection('doctors')
        .doc(value.uid)
        .update(doctor.toJson());
    stateControl.update(['profile']);
  });
}
