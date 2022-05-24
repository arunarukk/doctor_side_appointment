import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:doc_side_appoinment/constant_value/constant_colors.dart';
import 'package:doc_side_appoinment/get_controller/get_controller.dart';
import 'package:doc_side_appoinment/models/doctor_model.dart';
import 'package:doc_side_appoinment/resources/specialty_mathod.dart';
import 'package:doc_side_appoinment/resources/storage_methods.dart';
import 'package:doc_side_appoinment/screens/authentication_screens/sign_up.dart';
import 'package:doc_side_appoinment/utils/image_picker_method.dart';
import 'package:doc_side_appoinment/widgets/connection_lost.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../skeleton_screens/skeleton_profile.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({Key? key}) : super(key: key);

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<DoctorProfileScreen>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  String? image;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  // final TextEditingController specialityController = TextEditingController();
  final TextEditingController exeController = TextEditingController();

  Map<String, dynamic> dropdownValue = {};
  final control = Get.put(SignController());
  selectImage() async {
    try {
      Uint8List im = await pickImage(ImageSource.gallery);
      stateControl.imageUpdate(im);
    } catch (e) {
      print('no image $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyle(color: kBlack),
          ),
          centerTitle: true,
          elevation: 0,
          // leading: IconButton(
          //     onPressed: () {
          //       Navigator.pop(context);
          //     },
          //     icon: Icon(
          //       Icons.arrow_back,
          //       color: kBlack,
          //     )),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Container(
            //color: Colors.white,
            child: StreamBuilder(
                stream: Connectivity().onConnectivityChanged,
                builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.hasData &&
                          snapshot.data != ConnectivityResult.none) {
                    return GetBuilder<StateController>(
                        id: 'profile',
                        builder: (controller) {
                          // print(controller.user);

                          return StreamBuilder<Doctor>(
                              stream: controller.getUserProfileDetails(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return SkeletonProfile();
                                }
                                if (snapshot.data == null) {
                                  return Center(
                                    child: Text('Something went wrong'),
                                  );
                                }
                                //print(snapshot.data!.speciality);
                                nameController.text =
                                    snapshot.data!.userName.capitalize!;
                                emailController.text = snapshot.data!.email;
                                mobileController.text =
                                    snapshot.data!.phoneNumber;
                                aboutController.text = snapshot.data!.about;
                                exeController.text = snapshot.data!.experience;
                                image = snapshot.data!.photoUrl;
                                if (dropdownValue.isEmpty &&
                                    snapshot.data!.speciality.isNotEmpty) {
                                  dropdownValue = snapshot.data!.speciality;
                                }
                                return ListView(
                                  children: [
                                    Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 30.h,
                                            //color: Colors.white,
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 20.0),
                                                  child: Stack(
                                                      fit: StackFit.loose,
                                                      children: <Widget>[
                                                        Positioned(
                                                          top: 0,
                                                          bottom: 0,
                                                          left: 6.h,
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              GetBuilder<
                                                                  StateController>(
                                                                init:
                                                                    StateController(),
                                                                id: 'photo',
                                                                builder:
                                                                    (photo) {
                                                                  return Container(
                                                                      width:
                                                                          75.w,
                                                                      height:
                                                                          75.h,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        image: photo.image !=
                                                                                null
                                                                            ? DecorationImage(
                                                                                image: MemoryImage(photo.image!),
                                                                                //NetworkImage(image!),
                                                                                fit: BoxFit.cover,
                                                                              )
                                                                            : DecorationImage(
                                                                                image: NetworkImage(image!),
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                      ));
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 160.0,
                                                                    right:
                                                                        100.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                InkWell(
                                                                  onTap: () {
                                                                    if (!_status) {
                                                                      selectImage();
                                                                    }
                                                                  },
                                                                  child:
                                                                      CircleAvatar(
                                                                    backgroundColor:
                                                                        kBlue,
                                                                    radius:
                                                                        25.0,
                                                                    child: Icon(
                                                                      Icons
                                                                          .camera_alt,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            )),
                                                      ]),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            color: Color(0xffFFFFFF),
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 25.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 25.0,
                                                          right: 25.0,
                                                          top: 25.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: <Widget>[
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: <Widget>[
                                                              Text(
                                                                'Parsonal Information',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: <Widget>[
                                                              _status
                                                                  ? _getEditIcon()
                                                                  : Container(),
                                                            ],
                                                          )
                                                        ],
                                                      )),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 25.0,
                                                          right: 25.0,
                                                          top: 25.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: <Widget>[
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: <Widget>[
                                                              Text(
                                                                'Name',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      )),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 25.0,
                                                          right: 25.0,
                                                          top: 2.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: <Widget>[
                                                          Flexible(
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  nameController,
                                                              decoration:
                                                                  const InputDecoration(
                                                                hintText:
                                                                    "Dr Name",
                                                              ),
                                                              enabled: !_status,
                                                              autofocus:
                                                                  !_status,
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'Please enter name';
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 25.0,
                                                          right: 25.0,
                                                          top: 25.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: <Widget>[
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: <Widget>[
                                                              Text(
                                                                'Email ID',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      )),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 25.0,
                                                          right: 25.0,
                                                          top: 2.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: <Widget>[
                                                          Flexible(
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  emailController,
                                                              decoration:
                                                                  const InputDecoration(
                                                                      hintText:
                                                                          "aaaa@gmail.com"),
                                                              enabled: !_status,
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'Please enter E-mail';
                                                                } else if (!value
                                                                        .contains(
                                                                            '@') ||
                                                                    !value.endsWith(
                                                                        '.com')) {
                                                                  return 'Please enter a valid E-mail';
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 25.0,
                                                          right: 25.0,
                                                          top: 25.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: <Widget>[
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: <Widget>[
                                                              Text(
                                                                'Mobile',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      )),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 25.0,
                                                          right: 25.0,
                                                          top: 2.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: <Widget>[
                                                          Flexible(
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  mobileController,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              // decoration: const InputDecoration(
                                                              //     hintText: "888888888"),
                                                              enabled: !_status,
                                                              validator:
                                                                  (value) {
                                                                String pattern =
                                                                    r'(^(?:[+0]9)?[0-9]{10}$)';
                                                                RegExp regExp =
                                                                    RegExp(
                                                                        pattern);
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'Please enter phone number';
                                                                } else if (!regExp
                                                                    .hasMatch(
                                                                        value)) {
                                                                  return 'Please enter valid phone number';
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 25.0,
                                                          right: 25.0,
                                                          top: 25.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Container(
                                                              child: Text(
                                                                'Speciality',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            flex: 2,
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              child: Text(
                                                                'Experience',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            flex: 2,
                                                          ),
                                                        ],
                                                      )),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 25.0,
                                                        right: 25.0,
                                                        top: 10.0,
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Flexible(
                                                            child: GetBuilder<
                                                                StateController>(
                                                              init:
                                                                  StateController(),
                                                              builder: (drop) {
                                                                return FutureBuilder<
                                                                    List<
                                                                        QueryDocumentSnapshot<
                                                                            Object?>>>(
                                                                  future:
                                                                      getSpeciality(),
                                                                  builder: (context,
                                                                      speciality) {
                                                                    if (speciality
                                                                            .connectionState ==
                                                                        ConnectionState
                                                                            .waiting) {
                                                                      // print('waiting');
                                                                    }
                                                                    if (speciality
                                                                            .data ==
                                                                        null) {
                                                                      return Center(
                                                                        child:
                                                                            CircularProgressIndicator(),
                                                                      );
                                                                    }
                                                                    final allvalue =
                                                                        speciality
                                                                            .data!;

                                                                    return DropdownButton<
                                                                            String>(
                                                                        hint: Text(snapshot.data!.speciality['name'] ==
                                                                                null
                                                                            ? 'select'
                                                                            : snapshot.data!.speciality['name']
                                                                                .toString()
                                                                                .toUpperCase()),
                                                                        value: drop
                                                                            .dropvalue,
                                                                        items: (allvalue).map(
                                                                            (e) {
                                                                          return DropdownMenuItem(
                                                                            value:
                                                                                e.id,
                                                                            child:
                                                                                Text(e['name'].toString().toUpperCase()),
                                                                            onTap:
                                                                                () {
                                                                              // print(
                                                                              //     e.data());

                                                                              dropdownValue = e.data() as Map<String, dynamic>;
                                                                            },
                                                                          );
                                                                        }).toList(),
                                                                        onChanged:
                                                                            (selectedValue) {
                                                                          if (!_status) {
                                                                            drop.dropDownChange(selectedValue!);
                                                                          }
                                                                        });
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                            flex: 2,
                                                          ),
                                                          Flexible(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 15.0,
                                                                right: 15,
                                                              ),
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    exeController,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                //decoration: const InputDecoration(
                                                                //hintText: "kerala"),
                                                                enabled:
                                                                    !_status,
                                                                validator:
                                                                    (value) {
                                                                  if (value ==
                                                                          null ||
                                                                      value
                                                                          .isEmpty) {
                                                                    return 'Please enter Experience';
                                                                  }
                                                                  return null;
                                                                },
                                                              ),
                                                            ),
                                                            flex: 2,
                                                          ),
                                                        ],
                                                      )),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 25.0,
                                                          right: 25.0,
                                                          top: 25.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: <Widget>[
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: <Widget>[
                                                              Text(
                                                                'About',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      )),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 25.0,
                                                          right: 25.0,
                                                          top: 2.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: <Widget>[
                                                          Flexible(
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  aboutController,
                                                              maxLines: 3,
                                                              // decoration: const InputDecoration(

                                                              //         ),
                                                              enabled: !_status,
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'Please enter Experience';
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                  !_status
                                                      ? _getActionButtons()
                                                      : Container(),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              });
                        });
                  } else {
                    return ConnectionLost();
                  }
                }),
          ),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: ElevatedButton(
                child: Text(
                  "Save",
                  style: TextStyle(
                    color: kWhite,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
                onPressed: () async {
                  if (dropdownValue.isEmpty) {
                    showSnackBar('please select Speciality', kRed, context);
                    return;
                  } else if (_formKey.currentState!.validate()) {
                    String imageUrl;
                    if (stateControl.image != null) {
                      imageUrl = await StorageMethods().uploadImageToStorage(
                          'profilePics', stateControl.image!, false);
                    } else {
                      imageUrl = image!;
                    }
                    updateDoctor(
                      email: emailController.text.toLowerCase(),
                      userName: nameController.text,
                      phoneNumber: mobileController.text,
                      photoUrl: imageUrl,
                      speciality: dropdownValue,
                      about: aboutController.text,
                      experience: exeController.text,
                    );
                    setState(() {
                      _status = true;
                      FocusScope.of(context).requestFocus(FocusNode());
                    });
                  }
                },
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: ElevatedButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: kWhite,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                },
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: kBlue,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        getSpeciality();
        setState(() {
          _status = false;
        });
      },
    );
  }
}
