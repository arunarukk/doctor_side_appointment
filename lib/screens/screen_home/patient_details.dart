import 'package:doc_side_appoinment/constant_value/constant_colors.dart';
import 'package:doc_side_appoinment/constant_value/constant_size.dart';
import 'package:doc_side_appoinment/models/doc_appointment.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../chat_screen/chat_screen.dart';

class PatientAppointmentScreen extends StatelessWidget {
  PatientAppointmentScreen({Key? key, this.data}) : super(key: key);

  DoctorAppointment? data;

  @override
  Widget build(BuildContext context) {
    final photoUrl = data!.appoDetails.photoUrl;
    final patientName = data!.appoDetails.name;
    final patientAge = data!.appoDetails.age;
    final patientProb = data!.appoDetails.problem;
    final time = data!.appoDetails.time;
    final bookingDate = data!.appoDetails.date;
    final payment = data!.appoDetails.payment;
    final phonenumber = data!.appoDetails.phoneNumber;
    final String isCanceled = data!.appoDetails.status;
    final patientId = data!.appoDetails.patientId;

    final date = DateFormat('dd/MM/yyyy').format(bookingDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Patient Profile',
          style: TextStyle(color: kBlack),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: kBlack,
            )),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    color: kGrey,
                    height: 40.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 40.h,
                          width: 80.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kGrey,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(photoUrl),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    child: Container(
                      height: 3.5.h,
                      width: 24.w,
                      decoration: BoxDecoration(
                        color: payment != 'Pay on hand'
                            ? const Color.fromARGB(255, 21, 166, 26)
                            : const Color.fromARGB(255, 220, 199, 18),
                      ),
                      child: Center(
                          child: Text(payment,
                              style: const TextStyle(color: kWhite))),
                    ),
                  ),
                  isCanceled == 'canceled'
                      ? Positioned(
                          right: 0,
                          child: Container(
                            height: 3.5.h,
                            width: 24.w,
                            decoration: BoxDecoration(
                              color: kRed,
                            ),
                            child: const Center(
                                child: Text('Canceled',
                                    style: TextStyle(color: kWhite))),
                          ),
                        )
                      : Container(),
                ],
              ),
              Container(
                color: kWhite,
                padding: const EdgeInsets.all(16),
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Name :  ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 50.w,
                                  child: Text(
                                    patientName,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Age :     ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(patientAge,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    )),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                            patientId: patientId,
                                            patientName: patientName,
                                            patientImage: photoUrl)));
                              },
                              child: Container(
                                height: 6.h,
                                width: 12.w,
                                decoration: BoxDecoration(
                                  color: Colors.yellow.shade700,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.chat,
                                  color: kWhite,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 1.w,
                            ),
                            InkWell(
                              onTap: () {
                                launchUrl(
                                    Uri(scheme: 'tel', path: phonenumber));
                              },
                              child: Container(
                                height: 6.h,
                                width: 12.w,
                                decoration: BoxDecoration(
                                  color: kGreen,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.call,
                                  color: kWhite,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    kHeight10,
                    const Divider(
                      thickness: 0.5,
                      color: kBlack,
                    ),
                    const Text('Booking Date and Time',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    kHeight20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 4.h,
                          width: 25.w,
                          decoration: BoxDecoration(
                            border: Border.all(color: kBlue, width: 1),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Center(
                              child: Text(
                            date,
                            style: const TextStyle(fontSize: 16),
                          )),
                        ),
                        kWidth10,
                        Container(
                          height: 4.h,
                          width: 20.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(color: kBlue, width: 1)),
                          child: Center(
                              child: Text(
                            time,
                            style: const TextStyle(fontSize: 16),
                          )),
                        ),
                      ],
                    ),
                    kHeight10,
                    const Divider(
                      thickness: .5,
                      color: kBlack,
                    ),
                    const Text('Description',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    kHeight20,
                    Text(patientProb,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 6,
                        style: const TextStyle(fontSize: 16)),
                    SizedBox(
                      height: 6.h,
                    ),
                    const Divider(
                      thickness: .5,
                      color: kBlack,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
