import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doc_side_appoinment/models/Patients_model.dart';
import 'package:doc_side_appoinment/models/appointment_model.dart';
import 'package:doc_side_appoinment/models/doc_appointment.dart';
import 'package:doc_side_appoinment/models/schedule.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

final dataController = Get.put(DataController());

class DataController extends GetxController {
  List<DoctorAppointment> appoDocDetails = <DoctorAppointment>[].obs;

  // String? updateScheduleId;
  bool querySelec = false;

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

  updateScheduleDetails(
      {required Schedule schedule, required String did}) async {
    try {
      User currentUser = _auth.currentUser!;

      final fireSchedule = await _fireStore
          .collection('doctors')
          .doc(currentUser.uid)
          .collection('schedule')
          .doc(did)
          .get();

      final appoinment = await _fireStore
          .collection('appointment')
          .where('date', isEqualTo: fireSchedule.data()!['date'])
          .get();

      if (schedule.elevenAm == fireSchedule.data()!['elevenAm']) {


        
        print('eleven${schedule.elevenAm}');
      }
      if (schedule.nineAm == fireSchedule.data()!['nineAm']) {
        print('nineAm${schedule.nineAm}');
      }
      if (schedule.tenAm == fireSchedule.data()!['tenAm']) {
        print('tenAm${schedule.tenAm}');
      }
      if (schedule.twelvePm == fireSchedule.data()!['twelvePm']) {
        print('twelvePm${schedule.twelvePm}');
      }
      if (schedule.onepm == fireSchedule.data()!['onepm']) {
        print('onepm${schedule.onepm}');
      }
      if (schedule.twoPm == fireSchedule.data()!['twoPm']) {
        print('twoPm${schedule.twoPm}');
      }
      if (schedule.threePm == fireSchedule.data()!['threePm']) {
        print('threePm${schedule.threePm}');
      }
      if (schedule.fourPm == fireSchedule.data()!['fourPm']) {
        print('fourPm${schedule.fourPm}');
      }
      if (schedule.fivePm == fireSchedule.data()!['fivePm']) {
        print('fivePm${schedule.fivePm}');
      }
      if (schedule.sixPm == fireSchedule.data()!['sixPm']) {
        print('sixPm${schedule.sixPm}');
      }
      // print(fireSchedule.data()!['date']);
      // print(appoinment.docs.first.data());

      // await _fireStore
      //     .collection('doctors')
      //     .doc(currentUser.uid)
      //     .collection('schedule')
      //     .doc(did)
      //     .update(schedule.toMap());
    } catch (e) {
      print('schedule update $e');
    }
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
    //print('11111111 ${appointments.docs.length}');
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

  // ---------------------- search --------------------------
  List<DoctorAppointment> snapshot = [];
  Future<List<DoctorAppointment>> queryData(String queryString) async {
    User currentUser = _auth.currentUser!;
    // List<DoctorAppointment> snapshot = [];
    try {
      // List<QuerySnapshot<Map<String, dynamic>>>? queryList;

      print('hello');
      List<DoctorAppointment> snapshotnew = await getUpcomingApp();
      snapshot.clear();
      for (var item in snapshotnew) {
        if (item.appoDetails.name
            .toLowerCase()
            .contains(queryString.toLowerCase())) {
          print(item.appoDetails.name);
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
      return snapshotnew;
    } else {
      return snapshot;
    }
  }
}
