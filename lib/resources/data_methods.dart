import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doc_side_appoinment/constant_value/constant_colors.dart';
import 'package:doc_side_appoinment/main.dart';
import 'package:doc_side_appoinment/models/patients_model.dart';
import 'package:doc_side_appoinment/models/appointment_model.dart';
import 'package:doc_side_appoinment/models/doc_appointment.dart';
import 'package:doc_side_appoinment/models/schedule.dart';
import 'package:doc_side_appoinment/resources/auth_method.dart';
import 'package:doc_side_appoinment/utils/image_picker_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

final dataController = Get.put(DataController());

class DataController extends GetxController {
  List<DoctorAppointment> appoDocDetails = <DoctorAppointment>[].obs;

  bool querySelec = false;

  DateTimeRange? dateRange;

  Future<Patients> getPatient(String uid) async {
    final patien = await _fireStore.collection('patients').doc(uid).get();
    return Patients.fromSnapshot(patien);
  }

  Future<List<DoctorAppointment>> getDetailedAppo() async {
    User currentUser = _auth.currentUser!;

    List<Appointment> appoList = [];
    List<DoctorAppointment> patientAppoList = [];
    QuerySnapshot<Map<String, dynamic>> patientDetails;

    final appointments = await _fireStore
        .collection('appointment')
        .where('doctorId', isEqualTo: currentUser.uid)
        .get();
   for (var element in appointments.docs) {
      appoList.add(Appointment.fromMap(element));
    }

    for (var elu in appoList) {
      patientDetails = await _fireStore
          .collection('patients')
          .where('uid', isEqualTo: elu.patientId)
          .get();

      for (var value in patientDetails.docs) {
        patientAppoList.add(DoctorAppointment(
            patientDetails: Patients.fromSnapshot(value), appoDetails: elu));
      }
    }
    appoDocDetails.addAll(patientAppoList);
    return patientAppoList;
  }

  addScheduleDetails({required Schedule schedule}) async {
    try {
      final String scheduleId = const Uuid().v1();
      User currentUser = _auth.currentUser!;
      await _fireStore
          .collection('doctors')
          .doc(currentUser.uid)
          .collection('schedule')
          .doc(scheduleId)
          .set(schedule.toMap());
    } catch (e) {
      debugPrint('scedule adding error $e');
    }
  }

  Future<String?> scheduleDetailsExisting(DateTime currentDate) async {
    String? updateScheduleId;
    try {
      User currentUser = _auth.currentUser!;
      final snapshot = await _fireStore
          .collection('doctors')
          .doc(currentUser.uid)
          .collection('schedule')
          .where('date', isEqualTo: currentDate)
          .get();
      if (snapshot.docs.isNotEmpty) {
        updateScheduleId = snapshot.docs.first.id;
      }

      } catch (e) {
      debugPrint('schedule empty $e');
    }
    return updateScheduleId;
  }

