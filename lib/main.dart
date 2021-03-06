import 'package:doc_side_appoinment/constant_value/constant_colors.dart';
import 'package:doc_side_appoinment/resources/push_notification.dart';
import 'package:doc_side_appoinment/screens/authentication_screens/log_in.dart';
import 'package:doc_side_appoinment/screens/main_screen_home/main_home_screen.dart';
import 'package:doc_side_appoinment/splash_screen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

final notifyC = NotificationControl();
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    notifyC.requestPermission();
    notifyC.loadFCM();
    notifyC.listenFCM();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: ((context, orientation, deviceType) => GetMaterialApp(
              navigatorKey: navigatorKey,
              title: 'Flutter Demo',
              theme: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                scaffoldBackgroundColor: kWhite,
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.transparent,
                ),
                primarySwatch: Colors.blue,
              ),
              home: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SplashScreen();
                  }

                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      return const MainHomeScreen();
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('${snapshot.error}'),
                      );
                    } else {
                      return LogInScreen();
                    }
                  }

                  return LogInScreen();
                },
              ),
              debugShowCheckedModeBanner: false,
            )));
  }
}
