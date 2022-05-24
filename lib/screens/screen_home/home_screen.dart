import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:doc_side_appoinment/constant_value/constant_size.dart';
import 'package:doc_side_appoinment/get_controller/get_controller.dart';
import 'package:doc_side_appoinment/main.dart';
import 'package:doc_side_appoinment/widgets/appbar_wiget.dart';
import 'package:doc_side_appoinment/widgets/connection_lost.dart';
import 'package:doc_side_appoinment/widgets/main_title_widget.dart';
import 'package:doc_side_appoinment/widgets/search_bar/search_bar_widget.dart';
import 'package:doc_side_appoinment/widgets/upcoming_appoinment_widget/upcoming_appoinment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant_value/constant_colors.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final doctorControl = Get.put(StateController());

  @override
  void initState() {
    notifyC.storeToken();
    // notifyC.sayHi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    doctorControl.refreshUser();

    // print('Dr ${doctorControl.getUser.userName}');
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
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
                        width: size.width * 0.06,
                      ),
                      GetBuilder<StateController>(
                        init: StateController(),
                        builder: (controller) {
                          if (controller.user == null) {
                            return Text(
                              'Hola',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: kBlack,
                              ),
                            );
                          }
                          // print(controller.user.toString());
                          final userName = controller.user!.userName;
                          final photoUrl = controller.user!.photoUrl;
                          return SizedBox(
                            width: size.width * .8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(photoUrl),
                                ),
                                kWidth20,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Hi,',
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: kBlack,
                                      ),
                                    ),
                                    kWidth10,
                                    Text(
                                      'Dr. ${userName.capitalize!}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: kBlack,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),
                  SearchBar(),
                  kHeight20,
                  MainTitle(title: 'Upcoming Appoinments'),
                  kHeight10,
                  AppointmentWidget(),
                ],
              );
            } else {
              return ConnectionLost();
            }
          }),
    );
  }
}
