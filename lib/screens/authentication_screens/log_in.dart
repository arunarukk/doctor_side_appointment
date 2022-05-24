import 'package:doc_side_appoinment/constant_value/constant_colors.dart';
import 'package:doc_side_appoinment/get_controller/get_controller.dart';
import 'package:doc_side_appoinment/resources/auth_method.dart';
import 'package:doc_side_appoinment/screens/authentication_screens/otp_auth_screen.dart';
import 'package:doc_side_appoinment/screens/authentication_screens/sign_up.dart';
import 'package:doc_side_appoinment/screens/main_screen_home/main_home_screen.dart';
import 'package:doc_side_appoinment/utils/image_picker_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // final control = Get.put(SignController());

  void logInDoctor(BuildContext ctx) async {
    
      signControl.loading(true);
      signControl.update(['checkbox']);

    String result = await AuthMethods().logInUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (result == 'Success') {
      Navigator.of(ctx).pushReplacement(
          MaterialPageRoute(builder: (ctx) => MainHomeScreen()));
      showSnackBar(result, kGreen, ctx);
      print("----------------$result");
    } else {
      showSnackBar(result, kRed, ctx);
    }
    signControl.loading(false);
     signControl.update(['checkbox']);
  }

  @override
  Widget build(BuildContext context) {
    signControl.loading(false);
    final size = MediaQuery.of(context).size.height;
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
                height: 450,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: kBlack,
                      blurRadius: 8.0,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(200),
                      bottomRight: Radius.circular(200)),
                  // gradient: LinearGradient(
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  //   colors: [
                  //     Color.fromARGB(255, 165, 17, 42),
                  //     Color.fromARGB(255, 16, 211, 58)
                  //   ],
                  // ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 100.0, bottom: 60),
                    child: SizedBox(
                      child: Image.asset(
                        'assets/login_screen.png',
                        width: size * .36,
                      ),
                    ),
                  ),
                  // Text(
                  //   'Log-In',
                  //   style: TextStyle(
                  //       fontSize: 20,
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.bold),
                  // ),
                  Form(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 50.0, right: 50, top: 10),
                          child: TextFormField(
                            controller: _emailController,
                            style: TextStyle(color: kWhite),
                            decoration: InputDecoration(
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
                          padding: const EdgeInsets.only(
                              left: 50.0, right: 50, top: 20, bottom: 30),
                          child: GetBuilder<PageController>(
                              init: PageController(),
                              id: 'visiblity',
                              builder: (visible) {
                                return TextFormField(
                                  controller: _passwordController,
                                  obscureText: visible.passwordVisible,
                                  style: TextStyle(color: kWhite),
                                  decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      //filled: true,
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      labelText: 'Password',
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      prefixIcon: Padding(
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
                                            size: 18,
                                          ))),
                                );
                              }),
                        ),
                        // InkWell(
                        //   onTap: () {},
                        //   child: Container(
                        //       width: 200,
                        //       height: 50,
                        //       decoration: BoxDecoration(
                        //           gradient: LinearGradient(
                        //               begin: Alignment.topLeft,
                        //               end: Alignment.bottomRight,
                        //               colors: [
                        //                 Color.fromARGB(255, 212, 165, 33),
                        //                 Color.fromARGB(255, 212, 165, 33)
                        //               ]),
                        //           borderRadius: BorderRadius.circular(50)),
                        //       child: Center(
                        //           child: Text(
                        //         'Login',
                        //         style: TextStyle(
                        //             fontSize: 18, color: Colors.white),
                        //       ))),
                        // ),
                        ElevatedButton(
                          onPressed: () {
                            logInDoctor(context);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => MainHomeScreen()));
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
                                  : Text(
                                      'Login',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    );
                            },
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 241, 187, 38),
                              fixedSize: const Size(300, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
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
                                        builder: (context) => OtpAuthScreen()));
                              },
                              child: Text(
                                "Login with phone",
                                style: TextStyle(color: kWhite),
                              )),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
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
                                child: Text(
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

class PageController extends GetxController {
  bool passwordVisible = true;
}