  Future<bool> updateScheduleDetails(
      {required Schedule schedule,
      required String did,
      required BuildContext ctx}) async {
    bool isEmty = false;
    try {
      showSnackBar('Loading', kGreen, ctx);
      QuerySnapshot<Map<String, dynamic>>? isExist;
      User currentUser = _auth.currentUser!;

      isExist = await existingSchedule(
        scheduleId: did,
      );
      if (isExist.docs.isNotEmpty) {
        isEmty = true;
      }

      if (isEmty == false) {
        await _fireStore
            .collection('doctors')
            .doc(currentUser.uid)
            .collection('schedule')
            .doc(did)
            .update(schedule.toMap());
      }
    } catch (e) {
      debugPrint('schedule update $e');
    }
    return isEmty;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> existingSchedule(
      {required String scheduleId}) async {
    User currentUser = _auth.currentUser!;
    final scheduleTime = await _fireStore
        .collection('doctors')
        .doc(currentUser.uid)
        .collection('schedule')
        .doc(scheduleId)
        .collection('time')
        .get();
   return scheduleTime;
  }

  Future<List<DoctorAppointment>> getPastApp() async {
    User currentUser = _auth.currentUser!;

  
    final now = DateTime.now();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> past = [];
    List<Appointment> appoList = [];
    List<DoctorAppointment> patientAppoList = [];
    QuerySnapshot<Map<String, dynamic>> patientDetails;

    final appointments = await _fireStore
        .collection('appointment')
        .where('doctorId', isEqualTo: currentUser.uid)
        .get();
    for (var element in appointments.docs) {
      final date = (element.data()['date'] as Timestamp).toDate();
      if (now.millisecondsSinceEpoch >= date.millisecondsSinceEpoch) {
         past.add(element);
      }
    }

    for (var element in past) {
      appoList.add(Appointment.fromMap(element));
    }

    for (var elu in appoList) {
      patientDetails = await _fireStore
          .collection('patients')
          .where('uid', isEqualTo: elu.patientId)
          .get();

      for (var value in patientDetails.docs) {
        patientAppoList.add(DoctorAppointment(
            patientDetails: Patients.fromSnapshot(value), appoDetails: elu));
      }
    }
    appoDocDetails.addAll(patientAppoList);
    update();

    return patientAppoList;
  }

  Future<List<DoctorAppointment>> getUpcomingApp() async {
    User currentUser = _auth.currentUser!;

 
    final now = DateTime.now();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> past = [];
    List<Appointment> appoList = [];
    List<DoctorAppointment> patientAppoList = [];
    QuerySnapshot<Map<String, dynamic>> patientDetails;

    final appointments = await _fireStore
        .collection('appointment')
        .where('doctorId', isEqualTo: currentUser.uid)
        .get();
    for (var element in appointments.docs) {
       final date = (element.data()['date'] as Timestamp).toDate();
      if (now.millisecondsSinceEpoch <= date.millisecondsSinceEpoch) {
         past.add(element);
      }
    }

    for (var element in past) {
      appoList.add(Appointment.fromMap(element));
    }

    for (var elu in appoList) {
      patientDetails = await _fireStore
          .collection('patients')
          .where('uid', isEqualTo: elu.patientId)
          .get();

      for (var value in patientDetails.docs) {
        patientAppoList.add(DoctorAppointment(
            patientDetails: Patients.fromSnapshot(value), appoDetails: elu));
      }
    }
    appoDocDetails.addAll(patientAppoList);
    update();

    return patientAppoList;
  }

  //----------------------- get todays appointment -----------

  Future<List<DoctorAppointment>> getTodaysAppointment() async {
    User currentUser = _auth.currentUser!;

     final now = DateTime.now();
     List<QueryDocumentSnapshot<Map<String, dynamic>>> today = [];
    List<Appointment> appoList = [];
    List<DoctorAppointment> patientAppoList = [];
    QuerySnapshot<Map<String, dynamic>> patientDetails;

    final appointments = await _fireStore
        .collection('appointment')
        .where('doctorId', isEqualTo: currentUser.uid)
        .get();
    for (var element in appointments.docs) {
      final date = (element.data()['date'] as Timestamp).toDate();
      if (now.millisecondsSinceEpoch == date.millisecondsSinceEpoch) {
         today.add(element);
        }
    }

    for (var element in today) {
      appoList.add(Appointment.fromMap(element));
    }

    for (var elu in appoList) {
      patientDetails = await _fireStore
          .collection('patients')
          .where('uid', isEqualTo: elu.patientId)
          .get();

      for (var value in patientDetails.docs) {
        patientAppoList.add(DoctorAppointment(
            patientDetails: Patients.fromSnapshot(value), appoDetails: elu));
      }
    }
    appoDocDetails.addAll(patientAppoList);
    update();

    return patientAppoList;
  }

  // ---------------------- search --------------------------
  List<DoctorAppointment> snapshot = [];
  Future<List<DoctorAppointment>> queryData(String queryString) async {
   try {
       List<DoctorAppointment> snapshotnew = await getUpcomingApp();
      snapshot.clear();
      for (var item in snapshotnew) {
        if (item.appoDetails.name
            .toLowerCase()
            .contains(queryString.toLowerCase())) {
           snapshot.add(item);
        }
      }
      update(['upcoming']);
     } catch (e) {
      debugPrint('queryData error $e');
    }
    return snapshot;
  }

  Future<List<DoctorAppointment>> searchResult() async {
    if (dataController.querySelec == false) {
      List<DoctorAppointment> snapshotnew = await getUpcomingApp();
     return snapshotnew;
    } else {
        return snapshot;
    }
  }

  Future<List<DoctorAppointment>> filterDateRange() async {
    List<DoctorAppointment> pastAppo = await getPastApp();
    List<DoctorAppointment> filteredData = [];
    final startDate = dateRange!.start.millisecondsSinceEpoch;
    final endDate = dateRange!.end.millisecondsSinceEpoch;

    for (var item in pastAppo) {
      final date = item.appoDetails.date.millisecondsSinceEpoch;
      if (startDate <= date && endDate >= date) {
        filteredData.add(item);
      }
    }

    return filteredData;
  }

  // ============= past and filter =====================================

  Future<List<DoctorAppointment>> pastRefresh() async {
    if (dateRange == null) {
       return await getPastApp();
    }
    return await filterDateRange();
  }

  patientDetails({required String patientId, required}) async {
    final patient =
        await _fireStore.collection('patients').doc(patientId).get();
    final fcmToken = patient.data()!['fcmToken'];
    final doctor = await AuthMethods().getUserDetails();
    final name = doctor.userName.capitalize;

    notifyC.sendChatPushMessage('You have new Message', 'Dr $name', fcmToken);
  }
}
