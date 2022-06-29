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
                    return const Text('data');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SkeletonHome();
                  }
                  if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/no appointment.png',
                          scale: .8,
                        ),
                        const Text('No appointments'),
                      ],
                    );
                  }
                  // print('999999999${snapshot.data}');
                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    controller: scrollController,
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    itemBuilder: (ctx, index) {
                      final String patientPhoto =
                          snapshot.data![index].appoDetails.photoUrl;
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
                      final String isCanceled =
                          snapshot.data![index].appoDetails.status;
                      final date = DateFormat('dd/MM/yyyy').format(patientDate);
                      return Card(
                        elevation: 0,
                        color: Colors.grey.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: SizedBox(
                          height: size * .14,
                          width: double.infinity,
                          child: InkWell(
                            onTap: (() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PatientAppointmentScreen(
                                            data: snapshot.data![index],
                                          )));
                              FocusManager.instance.primaryFocus?.unfocus();
                            }),
                            child: Row(
                              children: [
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
                                    SizedBox(
                                      width: size * .27,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  width: size * .15,
                                                  child: Text(
                                                    patientName.capitalize!,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )),
                                              kHeight10,
                                              Text('Age :$patientAge'),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                height: size * .03,
                                                width: size * .11,
                                                decoration: BoxDecoration(
                                                  color: payment !=
                                                          'Pay on hand'
                                                      ? const Color.fromARGB(
                                                          255, 21, 166, 26)
                                                      : const Color.fromARGB(
                                                          255, 220, 199, 18),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: Center(
                                                    child: Text(payment,
                                                        style: const TextStyle(
                                                            color: kWhite,
                                                            fontSize: 12))),
                                              ),
                                              SizedBox(
                                                height: .5.h,
                                              ),
                                              isCanceled == 'canceled'
                                                  ? Container(
                                                      height: size * .03,
                                                      width: size * .11,
                                                      decoration: BoxDecoration(
                                                        color: kRed,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      child: const Center(
                                                          child: Text(
                                                              'Canceled',
                                                              style: TextStyle(
                                                                  color: kWhite,
                                                                  fontSize:
                                                                      12))),
                                                    )
                                                  : Container(),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: size * .27,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: 3.5.h,
                                              width: 25.w,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: kBlue, width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                              ),
                                              child: Center(child: Text(date)),
                                            ),
                                            Container(
                                              height: 3.5.h,
                                              width: 18.w,
                                              decoration: BoxDecoration(
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (ctx, index) {
                      return SizedBox(
                        height: 1.h,
                      );
                    },
                    itemCount: snapshot.data!.length,
                  );
                });
          }),
    );
  }
}
