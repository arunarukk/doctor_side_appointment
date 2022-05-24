import 'package:doc_side_appoinment/constant_value/constant_colors.dart';
import 'package:doc_side_appoinment/constant_value/constant_size.dart';
import 'package:doc_side_appoinment/models/doc_appointment.dart';
import 'package:doc_side_appoinment/resources/data_methods.dart';
import 'package:doc_side_appoinment/screens/screen_home/patient_details.dart';
import 'package:doc_side_appoinment/screens/skeleton_screens/skeleton_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/sockets/src/sockets_io.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class AppointmentWidget extends StatelessWidget {
  AppointmentWidget({Key? key}) : super(key: key);

  final ScrollController scrollController = ScrollController();

  //final doctor = FirebaseAuth.instance.currentUser;
  final dataControl = Get.put(DataController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height;
    return Expanded(
      child: GetBuilder<DataController>(
          id: 'upcoming',
          init: DataController(),
          builder: (upComing) {
            return FutureBuilder<List<DoctorAppointment>>(
                future: upComing.searchResult(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionStatus.closed) {
                    return Text('data');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SkeletonHome();
                    //  Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/no appointment.png',
                          scale: .8,
                          // width: 20.h,
                          // height: 20.h,
                        ),
                        Text('No appointments'),
                      ],
                    );
                  }
                  // print('999999999${snapshot.data}');
                  return ListView.separated(
                    controller: scrollController,
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    itemBuilder: (ctx, index) {
                      final String patientPhoto =
                          snapshot.data![index].appoDetails.photoUrl;
                      print(patientPhoto);
                      final String patientName =
                          snapshot.data![index].appoDetails.name;
                      final String patientAge =
                          snapshot.data![index].appoDetails.age;
                      final DateTime patientDate =
                          snapshot.data![index].appoDetails.date;
                      final String payment =
                          snapshot.data![index].appoDetails.payment;
                      final String time =
                          snapshot.data![index].appoDetails.time;
                      final date = DateFormat('dd/MM/yyyy').format(patientDate);
                      return Card(
                        color: kWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: SizedBox(
                          height: size * .14,
                          width: double.infinity,
                          child: InkWell(
                            onTap: (() {
                              //print(doctor!.email);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PatientAppointmentScreen(
                                            data: snapshot.data![index],
                                          )));
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
                                        fit: BoxFit.cover,
                                        child: Image.network(patientPhoto)),
                                    height: double.infinity,
                                    width: size * .13,
                                  ),
                                ),
                                kWidth20,
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // kHeight10,
                                    SizedBox(
                                      width: size * .27,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(patientName.capitalize!),
                                              kHeight10,
                                              Text('Age :$patientAge'),
                                              //kHeight10,
                                            ],
                                          ),
                                          Container(
                                            height: size * .03,
                                            width: size * .11,
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 21, 166, 26),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Center(
                                                child: Text(payment,
                                                    style: TextStyle(
                                                        color: kWhite,
                                                        fontSize: 12))),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      //color: kBlue,s
                                      width: size * .27,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: 25,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                //color: kBlue,
                                                border: Border.all(
                                                    color: kBlue, width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                              ),
                                              child: Center(child: Text(date)),
                                            ),
                                            // kWidth20,
                                            // Spacer(),
                                            Container(
                                              height: 25,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                  // color: kBlue,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  border: Border.all(
                                                      color: kBlue, width: 1)),
                                              child: Center(child: Text(time)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // kHeight10
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
                    itemCount: snapshot.data!.length,
                  );
                });
          }),
    );
  }
}
