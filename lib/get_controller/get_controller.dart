import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doc_side_appoinment/models/doctor_model.dart';
import 'package:doc_side_appoinment/resources/auth_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/doc_appointment.dart';

final stateControl = Get.put(StateController());

class StateController extends GetxController {
  Doctor? user;
  dynamic dropvalue;
  DateTime? selectedDate;

  
  String? selectedStartDate;

  String? selectedEndDate;

  
  bool nine = false;
  bool ten = false;
  bool eleven = false;
  bool twel = false;
  bool one = false;
  bool two = false;
  bool three = false;
  bool four = false;
  bool five = false;
  bool six = false;

  Uint8List? image;

   final AuthMethods _authMethods = AuthMethods();

   final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> checkvar() async {
    print(six);
  }



 void imageUpdate(Uint8List img) {
    image = img;
    update(['photo']);
  }

  // Doctor get getUser => _user!;

  Future<void> refreshUser() async {
    Doctor _user = await _authMethods.getUserDetails();
    user = _user;
    update();
  }

  void dropDownChange(String newValue) {
    dropvalue = newValue;
    update();
  }

  dateRange(DateTimeRange? dateRange) {
    selectedStartDate = DateFormat('MMM-dd').format(dateRange!.start);
    selectedEndDate = DateFormat('MMM-dd').format(dateRange.end);
    update(['filter']);
  }

Stream<Doctor> getUserProfileDetails() async* {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snapshot =
        await _fireStore.collection('doctors').doc(currentUser.uid).get();

    yield Doctor.fromSnapshot(snapshot);
  }
  

  @override
  void onInit() {
    // refreshUser();
    // TODO: implement onInit
    super.onInit();
  }
}
