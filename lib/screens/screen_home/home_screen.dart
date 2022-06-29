import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:doc_side_appoinment/constant_value/constant_size.dart';
import 'package:doc_side_appoinment/get_controller/get_controller.dart';
import 'package:doc_side_appoinment/main.dart';
import 'package:doc_side_appoinment/models/doctor_model.dart';
import 'package:doc_side_appoinment/widgets/appbar_wiget.dart';
import 'package:doc_side_appoinment/widgets/connection_lost.dart';
import 'package:doc_side_appoinment/widgets/main_title_widget.dart';
import 'package:doc_side_appoinment/widgets/search_bar/search_bar_widget.dart';
import 'package:doc_side_appoinment/widgets/upcoming_appoinment_widget/upcoming_appoinment.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../constant_value/constant_colors.dart';
import '../../models/patients_model.dart';
import '../../resources/data_methods.dart';
import '../chat_screen/chat_screen.dart';
import '../skeleton_screens/skeleton_name.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final doctorControl = Get.put(StateController());

  @override
  void initState() {
    stateControl.getUserProfileDetails();
    notifyC.storeToken();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (message.data["screen"] == "chatScreen") {
        final uid = message.data['patientId'];
        final Patients patients = await dataController.getPatient(uid);
        Navigator.push(
            navigatorKey.currentState!.context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                      patientId: uid,
                      patientImage: patients.photoUrl,
                      patientName: patients.userName.capitalize!,
                    )));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          child: AppBarWidget(
            title: 'Home',
          ),
          preferredSize: Size.fromHeight(60)),
      body: StreamBuilder(
          stream: Connectivity().onConnectivityChanged,
          builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.hasData && snapshot.data != ConnectivityResult.none) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 6.w,
                      ),
                      GetBuilder<StateController>(
                        init: StateController(),
                        builder: (controller) {
                          return StreamBuilder<Doctor>(
                              stream: controller.getUserProfileDetails(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SkeletonName();
                                }
                                if (snapshot.data == null) {
                                  return const Text(
                                    'Hola',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: kBlack,
                                    ),
                                  );
                                }
                                final data = snapshot.data!;

                                final userName = snapshot.data!.userName;
                                final photoUrl = snapshot.data!.photoUrl;
                                return SizedBox(
                                  width: 92.w,
                                  child: Column(
                                    children: [
                                      data.about.isEmpty ||
                                              data.address.isEmpty ||
                                              data.experience.isEmpty ||
                                              data.speciality.isEmpty
                                          ? Text(
                                              '* Please update your profile!',
                                              style: TextStyle(color: kRed),
                                            )
                                          : Container(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundColor: kGreen,
                                            backgroundImage:
                                                NetworkImage(photoUrl),
                                          ),
                                          kWidth20,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              const Text(
                                                'Hi,',
                                                style: TextStyle(
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.bold,
                                                  color: kBlack,
                                                ),
                                              ),
                                              kWidth10,
                                              SizedBox(
                                                width: 60.w,
                                                child: Text(
                                                  'Dr. ${userName.capitalize!}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: kBlack,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                      )
                    ],
                  ),
                  const SearchBar(),
                  kHeight20,
                  const MainTitle(title: 'Upcoming Appoinments'),
                  kHeight10,
                  AppointmentWidget(),
                ],
              );
            } else {
              return const ConnectionLost();
            }
          }),
    );
  }
}
