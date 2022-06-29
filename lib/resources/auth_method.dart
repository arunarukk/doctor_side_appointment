import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doc_side_appoinment/models/doctor_model.dart';
import 'package:doc_side_appoinment/resources/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
   final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

//get user details

  Future<Doctor> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _fireStore.collection('doctors').doc(currentUser.uid).get();

    return Doctor.fromMap(snapshot.data()!);
  }

  //sign up doctor

  Future<String> signUpDoctor({
    required String email,
    required String password,
    required String userName,
    required String phoneNumber,
    required Uint8List file,
  }) async {
    String result = 'Something went wrong';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          userName.isNotEmpty ||
          phoneNumber.isNotEmpty) {
        // register Doctor

        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String photoUrl = await StorageMethods().uploadImageToStorages(file);

      
        // add doctor to database
        Doctor doctor = Doctor(
          userName: userName,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          email: email,
          phoneNumber: phoneNumber,
          speciality: {},
          about: '',
          experience: '',
          rating: 0,
          patients: 0,
          qualifications: '',
          address: '',
        );
        await _fireStore
            .collection('doctors')
            .doc(cred.user!.uid)
            .set(doctor.toMap());
        result = 'Success';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        result = 'The email is badly formatted.';
      } else if (err.code == 'email-already-in-use') {
        result = 'The email is already exist.';
      }
    } catch (err) {
      result = err.toString();
    }
    return result;
  }
  //=====================sign up with phone number ============

  otpSingUp({
    required String email,
    required String uid,
    required String userName,
    required String phoneNumber,
    required Uint8List file,
  }) async {
    String result = 'Something went wrong';
    try {
      if (email.isNotEmpty || userName.isNotEmpty || phoneNumber.isNotEmpty) {
         String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        Doctor doctor = Doctor(
          userName: userName,
          uid: uid,
          photoUrl: photoUrl,
          email: email,
          phoneNumber: phoneNumber,
          speciality: {},
          about: '',
          experience: '',
          rating: 0,
          patients: 0,
          qualifications: '',
          address: '',
        );

        _fireStore.collection('doctors').doc(uid).set(doctor.toMap());
        result = 'Success';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        result = 'The email is badly formatted.';
      }
    } catch (err) {
      result = err.toString();
    }
    return result;
  }

  // logging in user

  Future<String> logInUser({
    required String email,
    required String password,
  }) async {
    String result = 'Something went wrong.';

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        result = 'Success';
      } else {
        result = 'please enter all the fields';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'wrong-password') {
        result = 'Wrong password';
      } else if (err.code == 'user-not-found') {
        result = 'Wrong Email';
      }
    } catch (err) {
      result = err.toString();
    }
    return result;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
