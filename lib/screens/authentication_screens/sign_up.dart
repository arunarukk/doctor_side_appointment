import 'dart:typed_data';
import 'package:doc_side_appoinment/resources/auth_method.dart';
import 'package:doc_side_appoinment/screens/main_screen_home/main_home_screen.dart';
import 'package:doc_side_appoinment/utils/image_picker_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:doc_side_appoinment/constant_value/constant_colors.dart';
import 'package:doc_side_appoinment/screens/authentication_screens/log_in.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:sizer/sizer.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _password = TextEditingController();

  final TextEditingController _confirmPassword = TextEditingController();

  final TextEditingController _phoneNumber = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _userNameController = TextEditingController();

  final OtpFieldController _otpController = OtpFieldController();

  final control = Get.put(SignController());

  bool otpCodeVisible = false;

  bool passwordDisable = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String verificationIdRecieved = '';

  String otpPin = '';

  selectImage() async {
    try {
      Uint8List im = await pickImage(ImageSource.gallery);
      control.imageUpdate(im);
    } catch (e) {
      debugPrint('no image $e');
    }
  }

  void verifyNumber(BuildContext ctx) async {
    if (control.image == null) {
      showSnackBar('Image required', kRed, ctx);
      debugPrint('image is null');
      return;
    }
    if (_formKey.currentState!.validate()) {
      control.loading(true);
      control.update(['checkbox']);
      _auth.verifyPhoneNumber(
          phoneNumber: '+91${_phoneNumber.text}',
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.signInWithCredential(credential).then((value) => {});
          },
          verificationFailed: (FirebaseAuthException exception) {
            debugPrint(exception.message);
          },
          codeSent: (String verificationId, int? resendToken) {
            verificationIdRecieved = verificationId;
            otpCodeVisible = true;
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    }
    await Future.delayed(const Duration(seconds: 2));
    control.loading(false);
    control.update(['checkbox']);
  }

  void verifyCode(BuildContext ctx) async {
    PhoneAuthCredential cred = PhoneAuthProvider.credential(
        verificationId: verificationIdRecieved, smsCode: otpPin);
    await _auth.signInWithCredential(cred).then((value) async {
      control.loading(true);
      control.update(['checkbox']);
      {
        try {
          debugPrint('verifycode ${value.user!.uid}');
          String result = await AuthMethods().otpSingUp(
            email: _emailController.text,
            uid: value.user!.uid,
            userName: _userNameController.text.toLowerCase(),
            phoneNumber: _phoneNumber.text,
            file: control.image!,
          );

          if (result != 'Success') {
            showSnackBar(result, kRed, ctx);
            return;
          }
          Navigator.of(ctx).pushAndRemoveUntil(
              MaterialPageRoute(builder: (ctx) => const MainHomeScreen()),
              (route) => false);
          showSnackBar(result, kGreen, ctx);
          debugPrint('otp login wit succes');
        } catch (e) {
          debugPrint('verifycode otp $e');
        }
      }
      control.loading(false);
      control.update(['checkbox']);
    });
  }

  void signUpDoctor(BuildContext ctx) async {
    if (control.image == null) {
      showSnackBar('Image required', kRed, ctx);
      debugPrint('image is null');
      return;
    }
    if (_formKey.currentState!.validate()) {
      control.loading(true);
      control.update(['checkbox']);
      String result = await AuthMethods().signUpDoctor(
        email: _emailController.text,
        password: _password.text,
        userName: _userNameController.text.toLowerCase(),
        phoneNumber: _phoneNumber.text,
        file: control.image!,
      );
      control.loading(false);
      control.update(['checkbox']);
      if (result != 'Success') {
        showSnackBar(result, kRed, ctx);
        return;
      }
      Get.to(LogInScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    control.loading(false);
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 0, 162, 255),
                Color.fromARGB(255, 60, 39, 176)
              ]),
        ),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Positioned(
              top: 1.h,
              left: -20.w,
              child: Container(
                height: 20.h,
                width: 80.w,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.7),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(300),
                      bottomRight: Radius.circular(300)),
                ),
              ),
            ),
            Positioned(
              top: 1.h,
              left: 50.w,
              child: Container(
                height: 20.h,
                width: 80.w,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.7),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(300),
                      bottomRight: Radius.circular(300)),
                ),
              ),
            ),
            Positioned(
              top: -10.h,
              right: -10.w,
              child: Container(
                height: 33.h,
                width: 120.w,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(300),
                      bottomRight: Radius.circular(300)),
                ),
              ),
            ),
            Positioned(
              top: 90.h,
              right: -25.w,
              child: Container(
                height: 35.h,
                width: 60.w,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 153, 0),
                    borderRadius: BorderRadius.all(Radius.circular(200))),
              ),
            ),
            Positioned(
              top: 90.h,
              left: -25.w,
              child: Container(
                height: 35.h,
                width: 60.w,
                decoration: const BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.all(Radius.circular(200))),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  Stack(
                    children: [
                      GetBuilder<SignController>(
                        builder: ((controller) {
                          return control.image != null
                              ? CircleAvatar(
                                  radius: 64,
                                  backgroundImage: MemoryImage(control.image!),
                                  backgroundColor: Colors.red,
                                )
                              : const CircleAvatar(
                                  radius: 64,
                                  backgroundImage:
                                      AssetImage('assets/noProfile.png'),
                                  backgroundColor: Colors.red,
                                );
                        }),
                      ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      )
                    ],
                  ),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 50.0, right: 50, top: 20),
                          child: TextFormField(
                            controller: _userNameController,
                            style: const TextStyle(color: kWhite),
                            decoration: const InputDecoration(
                              fillColor: Color.fromARGB(255, 48, 150, 223),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              labelStyle: TextStyle(color: Colors.white),
                              labelText: 'User name',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),

                              prefixIcon: Padding(
                                padding: EdgeInsets.only(
                                    top: 0), // add padding to adjust icon
                                child: Icon(
                                  Icons.person_outline,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter name';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 50.0, right: 50, top: 10),
                          child: TextFormField(
                            controller: _phoneNumber,
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
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 50.0, right: 50, top: 10),
                          child: TextFormField(
                            controller: _emailController,
                            style: const TextStyle(color: kWhite),
                            decoration: const InputDecoration(
                              fillColor: Color.fromARGB(255, 48, 150, 223),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              labelStyle: TextStyle(color: Colors.white),
                              labelText: 'E-mail',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),

                              prefixIcon: Padding(
                                padding: EdgeInsets.only(
                                    top: 0), // add padding to adjust icon
                                child: Icon(
                                  Icons.email_outlined,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter E-mail';
                              } else if (!value.contains('@') ||
                                  !value.endsWith('.com')) {
                                return 'Please enter a valid E-mail';
                              }
                              return null;
                            },
                          ),
                        ),
                        Visibility(
                          visible: otpCodeVisible,
                          child: OTPTextField(
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            length: 6,
                            width: 4.w,
                            fieldWidth: 40,
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
                        GetBuilder<SignController>(
                          init: SignController(),
                          id: 'checkbox',
                          builder: (checkBox) {
                            return Column(
                              children: [
                                Visibility(
                                  visible: !checkBox.otpLogin,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 50.0,
                                      right: 50,
                                      top: 10,
                                    ),
                                    child: GetBuilder<PageStateController>(
                                      init: PageStateController(),
                                      id: 'pass',
                                      builder: (pass) {
                                        return TextFormField(
                                          enabled: passwordDisable,
                                          controller: _password,
                                          obscureText: pass.passwordVisible,
                                          style: const TextStyle(color: kWhite),
                                          decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              focusedBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                              ),
                                              labelStyle: const TextStyle(
                                                  color: Colors.white),
                                              labelText: 'Password',
                                              enabledBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                              ),
                                              prefixIcon: const Padding(
                                                padding: EdgeInsets.only(
                                                    top:
                                                        0), // add padding to adjust icon
                                                child: Icon(
                                                  Icons.lock_outline,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                              suffixIcon: IconButton(
                                                  onPressed: () {
                                                    if (pass.passwordVisible ==
                                                        true) {
                                                      pass.passwordVisible =
                                                          false;
                                                    } else {
                                                      pass.passwordVisible =
                                                          true;
                                                    }

                                                    pass.update(['pass']);
                                                  },
                                                  icon: Icon(
                                                      pass.passwordVisible ==
                                                              true
                                                          ? Icons
                                                              .remove_red_eye_rounded
                                                          : Icons
                                                              .remove_red_eye_outlined,
                                                      size: 16,
                                                      color: kWhite))),
                                          validator: (value) {
                                            RegExp regex = RegExp(
                                                r'^(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter password';
                                            } else if (!regex.hasMatch(value)) {
                                              return 'Password must contain at least one lower case \nand one digit';
                                            }
                                            return null;
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: !checkBox.otpLogin,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50.0,
                                        right: 50,
                                        top: 10,
                                        bottom: 20),
                                    child: GetBuilder<PageStateController>(
                                      init: PageStateController(),
                                      id: 'confirm',
                                      builder: (confirm) {
                                        return TextFormField(
                                          enabled: passwordDisable,
                                          controller: _confirmPassword,
                                          style: const TextStyle(color: kWhite),
                                          obscureText: confirm.passwordVisible,
                                          decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              focusedBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                              ),
                                              labelStyle: const TextStyle(
                                                  color: Colors.white),
                                              labelText: 'Confirm password',
                                              enabledBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                              ),
                                              prefixIcon: const Padding(
                                                padding: EdgeInsets.only(
                                                    top:
                                                        0), // add padding to adjust icon
                                                child: Icon(
                                                  Icons.lock_outline,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                              suffixIcon: IconButton(
                                                  onPressed: () {
                                                    if (confirm
                                                            .passwordVisible ==
                                                        true) {
                                                      confirm.passwordVisible =
                                                          false;
                                                    } else {
                                                      confirm.passwordVisible =
                                                          true;
                                                    }

                                                    confirm.update(['confirm']);
                                                  },
                                                  icon: Icon(
                                                      confirm.passwordVisible ==
                                                              true
                                                          ? Icons
                                                              .remove_red_eye_rounded
                                                          : Icons
                                                              .remove_red_eye_outlined,
                                                      size: 16,
                                                      color: kWhite))),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty ||
                                                value != _password.text) {
                                              return "Password doesn't match";
                                            }
                                            return null;
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 50.0,
                                      right: 50,
                                      top: 10,
                                      bottom: 20),
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Login with phone number',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Checkbox(
                                        activeColor: kRed,
                                        value: checkBox.otpLogin,
                                        onChanged: (bool? value) {
                                          passwordDisable = !value!;
                                          checkBox.otpLogin = value;
                                          checkBox.update(['checkbox']);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (signControl.otpLogin == false) {
                              signUpDoctor(context);
                            } else {
                              if (otpCodeVisible) {
                                verifyCode(context);
                              } else {
                                verifyNumber(context);
                              }
                            }
                          },
                          child: GetBuilder<SignController>(
                            id: 'checkbox',
                            builder: (controller) {
                              return controller.isLoading!
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: kWhite,
                                      ),
                                    )
                                  : Text(
                                      controller.otpLogin == false
                                          ? "Login"
                                          : otpCodeVisible
                                              ? "Login"
                                              : "verify",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    );
                            },
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: const Color.fromARGB(255, 241, 187, 38),
                              fixedSize: const Size(300, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50))),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(color: kWhite),
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LogInScreen()));
                          },
                          child: const Text(
                            'Login here',
                            style: TextStyle(color: kWhite),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final signControl = Get.put(SignController());

class SignController extends GetxController {
  Uint8List? image;
  bool? isLoading;
  bool otpLogin = false;
  void imageUpdate(Uint8List img) {
    image = img;
    update();
  }

  void loading(bool load) {
    isLoading = load;
  }
}
