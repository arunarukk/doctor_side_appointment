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
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController exeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  Map<String, dynamic> dropdownValue = {};
  final control = Get.put(SignController());
  selectImage() async {
    try {
      Uint8List im = await pickImage(ImageSource.gallery);
      stateControl.imageUpdate(im);
    } catch (e) {
      debugPrint('no image $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (stateControl.image != null) {
      stateControl.image = null;
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(color: kBlack),
          ),
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: StreamBuilder(
              stream: Connectivity().onConnectivityChanged,
              builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.hasData &&
                        snapshot.data != ConnectivityResult.none) {
                  return GetBuilder<StateController>(
                      id: 'profile',
                      builder: (controller) {
                        return StreamBuilder<Doctor>(
                            stream: controller.getUserProfileDetails(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SkeletonProfile();
                              }
                              if (snapshot.data == null) {
                                return const Center(
                                  child: Text('Something went wrong'),
                                );
                              }
                              nameController.text =
                                  snapshot.data!.userName.capitalize!;
                              emailController.text = snapshot.data!.email;
                              mobileController.text =
                                  snapshot.data!.phoneNumber;
                              aboutController.text = snapshot.data!.about;
                              exeController.text = snapshot.data!.experience;
                              image = snapshot.data!.photoUrl;
                              qualificationController.text =
                                  snapshot.data!.qualifications;
                              addressController.text = snapshot.data!.address;
                              if (dropdownValue.isEmpty &&
                                  snapshot.data!.speciality.isNotEmpty) {
                                dropdownValue = snapshot.data!.speciality;
                              }
                              return ListView(
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 30.h,
                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
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
                                                              builder: (photo) {
                                                                return Container(
                                                                    width: 75.w,
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
                                                                          : image != null
                                                                              ? DecorationImage(
                                                                                  image: NetworkImage(image!),
                                                                                  fit: BoxFit.cover,
                                                                                )
                                                                              : const DecorationImage(
                                                                                  image: AssetImage('assets/noProfile.png'),
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
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 160.0,
                                                                  right: 100.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
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
                                                                  radius: 25.0,
                                                                  child:
                                                                      const Icon(
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
                                          color: const Color(0xffFFFFFF),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 25.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
                                                              MainAxisSize.min,
                                                          children: const [
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
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            _status
                                                                ? _getEditIcon()
                                                                : Container(),
                                                          ],
                                                        )
                                                      ],
                                                    )),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
                                                              MainAxisSize.min,
                                                          children: const [
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 25.0,
                                                            right: 25.0,
                                                            top: 2.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: <Widget>[
                                                        Flexible(
                                                          child: TextFormField(
                                                            controller:
                                                                nameController,
                                                            decoration:
                                                                const InputDecoration(
                                                              hintText:
                                                                  "Dr Name",
                                                            ),
                                                            enabled: !_status,
                                                            autofocus: !_status,
                                                            validator: (value) {
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
                                                    padding:
                                                        const EdgeInsets.only(
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
                                                              MainAxisSize.min,
                                                          children: const [
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 25.0,
                                                            right: 25.0,
                                                            top: 2.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: <Widget>[
                                                        Flexible(
                                                          child: TextFormField(
                                                            controller:
                                                                emailController,
                                                            decoration:
                                                                const InputDecoration(
                                                                    hintText:
                                                                        "aaaa@gmail.com"),
                                                            enabled: !_status,
                                                            validator: (value) {
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
                                                    padding:
                                                        const EdgeInsets.only(
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
                                                              MainAxisSize.min,
                                                          children: const [
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 25.0,
                                                            right: 25.0,
                                                            top: 2.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: <Widget>[
                                                        Flexible(
                                                          child: TextFormField(
                                                            controller:
                                                                mobileController,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            enabled: !_status,
                                                            validator: (value) {
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
                                                    padding:
                                                        const EdgeInsets.only(
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
                                                              MainAxisSize.min,
                                                          children: const [
                                                            Text(
                                                              'Address',
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 25.0,
                                                            right: 25.0,
                                                            top: 2.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: <Widget>[
                                                        Flexible(
                                                          child: TextFormField(
                                                            controller:
                                                                addressController,
                                                            decoration:
                                                                const InputDecoration(
                                                              hintText:
                                                                  "Address",
                                                            ),
                                                            enabled: !_status,
                                                            autofocus: !_status,
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter adress';
                                                              }
                                                              return null;
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 25.0,
                                                            right: 25.0,
                                                            top: 25.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: const [
                                                        Expanded(
                                                          child: Text(
                                                            'Speciality',
                                                            style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          flex: 2,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            'Experience',
                                                            style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          flex: 2,
                                                        ),
                                                      ],
                                                    )),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
                                                                          .waiting) {}
                                                                  if (speciality
                                                                          .data ==
                                                                      null) {
                                                                    return const Center(
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
                                                                      items: (allvalue)
                                                                          .map(
                                                                              (e) {
                                                                        return DropdownMenuItem(
                                                                          value:
                                                                              e.id,
                                                                          child: Text(e['name']
                                                                              .toString()
                                                                              .toUpperCase()),
                                                                          onTap:
                                                                              () {
                                                                            dropdownValue =
                                                                                e.data() as Map<String, dynamic>;
                                                                          },
                                                                        );
                                                                      }).toList(),
                                                                      onChanged:
                                                                          (selectedValue) {
                                                                        if (!_status) {
                                                                          drop.dropDownChange(
                                                                              selectedValue!);
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
                                                          flex: 2,
                                                        ),
                                                      ],
                                                    )),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
                                                              MainAxisSize.min,
                                                          children: const [
                                                            Text(
                                                              'Qualification',
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 25.0,
                                                            right: 25.0,
                                                            top: 2.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: <Widget>[
                                                        Flexible(
                                                          child: TextFormField(
                                                            controller:
                                                                qualificationController,
                                                            decoration:
                                                                const InputDecoration(
                                                              hintText:
                                                                  "Qualification",
                                                            ),
                                                            enabled: !_status,
                                                            autofocus: !_status,
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter Qualification';
                                                              }
                                                              return null;
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
                                                              MainAxisSize.min,
                                                          children: const [
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 25.0,
                                                            right: 25.0,
                                                            top: 2.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: <Widget>[
                                                        Flexible(
                                                          child: TextFormField(
                                                            controller:
                                                                aboutController,
                                                            maxLines: 3,
                                                            enabled: !_status,
                                                            validator: (value) {
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
                  return const ConnectionLost();
                }
              }),
        ));
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: ElevatedButton(
                child: const Text(
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
                      qualifications: qualificationController.text,
                      address: addressController.text,
                    );
                    setState(() {
                      _status = true;
                      FocusScope.of(context).requestFocus(FocusNode());
                    });
                  }
                },
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: ElevatedButton(
                child: const Text(
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
              ),
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
        child: const Icon(
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
