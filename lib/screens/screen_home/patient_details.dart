import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doc_side_appoinment/constant_value/constant_colors.dart';
import 'package:doc_side_appoinment/constant_value/constant_size.dart';
import 'package:doc_side_appoinment/models/doc_appointment.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class PatientAppointmentScreen extends StatelessWidget {
  PatientAppointmentScreen({Key? key, this.data}) : super(key: key);

  DoctorAppointment? data;

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as Doctor;

    final photoUrl = data!.appoDetails.photoUrl;
    final patientName = data!.appoDetails.name;
    final patientAge = data!.appoDetails.age;
    final patientProb = data!.appoDetails.problem;
    final time = data!.appoDetails.time;
    final bookingDate = data!.appoDetails.date;
    final payment = data!.appoDetails.payment;
    final phonenumber = data!.appoDetails.phoneNumber;
    print(bookingDate);
    final date = DateFormat('dd/MM/yyyy').format(bookingDate);

    final size = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Patient Profile',
          style: TextStyle(color: kBlack),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              // final doctor = FirebaseAuth.instance.currentUser;
              // print(doctor!.displayName);
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: kBlack,
            )),
        //automaticallyImplyLeading: true,
      ),
      body: Container(
        // decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //         begin: Alignment.topLeft,
        //         end: Alignment.bottomRight,
        //         colors: [
        //       Color.fromARGB(255, 0, 162, 255),
        //       Color.fromARGB(255, 60, 39, 176)
        //     ])),
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Hero(
              //   tag: 'assets/lukman.jpeg',
              //   child: Material(
              //       type: MaterialType.transparency,
              //       child: Container(
              //         alignment: Alignment.topCenter,
              //         height: size * .5,
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.only(
              //               bottomLeft: Radius.circular(50),
              //               bottomRight: Radius.circular(50)),
              //           color: kGrey,
              //           image: DecorationImage(
              //             fit: BoxFit.cover,
              //             image: AssetImage(
              //               'assets/lukman.jpeg',
              //             ),
              //           ),
              //         ),
              //       )),
              // ),
              Stack(
                children: [
                  Container(
                    color: kGrey,
                    height: size * .3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: size * .3,
                          width: size * .2,
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
                      height: 25,
                      width: 90,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 21, 166, 26),
                        //borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                          child:
                              Text(payment, style: TextStyle(color: kWhite))),
                    ),
                  ),
                ],
              ),

              Container(
                color: kWhite,
                padding: const EdgeInsets.all(16),
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //   // color: kGrey,
                    //   height: size * 0.08,
                    //   width: size * 0.3,
                    //   decoration: BoxDecoration(
                    //     // color: kBlue,
                    //     borderRadius: BorderRadius.circular(8),
                    //   ),
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Name :  ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    // color: kWhite,
                                  ),
                                ),
                                Text(
                                  patientName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    // color: kWhite,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Age :     ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    // color: kWhite,
                                  ),
                                ),
                                Text(patientAge,
                                    style: TextStyle(
                                      fontSize: 16,
                                      //color: kWhite,
                                    )),
                              ],
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            launchUrl(Uri(scheme: 'tel', path: phonenumber));
                          },
                          child: Container(
                            height: size * .06,
                            width: size * .06,
                            decoration: BoxDecoration(
                              color: kGreen,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.call,
                              color: kWhite,
                            ),
                          ),
                        ),
                      ],
                    ),

                    kHeight10,
                    Divider(
                      thickness: 0.5,
                      color: kBlack,
                    ),
                    //kHeight10,
                    Text('Booking Date and Time',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    kHeight20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 30,
                          width: 120,
                          decoration: BoxDecoration(
                            //color: kBlue,
                            border: Border.all(color: kBlue, width: 1),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Center(
                              child: Text(
                            date,
                            style: TextStyle(fontSize: 16),
                          )),
                        ),
                        kWidth10,
                        Container(
                          height: 30,
                          width: 80,
                          decoration: BoxDecoration(
                              // color: kBlue,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: kBlue, width: 1)),
                          child: Center(
                              child: Text(
                            time,
                            style: TextStyle(fontSize: 16),
                          )),
                        ),
                      ],
                    ),
                    kHeight10,
                    Divider(
                      thickness: .5,
                      color: kBlack,
                    ),
                    Text('Description',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    kHeight20,
                    Text(patientProb,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 6,
                        style: TextStyle(fontSize: 16)),
                    const SizedBox(
                      height: 16,
                    ),
                    Divider(
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
