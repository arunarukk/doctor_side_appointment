import 'package:doc_side_appoinment/get_controller/get_controller.dart';
import 'package:doc_side_appoinment/screens/more_screen/more_screen.dart';
import 'package:doc_side_appoinment/screens/patients_screen/patient_screen.dart';
import 'package:doc_side_appoinment/screens/profile_screen/doctor_profile.dart';
import 'package:doc_side_appoinment/screens/screen_home/home_screen.dart';
import 'package:doc_side_appoinment/widgets/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _pages = [
    const HomeScreen(),
    const PatientScreen(),
    const DoctorProfileScreen(),
    MoreScreen(),
  ];

  addData() async {
    try {
      final statecontrol = Get.put(StateController());
      statecontrol.update();
    } catch (e) {
      debugPrint('adddata mainscreen ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NewBottomNavigationBar(),
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
