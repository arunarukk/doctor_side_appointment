import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:doc_side_appoinment/constant_value/constant_colors.dart';
import 'package:doc_side_appoinment/models/doctor_model.dart';
import 'package:doc_side_appoinment/resources/auth_method.dart';
import 'package:doc_side_appoinment/screens/authentication_screens/log_in.dart';
import 'package:doc_side_appoinment/screens/main_screen_home/main_home_screen.dart';
import 'package:doc_side_appoinment/screens/more_screen/add_timing.dart';
import 'package:doc_side_appoinment/screens/profile_screen/doctor_profile.dart';
import 'package:doc_side_appoinment/widgets/appbar_wiget.dart';
import 'package:doc_side_appoinment/widgets/connection_lost.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../get_controller/get_controller.dart';

class MoreScreen extends StatelessWidget {
  MoreScreen({Key? key}) : super(key: key);
  final Uri _url = Uri.parse(
      'https://www.privacypolicies.com/live/865cfcc5-fe55-4100-af27-4b88bda6c477');

  void _launchUrl() async {
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    stateControl.getUserProfileDetails();
    return Scaffold(
      appBar: const PreferredSize(
          child: AppBarWidget(title: 'More'),
          preferredSize: Size.fromHeight(60)),
      body: StreamBuilder(
          stream: Connectivity().onConnectivityChanged,
          builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.hasData && snapshot.data != ConnectivityResult.none) {
              return Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GetBuilder<StateController>(
                          init: StateController(),
                          builder: (state) {
                            return StreamBuilder<Doctor>(
                                stream: state.getUserProfileDetails(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CupertinoActivityIndicator(
                                        color: kBlack,
                                      ),
                                    );
                                  }
                                  if (snapshot.data == null) {
                                    return const Text(
                                      'Hola',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: kBlack,
                                      ),
                                    );
                                  }

                                  final userName = snapshot.data!.userName;
                                  final photoUrl = snapshot.data!.photoUrl;
                                  return Card(
                                    elevation: 8.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    color: kBlue,
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const DoctorProfileScreen()));
                                      },
                                      title: Text(
                                        userName.capitalize!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      leading: CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(photoUrl)),
                                      trailing: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                });
                          },
                        ),
                        SizedBox(height: 6.h),
                        const Text(
                          "Settings",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddTiming()));
                          },
                          contentPadding: const EdgeInsets.all(0),
                          title: const Text("Add timing"),
                          trailing: const Icon(Icons.post_add),
                        ),
                        ListTile(
                          onTap: () {
                            showAboutDialog(
                              context: context,
                              applicationName: 'Medoc',
                              applicationVersion: '1.0.0',
                              applicationIcon: Image.asset(
                                'assets/medoc.png',
                                width: 15.w,
                              ),
                            );
                          },
                          contentPadding: const EdgeInsets.all(0),
                          title: const Text("About"),
                          trailing: const Icon(Icons.info_outline),
                        ),
                        ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          title: const Text("Privacy Policy"),
                          trailing: const Icon(Icons.privacy_tip_outlined),
                          onTap: () {
                            _launchUrl();
                          },
                        ),
                        ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          title: const Text('Logout'),
                          trailing: Icon(
                            Icons.logout_outlined,
                            color: kRed,
                          ),
                          onTap: () {
                            showMyDialog(context);
                          },
                        ),
                      ],
                    ),
                  ),
                 ],
              );
            } else {
              return const ConnectionLost();
            }
          }),
    );
  }

  Future<void> showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: TextStyle(color: kRed),
          ),
          content: const Text('Do you want to logout ?'),
          actions: [
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                AuthMethods().signOut().then((value) {
                  MainHomeScreen.selectedIndexNotifier.value = 0;
                });
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LogInScreen()),
                    (route) => false);
              },
            ),
            TextButton(
              child: const Text('No'),
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
