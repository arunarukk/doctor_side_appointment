import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:doc_side_appoinment/constant_value/constant_colors.dart';
import 'package:doc_side_appoinment/get_controller/get_controller.dart';
import 'package:doc_side_appoinment/models/doc_appointment.dart';
import 'package:doc_side_appoinment/resources/data_methods.dart';
import 'package:doc_side_appoinment/screens/skeleton_screens/skeleton_patient.dart';
import 'package:doc_side_appoinment/widgets/connection_lost.dart';
import 'package:doc_side_appoinment/widgets/review_screen.dart';
import 'package:doc_side_appoinment/screens/screen_home/patient_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../constant_value/constant_size.dart';

class PatientScreen extends StatefulWidget {
  const PatientScreen({
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
          title: const Text(
            'Patients',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  bottom_scheet(context);
                },
                icon: const Icon(
                  Icons.filter_list_outlined,
                  color: kBlack,
                ))
          ],
          centerTitle: true,
          elevation: 0,
          bottom: TabBar(
              controller: _tabController,
              indicatorWeight: 1,
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelColor: kBlue,
              isScrollable: true,
              labelColor: kWhite,
              labelStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), color: kBlue),
              tabs: [
                Tab(
                  child: Container(
                    width: 25.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: kBlue, width: 1)),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text("Upcoming"),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    width: 25.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: kBlue, width: 1)),
                    child: const Align(
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
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 20.h,
          width: 1.w,
          child: GetBuilder<StateController>(
            init: StateController(),
            id: 'filter',
            builder: (filter) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                          width: 70.w,
                          child: ListTile(
                            title: const Text('Date range'),
                            onTap: () async {
                              await pickDateRange(context);
                            },
                          )),
                      dateRange == null
                          ? Container()
                          : Text(
                              '${filter.selectedStartDate}  - ${filter.selectedEndDate}',
                              style: const TextStyle(color: Colors.black),
                            ),
                    ],
                  ),
                  Text(
                    'Filter for past',
                    style: TextStyle(color: Colors.grey.shade300),
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
      end: DateTime.now().add(const Duration(hours: 24 * 3)),
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
            textTheme: const TextTheme(overline: TextStyle(fontSize: 16)),
            dialogBackgroundColor: kWhite,
          ),
          child: child!,
        );
      },
    );

    if (newDateRange == null) return;
    dateRange = newDateRange;
    stateControl.dateRange(dateRange);
    dataController.dateRange = dateRange;
    dataController.update(['past']);
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
    return StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.hasData && snapshot.data != ConnectivityResult.none) {
            return FutureBuilder<List<DoctorAppointment>>(
              future: dataControl.getUpcomingApp(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SkeletonPatient();
                }
                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/no appointment.png',
                          scale: .8,
                        ),
                        const Text('No appointments'),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
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
                    final String isCanceld = data.appoDetails.status;
                    final date = DateFormat('dd/MM/yyyy').format(patientDate);

                    return Card(
                      elevation: 0,
                      color: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: SizedBox(
                        height: 14.h,
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
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.horizontal(
                                        left: Radius.circular(15.0),
                                        right: Radius.circular(15.0)),
                                    child: SizedBox(
                                      width: 25.w,
                                      child: FittedBox(
                                          fit: BoxFit.cover,
                                          child: Image.network(patientPhoto)),
                                      height: 25.h,
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
                                      width: 54.w,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 14.w,
                                                child: Text(
                                                  patientName.capitalize!,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kBlue),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                height: 3.h,
                                                width: 21.w,
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
                                              isCanceld == 'canceled'
                                                  ? Container(
                                                      height: 3.h,
                                                      width: 21.w,
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
                                          ),
                                        ],
                                      ),
                                    ),
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
                                      width: 53.w,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: 3.h,
                                            width: 21.w,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: kBlue, width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(6.0),
                                            ),
                                            child: Center(child: Text(date)),
                                          ),
                                          Container(
                                            height: 3.h,
                                            width: 20.w,
                                            decoration: BoxDecoration(
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
                    return SizedBox(
                      height: 5.h,
                    );
                  },
                  itemCount: snapshot.data!.length,
                );
              },
            );
          } else {
            return const ConnectionLost();
          }
        });
  }
}
