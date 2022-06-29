import 'package:doc_side_appoinment/constant_value/constant_colors.dart';
import 'package:doc_side_appoinment/resources/auth_method.dart';
import 'package:doc_side_appoinment/screens/authentication_screens/otp_auth_screen.dart';
import 'package:doc_side_appoinment/screens/authentication_screens/sign_up.dart';
import 'package:doc_side_appoinment/screens/main_screen_home/main_home_screen.dart';
import 'package:doc_side_appoinment/utils/image_picker_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void logInDoctor(BuildContext ctx) async {
    signControl.loading(true);
    signControl.update(['loading']);

    String result = await AuthMethods().logInUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (result == 'Success') {
      // Navigator.of(ctx).pushReplacement(
      //     MaterialPageRoute(builder: (ctx) => const MainHomeScreen()));
      Get.offAll(const MainHomeScreen());
      showSnackBar(result, kGreen, ctx);
      debugPrint("----------------$result");
    } else {
      showSnackBar(result, kRed, ctx);
    }
    signControl.loading(false);
    signControl.update(['loading']);
  }

  @override
  Widget build(BuildContext context) {
    signControl.loading(false);
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
              Color.fromARGB(255, 60, 39, 176)
            ])),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: 55.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: kBlack,
                      blurRadius: 8.0,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(200.h),
                      bottomRight: Radius.circular(200.h)),
                ),
              ),
              Column(
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
                  Form(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 13.w, right: 13.w, top: 1.h),
                          child: TextFormField(
                            controller: _emailController,
                            style: const TextStyle(color: kWhite),
                            decoration: const InputDecoration(
                              fillColor: Color.fromARGB(255, 48, 150, 223),
                              //filled: true,
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
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 13.w, right: 13.w, top: 3.h, bottom: 3.h),
                          child: GetBuilder<PageStateController>(
                              init: PageStateController(),
                              id: 'visiblity',
                              builder: (visible) {
                                return TextFormField(
                                  controller: _passwordController,
                                  obscureText: visible.passwordVisible,
                                  style: const TextStyle(color: kWhite),
                                  decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      labelStyle:
                                          const TextStyle(color: Colors.white),
                                      labelText: 'Password',
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      prefixIcon: const Padding(
                                        padding: EdgeInsets.only(
                                            top:
                                                0), // add padding to adjust icon
                                        child: Icon(
                                          Icons.lock_outline,
                                          color: Colors.white,
                                        ),
                                      ),
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            if (visible.passwordVisible ==
                                                true) {
                                              visible.passwordVisible = false;
                                            } else {
                                              visible.passwordVisible = true;
                                            }

                                            visible.update(['visiblity']);
                                          },
                                          icon: Icon(
                                            visible.passwordVisible == true
                                                ? Icons.remove_red_eye_rounded
                                                : Icons.remove_red_eye_outlined,
                                            color: Colors.white,
                                            size: 5.w,
                                          ))),
                                );
                              }),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            logInDoctor(context);
                          },
                          child: GetBuilder<SignController>(
                            init: SignController(),
                            id: 'loading',
                            builder: (loading) {
                              return loading.isLoading!
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: kWhite,
                                      ),
                                    )
                                  : const Text(
                                      'Login',
                                      style: TextStyle(
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
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'OR',
                            style: TextStyle(color: kWhite),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const OtpAuthScreen()));
                              },
                              child: const Text(
                                "Login with phone",
                                style: TextStyle(color: kWhite),
                              )),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(color: kWhite),
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SignUpScreen()));
                                },
                                child: const Text(
                                  'Register here',
                                  style: TextStyle(
                                      color: kWhite,
                                      decoration: TextDecoration.underline,
                                      decorationColor: kWhite,
                                      decorationStyle:
                                          TextDecorationStyle.solid,
                                      decorationThickness: 1.5),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PageStateController extends GetxController {
  bool passwordVisible = true;
}
