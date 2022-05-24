import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:doc_side_appoinment/constant_value/constant_colors.dart';
import 'package:doc_side_appoinment/resources/auth_method.dart';
import 'package:doc_side_appoinment/resources/data_methods.dart';
import 'package:doc_side_appoinment/screens/authentication_screens/log_in.dart';
import 'package:doc_side_appoinment/screens/more_screen/add_timing.dart';
import 'package:doc_side_appoinment/screens/profile_screen/doctor_profile.dart';
import 'package:doc_side_appoinment/widgets/appbar_wiget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../get_controller/get_controller.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({Key? key}) : super(key: key);

  // static final String path = "lib/src/pages/settings/settings1.dart";

  // @override
  // void initState() {
  //   super.initState();
  //   _dark = false;
  // }

  // Brightness _getBrightness() {
  //   return _dark ? Brightness.dark : Brightness.light;
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height;
    stateControl.refreshUser();
    return Scaffold(
      // backgroundColor: _dark ? null : Colors.grey.shade200,
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
                            return state.user == null
                                ? Center(
                                    child: Text('Something went wrong'),
                                  )
                                : Card(
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
                                        state.user!.userName.capitalize!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              state.user!.photoUrl)),
                                      trailing: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                          },
                        ),
                        const SizedBox(height: 10.0),
                        // Card(
                        //   elevation: 4.0,
                        //   margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                        //   shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(10.0)),
                        //   child: Column(
                        //     children: <Widget>[
                        //       ListTile(
                        //         leading: Icon(
                        //           Icons.lock_outline,
                        //           color: Colors.purple,
                        //         ),
                        //         title: Text("Change Password"),
                        //         trailing: Icon(Icons.keyboard_arrow_right),
                        //         onTap: () {
                        //           //open change password
                        //         },
                        //       ),
                        //       _buildDivider(),
                        //       ListTile(
                        //         leading: Icon(
                        //           Icons.language_outlined,
                        //           color: Colors.purple,
                        //         ),
                        //         title: Text("Change Language"),
                        //         trailing: Icon(Icons.keyboard_arrow_right),
                        //         onTap: () {
                        //           //open change language
                        //         },
                        //       ),
                        //       _buildDivider(),
                        //       ListTile(
                        //         leading: Icon(
                        //           Icons.location_on,
                        //           color: Colors.purple,
                        //         ),
                        //         title: Text("Change Location"),
                        //         trailing: Icon(Icons.keyboard_arrow_right),
                        //         onTap: () {
                        //           //open change location
                        //         },
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        const SizedBox(height: 20.0),
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
                          //  activeColor: Colors.purple,
                          contentPadding: const EdgeInsets.all(0),
                          //value: true,
                          title: const Text("Add timing"),
                          trailing: const Icon(Icons.post_add),
                          //onChanged: (val) {},
                        ),
                        const ListTile(
                          //  activeColor: Colors.purple,
                          contentPadding: EdgeInsets.all(0),
                          //value: true,
                          title: Text("Help"),
                          //onChanged: (val) {},
                        ),
                        ListTile(
                          onTap: () {
                            dataController.getPastApp();
                          },
                          //  activeColor: Colors.purple,
                          contentPadding: EdgeInsets.all(0),
                          // value: false,
                          title: const Text("About"),
                          //onChanged: null,
                        ),
                        const ListTile(
                          //activeColor: Colors.purple,
                          contentPadding: EdgeInsets.all(0),
                          // value: true,
                          title: Text("Privacy Policy"),
                          // onChanged: (val) {},
                        ),
                        // SwitchListTile(
                        //   activeColor: Colors.purple,
                        //   contentPadding: const EdgeInsets.all(0),
                        //   value: true,
                        //   title: Text("Received App Updates"),
                        //   onChanged: null,
                        // ),
                        ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          title: const Text('Logout'),
                          trailing: const Icon(Icons.logout_outlined),
                          onTap: () {
                            print('logout clicked');
                            AuthMethods().signOut();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LogInScreen()),
                                (route) => false);
                          },
                        ),
                        const SizedBox(height: 60.0),
                      ],
                    ),
                  ),
                  // Positioned(
                  //   bottom: -20,
                  //   left: -20,
                  //   child: Container(
                  //     width: 80,
                  //     height: 80,
                  //     alignment: Alignment.center,
                  //     decoration: BoxDecoration(
                  //       color: kBlue,
                  //       shape: BoxShape.circle,
                  //     ),
                  //   ),
                  // ),
                  // Positioned(
                  //   bottom: 00,
                  //   left: 00,
                  //   child: IconButton(
                  //     icon: Icon(
                  //       Icons.power_off,
                  //       color: Colors.white,
                  //     ),
                  //     onPressed: () {
                  //       //log out
                  //     },
                  //   ),
                  // )
                ],
              );
            } else {
              return Container(
                height: size * .8,
                child: Center(
                  child: Text('Check your connection!'),
                ),
              );
            }
          }),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
}
