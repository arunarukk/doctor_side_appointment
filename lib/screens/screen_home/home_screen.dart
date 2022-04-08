import 'package:doc_side_appoinment/constant_value/constant_size.dart';
import 'package:doc_side_appoinment/get_controller/get_controller.dart';
import 'package:doc_side_appoinment/widgets/appbar_wiget.dart';
import 'package:doc_side_appoinment/widgets/main_title_widget.dart';
import 'package:doc_side_appoinment/widgets/search_bar/search_bar_widget.dart';
import 'package:doc_side_appoinment/widgets/upcoming_appoinment_widget/upcoming_appoinment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant_value/constant_colors.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  //final doctorControl = Get.put(StateController());

  @override
  Widget build(BuildContext context) {
    //doctorControl.refreshUser();
    // print('Dr ${doctorControl.getUser.userName}');
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
          child: AppBarWidget(
            title: 'Home',
          ),
          preferredSize: Size.fromHeight(60)),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: size.width * 0.1,
              ),
              GetBuilder<StateController>(
                builder: (controller) {
                  return controller.user == null
                      ? CircularProgressIndicator()
                      : Text(
                          'Hi,\n  Dr ${controller.user!.userName}',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: kBlue,
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
      ),
    );
  }
}
