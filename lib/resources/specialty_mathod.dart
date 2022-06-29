
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doc_side_appoinment/get_controller/get_controller.dart';
import 'package:doc_side_appoinment/models/doctor_model.dart';
import 'package:doc_side_appoinment/resources/auth_method.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

User currentUser = _auth.currentUser!;

Future<List<QueryDocumentSnapshot<Object?>>> getSpeciality() async {
  final snap = await _fireStore.collection('speciality').get();

  final docSnap = snap.docs;

  return docSnap;
}

updateDoctor({
  required String email,
  required String userName,
  required String phoneNumber,
  required String photoUrl,
  required Map<String, dynamic> speciality,
  required String about,
  required String experience,
  required String qualifications,
  required String address,
}) async {
 
  final currentUser = AuthMethods().getUserDetails();
  currentUser.then((value) async {
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
        qualifications: qualifications,
        address: address);
    await _fireStore
        .collection('doctors')
        .doc(value.uid)
        .update(doctor.toMap());
    stateControl.update(['profile']);
  });
}
