import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:doc_side_appoinment/constant_value/constant_colors.dart';
import 'package:doc_side_appoinment/get_controller/get_controller.dart';
import 'package:doc_side_appoinment/models/doc_appointment.dart';
import 'package:doc_side_appoinment/resources/data_methods.dart';
import 'package:doc_side_appoinment/screens/skeleton_screens/skeleton_patient.dart';
import 'package:doc_side_appoinment/widgets/review_screen.dart';
import 'package:doc_side_appoinment/screens/screen_home/patient_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../constant_value/constant_size.dart';

class PatientScreen extends StatefulWidget {
  PatientScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  DateTimeRange? dateRange;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Patients',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  // showModalBottomSheet<void>(
                  //   context: context,
                  //   builder: (BuildContext context) {
                  //     return Container(
                  //       height: 400,
                  //       //color: kWhite,
                  //       // decoration: BoxDecoration(
                  //       //   color: kBlack,
                  //       //   borderRadius:
                  //       //       BorderRadius.vertical(top: Radius.circular(30)),
                  //       // ),
                  //       child: Center(
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           mainAxisSize: MainAxisSize.min,
                  //           children: [],
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // );
                  bottom_scheet(context);
                },
                icon: Icon(
                  Icons.filter_list_outlined,
                  color: kBlack,
                ))
          ],
          centerTitle: true,
          elevation: 0,
          bottom: TabBar(
              controller: _tabController,
              indicatorWeight: 1,
              //indicatorColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelColor: kBlue,
              isScrollable: true,
              labelColor: kWhite,
              labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              indicator: BoxDecoration(
                  //color: kBlue,
                  borderRadius: BorderRadius.circular(50),
                  color: kBlue),
              tabs: [
                // Tab(
                //   text: 'Upcoming',
                //   height: 30,
                // ),
                Tab(
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: kBlue, width: 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Upcoming"),
                    ),
                  ),
                ),
                // Tab(
                //   text: 'Past',
                //   height: 30,
                // ),
                Tab(
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: kBlue, width: 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Past"),
                    ),
                  ),
                ),
              ])),
      body: TabBarView(
        controller: _tabController,
        children: [PatientList(), ReviewScreen()],
      ),
    );
  }

  Future<void> bottom_scheet(BuildContext context) {
    final size = MediaQuery.of(context).size.height;
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: size * .2,
          width: size * .1,

          // color: kBlue,
          // decoration: BoxDecoration(
          //   color: kBlack,
          //   borderRadius:
          //       BorderRadius.vertical(top: Radius.circular(30)),
          // ),
          child: GetBuilder<StateController>(
            init: StateController(),
            id: 'filter',
            builder: (filter) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Row(
                    children: [
                      Container(
                          width: size * .34,
                          // color: kBlack,
                          child: ListTile(
                            title: Text('Date range'),
                            onTap: () async {
                              await pickDateRange(context);
                              //  print(dateRange!.start);
                            },
                          )),
                      dateRange == null
                          ? Container()
                          : Text(
                              '${filter.selectedStartDate}  - ${filter.selectedEndDate}',
                              style: TextStyle(color: Colors.black),
                              // _selectedDate.toString(),
                            ),
                    ],
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(Duration(hours: 24 * 3)),
    );
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
      initialDateRange: dateRange ?? initialDateRange,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: kBlue,
              onPrimary: kWhite,
              surface: kBlue,
              onSurface: kWhite,
            ),

            // Here I Chaged the overline to my Custom TextStyle.
            textTheme: TextTheme(overline: TextStyle(fontSize: 16)),
            dialogBackgroundColor: kWhite,
          ),
          child: child!,
        );
      },
    );

    if (newDateRange == null) return;
    dateRange = newDateRange;
    stateControl.dateRange(dateRange);
    // statecontrol.update();
    dataController.dateRange = dateRange;
    dataController.update(['past']);

    // setState(() {});

    //print(newDateRange.start);
    //print(dateRange);
    // print(_selectedStartDate);
    if (dateRange != null) {}
  }
}

class PatientList extends StatelessWidget {
  PatientList({
    Key? key,
  }) : super(key: key);

  final ScrollController scrollController = ScrollController();

  final dataControl = Get.put(DataController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height;

    return StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.hasData && snapshot.data != ConnectivityResult.none) {
            return FutureBuilder<List<DoctorAppointment>>(
              future: dataControl.getUpcomingApp(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SkeletonPatient();
                }
                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
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
                    ),
                  );
                }
                return ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  itemBuilder: (ctx, index) {
                    final data = snapshot.data![index];
                    final String patientPhoto = data.appoDetails.photoUrl;
                    final String patientName = data.appoDetails.name;
                    final String patientAge = data.appoDetails.age;
                    final DateTime patientDate = data.appoDetails.date;
                    final String patientTime = data.appoDetails.time;
                    final String payment = data.appoDetails.payment;
                    final date = DateFormat('dd/MM/yyyy').format(patientDate);

                    return Card(
                      elevation: 0,
                      color: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: SizedBox(
                        height: size * .14,
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PatientAppointmentScreen(
                                            data: data,
                                          )));
                            },
                            // leading: CircleAvatar(
                            //   radius: 40,
                            //   backgroundColor: Colors.white,
                            //   backgroundImage: NetworkImage(patientPhoto),
                            // ),
                            // //leading:,
                            // title: Text(patientName.capitalize!),
                            // subtitle: Text(patientAge),
                            child: Row(
                              children: [
                                //kWidth10,
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.horizontal(
                                        left: Radius.circular(15.0),
                                        right: Radius.circular(15.0)),
                                    child: SizedBox(
                                      width: size * .12,
                                      child: FittedBox(
                                          fit: BoxFit.cover,
                                          child: Image.network(patientPhoto)),
                                      height: size * .12,
                                    ),
                                  ),
                                ),
                                kWidth20,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: size * .26,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Name : ',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: kBlue),
                                              ),
                                              Text(
                                                patientName.capitalize!,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: kBlue),
                                              ),
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
                                    //kHeight10,
                                    Row(
                                      children: [
                                        Text(
                                          'Age : ',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: kBlue),
                                        ),
                                        Text(
                                          patientAge,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: kBlue),
                                          overflow: TextOverflow.fade,
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: size * .26,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: size * .03,
                                            width: size * .12,
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
                                            height: size * .03,
                                            width: size * .09,
                                            decoration: BoxDecoration(
                                                // color: kBlue,
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                border: Border.all(
                                                    color: kBlue, width: 1)),
                                            child: Center(
                                                child: Text(patientTime)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //  kHeight10,
                                  ],
                                ),
                              ],
                            ),
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
              },
            );
          } else {
            return Container(
              height: size * .8,
              child: Center(
                child: Text('Check your connection!'),
              ),
            );
          }
        });
  }
}
