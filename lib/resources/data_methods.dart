import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doc_side_appoinment/constant_value/constant_colors.dart';
import 'package:doc_side_appoinment/models/Patients_model.dart';
import 'package:doc_side_appoinment/models/appointment_model.dart';
import 'package:doc_side_appoinment/models/doc_appointment.dart';
import 'package:doc_side_appoinment/models/schedule.dart';
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

  // String? updateScheduleId;
  bool querySelec = false;

   DateTimeRange? dateRange;

  Future<List<DoctorAppointment>> getDetailedAppo() async {
    User currentUser = _auth.currentUser!;

    List<Appointment> appoList = [];
    List<DoctorAppointment> patientAppoList = [];
    QuerySnapshot<Map<String, dynamic>> patientDetails;

    final appointments = await _fireStore
        .collection('appointment')
        .where('doctorId', isEqualTo: currentUser.uid)
        .get();
    //print('11111111 ${appointments.docs.length}');
    for (var element in appointments.docs) {
      appoList.add(Appointment.fromMap(element));
    }

    for (var elu in appoList) {
      patientDetails = await _fireStore
          .collection('patients')
          .where('uid', isEqualTo: elu.patientId)
          .get();

      //print(patientDetails.docs.length);
      for (var value in patientDetails.docs) {
        patientAppoList.add(DoctorAppointment(
            patientDetails: Patients.fromSnapshot(value), appoDetails: elu));
        // print('4444444 ${patientAppoList.first}');
      }
    }
    appoDocDetails.addAll(patientAppoList);
    //update();

    return patientAppoList;
  }

  addScheduleDetails({required Schedule schedule}) async {
    try {
      final String scheduleId = Uuid().v1();
      User currentUser = _auth.currentUser!;
      await _fireStore
          .collection('doctors')
          .doc(currentUser.uid)
          .collection('schedule')
          .doc(scheduleId)
          .set(schedule.toMap());
    } catch (e) {
      print('scedule adding error $e');
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
      print(snapshot.docs.first.id);

      updateScheduleId = snapshot.docs.first.id;

      // if (snapshot.docs.isEmpty) {
      //   isEmty
      // }
    } catch (e) {
      print('schedule empty $e');
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
      String result = '';
      QuerySnapshot<Map<String, dynamic>>? isExist;
      // bool isEmty = false;
      User currentUser = _auth.currentUser!;

      final fireSchedule = await _fireStore
          .collection('doctors')
          .doc(currentUser.uid)
          .collection('schedule')
          .doc(did)
          .get();

      // final appoinment = await _fireStore
      //     .collection('appointment')
      //     .where('date', isEqualTo: fireSchedule.data()!['date'])
      //     .get();

      if (schedule.elevenAm == fireSchedule.data()!['elevenAm']) {
        isExist = await existingSchedule(scheduleId: did, time: '11:00 AM');
        if (isExist.docs.isNotEmpty) {
          isEmty = true;
        }
        // print('eleven${schedule.elevenAm}');
      }
      if (schedule.nineAm == fireSchedule.data()!['nineAm']) {
        isExist = await existingSchedule(scheduleId: did, time: '9:00 AM');
        if (isExist.docs.isNotEmpty) {
          isEmty = true;
        }
        // print('nineAm${schedule.nineAm}');
      }
      if (schedule.tenAm == fireSchedule.data()!['tenAm']) {
        isExist = await existingSchedule(scheduleId: did, time: '10:00 AM');
        if (isExist.docs.isNotEmpty) {
          isEmty = true;
        }
        // print('tenAm${schedule.tenAm}');
      }
      if (schedule.twelvePm == fireSchedule.data()!['twelvePm']) {
        isExist = await existingSchedule(scheduleId: did, time: '12:00 PM');
        if (isExist.docs.isNotEmpty) {
          isEmty = true;
        }
        // print('twelvePm${schedule.twelvePm}');
      }
      if (schedule.onepm == fireSchedule.data()!['onepm']) {
        isExist = await existingSchedule(scheduleId: did, time: '1:00 PM');
        if (isExist.docs.isNotEmpty) {
          isEmty = true;
        }
        // print('onepm${schedule.onepm}');
      }
      if (schedule.twoPm == fireSchedule.data()!['twoPm']) {
        isExist = await existingSchedule(scheduleId: did, time: '2:00 PM');
        if (isExist.docs.isNotEmpty) {
          isEmty = true;
        }
        // print('twoPm${schedule.twoPm}');
      }
      if (schedule.threePm == fireSchedule.data()!['threePm']) {
        isExist = await existingSchedule(scheduleId: did, time: '3:00 PM');
        if (isExist.docs.isNotEmpty) {
          isEmty = true;
        }
        // print('threePm${schedule.threePm}');
      }
      if (schedule.fourPm == fireSchedule.data()!['fourPm']) {
        isExist = await existingSchedule(scheduleId: did, time: '4:00 PM');
        if (isExist.docs.isNotEmpty) {
          isEmty = true;
        }
        // print('fourPm${schedule.fourPm}');
      }
      if (schedule.fivePm == fireSchedule.data()!['fivePm']) {
        isExist = await existingSchedule(scheduleId: did, time: '5:00 PM');
        if (isExist.docs.isNotEmpty) {
          isEmty = true;
        }
        // print('fivePm${schedule.fivePm}');
      }
      if (schedule.sixPm == fireSchedule.data()!['sixPm']) {
        isExist = await existingSchedule(scheduleId: did, time: '6:00 PM');
        if (isExist.docs.isNotEmpty) {
          isEmty = true;
        }
        // print('sixPm${schedule.sixPm}');
      }
      print(isEmty);
      // print(fireSchedule.data()!['date']);
      // print(appoinment.docs.first.data());
      // print(isEmty);
      if (isEmty == false) {
        await _fireStore
            .collection('doctors')
            .doc(currentUser.uid)
            .collection('schedule')
            .doc(did)
            .update(schedule.toMap());
      }
    } catch (e) {
      print('schedule update $e');
    }
    print(isEmty);
    return isEmty;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> existingSchedule(
      {required String scheduleId, required String time}) async {
    User currentUser = _auth.currentUser!;
    final scheduleTime = await _fireStore
        .collection('doctors')
        .doc(currentUser.uid)
        .collection('schedule')
        .doc(scheduleId)
        .collection('time')
        .where('time', isEqualTo: time)
        .get();

    // if (scheduleTime.docs.isNotEmpty) {
    //   print(time);
    //   return scheduleTime;
    // }
    return scheduleTime;
  }

  Future<List<DoctorAppointment>> getPastApp() async {
    User currentUser = _auth.currentUser!;

    //final allAppoinment = getDetailedAppo();

    final now = DateTime.now();
    final week = DateTime(now.year, now.month, now.day + 1);
    List<QueryDocumentSnapshot<Map<String, dynamic>>> past = [];
    List<Appointment> appoList = [];
    List<DoctorAppointment> patientAppoList = [];
    QuerySnapshot<Map<String, dynamic>> patientDetails;

    final appointments = await _fireStore
        .collection('appointment')
        .where('doctorId', isEqualTo: currentUser.uid)
        .get();
    //print('11111111 ${appointments.docs.length}');
    for (var element in appointments.docs) {
      // appoList.add(Appointment.fromMap(element));
      final date = (element.data()['date'] as Timestamp).toDate();
      if (now.millisecondsSinceEpoch >= date.millisecondsSinceEpoch) {
        // print('------1111 ${date.millisecondsSinceEpoch}');
        // print(week.millisecondsSinceEpoch);
        // print('--past ${element.data().length}');
        past.add(element);
        // print(past.length);
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

      //print(patientDetails.docs.length);
      for (var value in patientDetails.docs) {
        patientAppoList.add(DoctorAppointment(
            patientDetails: Patients.fromSnapshot(value), appoDetails: elu));
        // print('4444444 ${patientAppoList.first}');
      }
    }
    appoDocDetails.addAll(patientAppoList);
    update();

    return patientAppoList;
  }

  Future<List<DoctorAppointment>> getUpcomingApp() async {
    User currentUser = _auth.currentUser!;

    //final allAppoinment = getDetailedAppo();

    final now = DateTime.now();
    final week = DateTime(now.year, now.month, now.day + 1);
    List<QueryDocumentSnapshot<Map<String, dynamic>>> past = [];
    List<Appointment> appoList = [];
    List<DoctorAppointment> patientAppoList = [];
    QuerySnapshot<Map<String, dynamic>> patientDetails;

    final appointments = await _fireStore
        .collection('appointment')
        .where('doctorId', isEqualTo: currentUser.uid)
        .get();
    // print('11111111 ${appointments.docs.length}');
    for (var element in appointments.docs) {
      // appoList.add(Appointment.fromMap(element));
      final date = (element.data()['date'] as Timestamp).toDate();
      if (now.millisecondsSinceEpoch <= date.millisecondsSinceEpoch) {
        // print('------1111 ${date.millisecondsSinceEpoch}');
        // print(week.millisecondsSinceEpoch);
        // print('--past ${element.data().length}');
        past.add(element);
        // print(past.length);
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

      //print(patientDetails.docs.length);
      for (var value in patientDetails.docs) {
        patientAppoList.add(DoctorAppointment(
            patientDetails: Patients.fromSnapshot(value), appoDetails: elu));
        // print('4444444 ${patientAppoList.first}');
      }
    }
    appoDocDetails.addAll(patientAppoList);
    update();

    return patientAppoList;
  }

  //----------------------- get todays appointment -----------

  Future<List<DoctorAppointment>> getTodaysAppointment() async {
    User currentUser = _auth.currentUser!;

    //final allAppoinment = getDetailedAppo();

    final now = DateTime.now();
    final week = DateTime(now.year, now.month, now.day + 1);
    List<QueryDocumentSnapshot<Map<String, dynamic>>> today = [];
    List<Appointment> appoList = [];
    List<DoctorAppointment> patientAppoList = [];
    QuerySnapshot<Map<String, dynamic>> patientDetails;

    final appointments = await _fireStore
        .collection('appointment')
        .where('doctorId', isEqualTo: currentUser.uid)
        .get();
    // print('11111111 ${appointments.docs.length}');
    for (var element in appointments.docs) {
      // appoList.add(Appointment.fromMap(element));

      final date = (element.data()['date'] as Timestamp).toDate();
      // print(date.millisecondsSinceEpoch);
      print(now.millisecondsSinceEpoch);
      if (now.millisecondsSinceEpoch == date.millisecondsSinceEpoch) {
        // print('------1111 ${date.millisecondsSinceEpoch}');
        // print(week.millisecondsSinceEpoch);
        // print('--today ${element.data().length}');

        today.add(element);
        // print(today.length);
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

      //print(patientDetails.docs.length);
      for (var value in patientDetails.docs) {
        patientAppoList.add(DoctorAppointment(
            patientDetails: Patients.fromSnapshot(value), appoDetails: elu));
        // print('4444444 ${patientAppoList.first}');
      }
    }
    appoDocDetails.addAll(patientAppoList);
    update();

    return patientAppoList;
  }

  // ---------------------- search --------------------------
  List<DoctorAppointment> snapshot = [];
  Future<List<DoctorAppointment>> queryData(String queryString) async {
    User currentUser = _auth.currentUser!;
    // List<DoctorAppointment> snapshot = [];
    try {
      // List<QuerySnapshot<Map<String, dynamic>>>? queryList;

      //  print('hello');
      List<DoctorAppointment> snapshotnew = await getUpcomingApp();
      snapshot.clear();
      for (var item in snapshotnew) {
        if (item.appoDetails.name
            .toLowerCase()
            .contains(queryString.toLowerCase())) {
          //print(item.appoDetails.name);
          snapshot.add(item);
        }
      }
      // print('-------${snapshotnew}');
      update(['upcoming']);
      //print(data);
    } catch (e) {
      print('queryData error $e');
    }
    return snapshot;
  }

  Future<List<DoctorAppointment>> searchResult() async {
    if (dataController.querySelec == false) {
      List<DoctorAppointment> snapshotnew = await getUpcomingApp();
      //  print('111111${snapshotnew}');
      // update(['upcoming']);
      return snapshotnew;
    } else {
      // update(['upcoming']);
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
      // print(dateRange!.start);

      if (startDate <= date && endDate >= date) {
        filteredData.add(item);
      }
    }

    print(filteredData);
    return filteredData;
  }

  // ============= past and filter =====================================

  Future<List<DoctorAppointment>> pastRefresh() async {
    if (dateRange == null) {
      // update();
      return await getPastApp();
    }
    //update();
    return await filterDateRange();
  }

}
