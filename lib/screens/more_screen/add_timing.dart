import 'package:doc_side_appoinment/constant_value/constant_colors.dart';
import 'package:doc_side_appoinment/constant_value/constant_size.dart';
import 'package:doc_side_appoinment/get_controller/get_controller.dart';
import 'package:doc_side_appoinment/models/schedule.dart';
import 'package:doc_side_appoinment/resources/data_methods.dart';
import 'package:doc_side_appoinment/utils/alert_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTiming extends StatelessWidget {
  AddTiming({Key? key}) : super(key: key);

  bool nine = false;
  bool ten = false;
  bool eleven = false;
  bool twelve = false;
  bool one = false;
  bool two = false;
  bool three = false;
  bool four = false;
  bool five = false;
  bool six = false;

  @override
  Widget build(BuildContext context) {
    print('widget');
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final date = DateFormat('dd/MM/yyyy').format(tomorrow);
    final size = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Add Time',
            style: TextStyle(color: kBlack),
          ),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: kBlack,
              )),
          automaticallyImplyLeading: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // kHeight30,
            GetBuilder<StateController>(
              init: StateController(),
              id: 'datetime',
              builder: (controller) {
                print("first get");
                return Container(
                    height: size * .04,
                    width: size * .16,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: kBlue, width: 1)),
                    child: InkWell(
                        onTap: () async {
                          final _selectedDateTemp = await showDatePicker(
                            context: context,
                            initialDate:
                                DateTime.now().add(const Duration(days: 1)),
                            firstDate:
                                DateTime.now().add(const Duration(days: 1)),
                            lastDate:
                                DateTime.now().add(const Duration(days: 7)),
                          );
                          if (_selectedDateTemp == null) {
                            return;
                          } else {
                            //print(_selectedDateTemp.toString());

                            controller.selectedDate = _selectedDateTemp;
                            controller.update(['datetime']);
                          }
                          print('add date');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(controller.selectedDate == null
                                ? 'Select Date'
                                : DateFormat('dd/MM/yyyy')
                                    .format(controller.selectedDate!)),
                            Icon(Icons.add),
                          ],
                        )));
              },
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                height: size * .5,
                width: size * 1,
                decoration: BoxDecoration(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 40.0, right: 40, top: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          time_button(size, stateControl.nine, '9:00 AM', nine),
                          time_button(size, stateControl.ten, '10:00 AM', ten),
                          time_button(
                              size, stateControl.eleven, '11:00 AM', eleven),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 6.0, right: 6, top: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          time_button(
                              size, stateControl.twel, '12:00 PM', twelve),
                          time_button(size, stateControl.one, '1:00 PM', one),
                          time_button(size, stateControl.two, '2:00 PM', two),
                          time_button(
                              size, stateControl.three, '3:00 PM', three),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 40.0, right: 40, top: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          time_button(size, stateControl.four, '4:00 PM', four),
                          time_button(size, stateControl.five, '5:00 PM', five),
                          time_button(size, stateControl.six, '6:00 PM', six),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: size * .06,
              width: size * .4,
              child: ElevatedButton(
                onPressed: () async {
                  stateControl.checkvar;
                  // print('----${stateControl.six}');
                  // print(stateControl.twel);
                  // print(stateControl.ten);
                  // print(stateControl.four);

                  print(stateControl.selectedDate);
                  if (stateControl.selectedDate == null) {
                  } else {
                    String? isemty = await DataController()
                        .scheduleDetailsExisting(stateControl.selectedDate!);
                    if (isemty == null) {
                      DataController().addScheduleDetails(
                        schedule: Schedule(
                          date: stateControl.selectedDate!,
                          nineAm: stateControl.nine,
                          tenAm: stateControl.ten,
                          elevenAm: stateControl.eleven,
                          twelvePm: stateControl.twel,
                          onepm: stateControl.one,
                          twoPm: stateControl.two,
                          threePm: stateControl.three,
                          fourPm: stateControl.four,
                          fivePm: stateControl.five,
                          sixPm: stateControl.six,
                        ),
                      );
                    } else {
                      showMyDialog(context, isemty);
                    }
                  }
                },
                child: Text(
                  'Add',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(kBlue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ))),
              ),
            ),
          ],
        ));
  }

  GetBuilder time_button(double size, bool control, String time, bool current) {
    return GetBuilder<StateController>(
        id: 'time_button',
        init: StateController(),
        builder: (controller) {
          print("second get");
          return InkWell(
            onTap: () {
              // print(controller.selectedDate);
              control = !control;
              print(control);
              if (time == '9:00 AM') {
                stateControl.nine = control;
              } else if (time == '10:00 AM') {
                stateControl.ten = control;
              } else if (time == '11:00 AM') {
                stateControl.eleven = control;
              } else if (time == '12:00 PM') {
                stateControl.twel = control;
              } else if (time == '1:00 PM') {
                stateControl.one = control;
              } else if (time == '2:00 PM') {
                stateControl.two = control;
              } else if (time == '3:00 PM') {
                stateControl.three = control;
              } else if (time == '4:00 PM') {
                stateControl.four = control;
              } else if (time == '5:00 PM') {
                stateControl.five = control;
              } else if (time == '6:00 PM') {
                stateControl.six = control;
              }

              controller.update(['time_button']);
              print(controller.six);
            },
            child: Container(
              width: size * .09,
              height: size * .036,
              decoration: BoxDecoration(
                  color: control == true ? kBlue : kWhite,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: kBlue, width: 1)),
              child: Center(
                  child: Text(
                time,
                style: TextStyle(
                    color: control == true ? kWhite : kBlack,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              )),
            ),
          );
        });
  }

  Future<void> showMyDialog(BuildContext context, String did) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Already exist!'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text('This Date is already exists.'),
                kHeight10,
                Text('Would you like to replace this Date?'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                DataController().updateScheduleDetails(
                  schedule: Schedule(
                    date: stateControl.selectedDate!,
                    nineAm: stateControl.nine,
                    tenAm: stateControl.ten,
                    elevenAm: stateControl.eleven,
                    twelvePm: stateControl.twel,
                    onepm: stateControl.one,
                    twoPm: stateControl.two,
                    threePm: stateControl.three,
                    fourPm: stateControl.four,
                    fivePm: stateControl.five,
                    sixPm: stateControl.six,
                  ),
                  did: did,
                );
                //Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
