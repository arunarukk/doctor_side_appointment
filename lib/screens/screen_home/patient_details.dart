import 'package:doc_side_appoinment/constant_value/constant_colors.dart';
import 'package:doc_side_appoinment/constant_value/constant_size.dart';

import 'package:flutter/material.dart';

class PatientAppointmentScreen extends StatelessWidget {
  const PatientAppointmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as Doctor;
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
                              image: AssetImage(
                                'assets/lukman.jpeg',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    child: Container(
                      height: 25,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 21, 166, 26),
                        //borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                          child: Text('Paid', style: TextStyle(color: kWhite))),
                    ),
                  ),
                ],
              ),

              Container(
                color: kWhite,
                padding: const EdgeInsets.all(16),
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  children: [
                    Container(
                      // color: kGrey,
                      height: size * 0.08,
                      width: size * 0.3,
                      decoration: BoxDecoration(
                        // color: kBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              // color: kWhite,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text('Age',
                              style: TextStyle(
                                fontSize: 16,
                                //color: kWhite,
                              )),
                        ],
                      ),
                    ),
                    kHeight10,
                    Divider(
                      thickness: 0.5,
                      color: kBlack,
                    ),
                    kHeight10,
                    Text('Booking Date and Time',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    kHeight20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 30,
                          width: 120,
                          decoration: BoxDecoration(
                            color: kBlue,
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Center(
                              child: Text('12/04/2022',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: kWhite))),
                        ),
                        Container(
                          height: 30,
                          width: 100,
                          decoration: BoxDecoration(
                            color: kBlue,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                              child: Text(
                            '10:00 am',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: kWhite),
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
                    Text(
                        'Dr name •  is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries ',
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
