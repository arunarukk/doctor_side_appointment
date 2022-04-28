import 'package:doc_side_appoinment/constant_value/constant_colors.dart';
import 'package:doc_side_appoinment/models/doc_appointment.dart';
import 'package:doc_side_appoinment/resources/data_methods.dart';
import 'package:doc_side_appoinment/screens/review_details.dart';
import 'package:doc_side_appoinment/widgets/review_screen.dart';
import 'package:doc_side_appoinment/screens/screen_home/patient_details.dart';
import 'package:doc_side_appoinment/widgets/appbar_wiget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 400,
                        //color: kWhite,
                        // decoration: BoxDecoration(
                        //   color: kBlack,
                        //   borderRadius:
                        //       BorderRadius.vertical(top: Radius.circular(30)),
                        // ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [],
                          ),
                        ),
                      );
                    },
                  );
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
}

class PatientList extends StatelessWidget {
  PatientList({
    Key? key,
  }) : super(key: key);

  final ScrollController scrollController = ScrollController();

  final dataControl = Get.put(DataController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DoctorAppointment>>(
      future: dataControl.getUpcomingApp(),
      builder: (context, snapshot) => snapshot.data == null
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kBlue),
              ),
            )
          : ListView.separated(
              controller: scrollController,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              itemBuilder: (ctx, index) {
                final String patientPhoto =
                    snapshot.data![index].appoDetails.photoUrl;
                final String patientName =
                    snapshot.data![index].appoDetails.name;
                final String patientAge = snapshot.data![index].appoDetails.age;
                final data = snapshot.data![index];
                return Card(
                  color: kWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: SizedBox(
                    height: 100,
                    child: Center(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PatientAppointmentScreen(
                                        data: data,
                                      )));
                        },
                        leading: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(patientPhoto),
                        ),
                        title: Text(patientName.capitalize!),
                        subtitle: Text(patientAge),
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
              itemCount: snapshot.data!.length),
    );
  }
}
