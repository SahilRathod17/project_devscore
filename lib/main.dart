// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_devscore/screens/login_screen.dart';
import 'package:project_devscore/screens/splash_screen.dart';
import 'package:project_devscore/utils/colors.dart';

Future<void> main() async {
  //this make sure that flutter widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyBo7pqF6yHkVQcZr8DTj_dvHRYybNOb8i4',
        appId: '1:631486098582:web:4e5aebb50be9d7e2c0e6b7',
        messagingSenderId: '631486098582',
        projectId: 'devscore-451ea',
        storageBucket: 'devscore-451ea.appspot.com',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DevsCore',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      // home: const ResponsiveLayout(
      //   mobileScreenLayout: MobileScreenLayout(),
      //   webScreenLayout: WebScreenLayout(),
      // ),
      home: SplashScreen(),
    );
  }
}
