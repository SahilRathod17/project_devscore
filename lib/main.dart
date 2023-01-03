// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_devscore/providers/userdata_provider.dart';
import 'package:project_devscore/responsive/mobile_screen_layout.dart';
import 'package:project_devscore/responsive/responsive_layout.dart';
import 'package:project_devscore/responsive/web_screen_layout.dart';
import 'package:project_devscore/screens/splash_screen.dart';
import 'package:project_devscore/utils/colors.dart';
import 'package:provider/provider.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserDataProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DevsCore',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Text('Something went wrong');
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }

            return SplashScreen();
          },
        ),
      ),
    );
  }
}



// for storing user login data firebase provide us three methods 
// 1. FirebaseAuth.instance.idTokenChanges() 
// 2. FirebaseAuth.instance.userChanges()
// 3. FirebaseAuth.instance.authStateChanges() only sign in / sign out