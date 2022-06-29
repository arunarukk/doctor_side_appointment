import 'package:doc_side_appoinment/resources/auth_method.dart';
import 'package:doc_side_appoinment/screens/authentication_screens/sign_up.dart';
import 'package:doc_side_appoinment/screens/main_screen_home/main_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:sizer/sizer.dart';

import '../../constant_value/constant_colors.dart';
import '../../constant_value/constant_size.dart';

class OtpAuthScreen extends StatefulWidget {
  const OtpAuthScreen({Key? key}) : super(key: key);

  @override
  State<OtpAuthScreen> createState() => _OtpAuthScreenState();
}

class _OtpAuthScreenState extends State<OtpAuthScreen> {
  final TextEditingController phoneController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  String verificationIdRecieved = '';

  bool otpCodeVisible = false;

  String otpPin = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Color.fromARGB(255, 0, 162, 255),
              Color.fromARGB(255, 51, 19, 231)
            ])),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: 55.h,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 8.0,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(200),
                      bottomRight: Radius.circular(200)),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 13.h, bottom: 14.h),
                    child: SizedBox(
                      child: Image.asset(
                        'assets/login_screen.png',
                        width: 60.w,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 13.w, right: 13.w, top: 1.h),
                    child: TextFormField(
                      controller: phoneController,
                      style: const TextStyle(color: kWhite),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        fillColor: Color.fromARGB(255, 48, 150, 223),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelStyle: TextStyle(color: Colors.white),
                        labelText: 'Phone number',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(
                              top: 0), // add padding to adjust icon
                          child: Icon(
                            Icons.phone_android,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                      validator: (value) {
                        String pattern = r'(^(?:[+0]9)?[0-9]{10}$)';
                        RegExp regExp = RegExp(pattern);
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone number';
                        } else if (!regExp.hasMatch(value)) {
                          return 'Please enter valid phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                  kHeight20,
                  Visibility(
                    visible: otpCodeVisible,
                    child: OTPTextField(
                      keyboardType: TextInputType.number,
                      length: 6,
                      width: 80.w,
                      fieldWidth: 8.w,
                      style: const TextStyle(fontSize: 17, color: kWhite),
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldStyle: FieldStyle.underline,
                      otpFieldStyle: OtpFieldStyle(
                        borderColor: kWhite,
                        disabledBorderColor: kWhite,
                        enabledBorderColor: kWhite,
                        focusBorderColor: kWhite,
                        errorBorderColor: kRed,
                      ),
                      onChanged: (newpin) {
                        debugPrint(newpin);
                      },
                      onCompleted: (pin) {
                        debugPrint("Completed: " + pin);
                        otpPin = pin;
                      },
                    ),
                  ),
                  SizedBox(height: 10.h),
                  ElevatedButton(
                      onPressed: () {
                        if (otpCodeVisible) {
                          verifyCode();
                        } else {
                          verifyNumber();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(255, 241, 187, 38),
                          fixedSize: const Size(300, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                      child: GetBuilder<SignController>(
                        init: SignController(),
                        id: 'verify',
                        builder: (verify) {
                          return verify.isLoading == true
                              ? const Center(
                                  child:  CircularProgressIndicator(
                                  color: kWhite,
                                ))
                              : Text(
                                  otpCodeVisible ? "Login" : "Verify",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18),
                                );
                        },
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void verifyNumber() async {
    signControl.loading(true);
    signControl.update(['verify']);
    auth.verifyPhoneNumber(
        phoneNumber: "+91${phoneController.text}",
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential).then((value) => {
                debugPrint("your logged in successfully"),
              });
        },
        verificationFailed: (FirebaseAuthException exception) {
          debugPrint(exception.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          verificationIdRecieved = verificationId;
          otpCodeVisible = true;
          setState(() {});
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
    await Future.delayed(const Duration(seconds: 2));
    signControl.loading(false);
    signControl.update(['verify']);
  }

  void verifyCode() async {
    signControl.loading(true);
    signControl.update(['verify']);
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationIdRecieved, smsCode: otpPin);
    await auth.signInWithCredential(credential).then((value) async {
      {
        User currentUser = auth.currentUser!;
        final data = await AuthMethods().getUserDetails();

        debugPrint("you are logged in successfully");
        if (data.userName!=null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>const MainHomeScreen(),
            ),
            (route) => false,
          );
        } else {
          debugPrint('phone exist verify code');

          currentUser.delete();
        }
      }
      await Future.delayed(const Duration(seconds: 2));
      signControl.loading(false);
      signControl.update(['verify']);
    });
  }
}
