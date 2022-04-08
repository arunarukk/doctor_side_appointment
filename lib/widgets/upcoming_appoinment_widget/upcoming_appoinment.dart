import 'package:doc_side_appoinment/constant_value/constant_colors.dart';
import 'package:doc_side_appoinment/constant_value/constant_size.dart';
import 'package:doc_side_appoinment/screens/screen_home/patient_details.dart';
import 'package:flutter/material.dart';

class AppointmentWidget extends StatelessWidget {
  AppointmentWidget({Key? key}) : super(key: key);

  final ScrollController scrollController = ScrollController();

  //final doctor = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height;
    return Expanded(
      child: ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        itemBuilder: (ctx, index) {
          return Card(
            color: kWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SizedBox(
              height: 120,
              width: double.infinity,
              child: InkWell(
                onTap: (() {
                  //print(doctor!.email);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PatientAppointmentScreen()));
                }),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Container(
                    //   height: 90,
                    //   width:80,
                    //   decoration: BoxDecoration(
                    //     // color: kBlue,
                    //     borderRadius: BorderRadius.circular(6.0),
                    //   ),
                    //   child: Image.asset(
                    //     'assets/lukman.jpeg',
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    ClipRRect(
                      borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(15)),
                      child: SizedBox(
                        child: FittedBox(
                            fit: BoxFit.fill,
                            child: Image.asset('assets/lukman.jpeg')),
                        height: size * 1,
                        width: size * .13,
                      ),
                    ),
                    kWidth20,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        kHeight10,
                        SizedBox(
                          width: size * .27,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Name'),
                                  kHeight10,
                                  Text('Age'),
                                  kHeight10,
                                ],
                              ),
                              Container(
                                height: 25,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 21, 166, 26),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Center(
                                    child: Text('Paid',
                                        style: TextStyle(color: kWhite))),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          //color: kBlue,
                          width: size * .27,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 25,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: kBlue,
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  child: Center(
                                      child: Text(
                                    '12/04/2022',
                                    style: TextStyle(color: kWhite),
                                  )),
                                ),
                                // kWidth20,
                                // Spacer(),
                                Container(
                                  height: 25,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: kBlue,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Center(
                                      child: Text('10:00',
                                          style: TextStyle(color: kWhite))),
                                ),
                              ],
                            ),
                          ),
                        ),
                        kHeight10
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (ctx, index) {
          return const SizedBox(
            height: 5,
          );
        },
        itemCount: 10,
      ),
    );
  }
}
