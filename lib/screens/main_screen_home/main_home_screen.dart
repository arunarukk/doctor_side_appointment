import 'package:doc_side_appoinment/get_controller/get_controller.dart';
import 'package:doc_side_appoinment/resources/auth_method.dart';
import 'package:doc_side_appoinment/screens/more_screen/more_screen.dart';
import 'package:doc_side_appoinment/screens/patients_screen/patient_screen.dart';
import 'package:doc_side_appoinment/screens/profile_screen/doctor_profile.dart';
import 'package:doc_side_appoinment/widgets/review_screen.dart';
import 'package:doc_side_appoinment/screens/screen_home/home_screen.dart';
import 'package:doc_side_appoinment/widgets/bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainHomeScreen extends StatefulWidget {
  MainHomeScreen({Key? key}) : super(key: key);

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  @override
  void initState() {
    //addData();
    super.initState();
  }

  final List<Widget> _pages = [
    HomeScreen(),
    PatientScreen(),
    DoctorProfileScreen(),
    MoreScreen(),
  ];

  addData() async {
    try {
      final statecontrol = Get.put(StateController());

      // await statecontrol.refreshUser();
      statecontrol.update();
    } catch (e) {
      print('adddata mainscreen ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    //addData();
    return Scaffold(
      bottomNavigationBar: NewBottomNavigationBar(),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: MainHomeScreen.selectedIndexNotifier,
          builder: (BuildContext context, int updatedIndex, _) {
            return _pages[updatedIndex];
          },
        ),
      ),
    );
  }
}
