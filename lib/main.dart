import 'package:deaf_mute_system/manager/widgets/charts.dart';
import 'package:deaf_mute_system/report/report_chart.dart';
import 'package:deaf_mute_system/report/send_report.dart';
import 'package:deaf_mute_system/report/show_report.dart';

import 'authentication/login_screen.dart';
import 'clerk_screen.dart';
import 'controller/sos_screen.dart';
import 'ministries/civil_protection.dart';
import 'ministries/health.dart';
import 'ministries/interior.dart';
import 'ministries/nas.dart';
import 'authentication/signup_screen.dart';
import 'feedback.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'authentication/firebase_options.dart';
import 'splash_screen.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Safe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      // initialRoute: InteriorScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        SignupScreen.routeName: (context) => const SignupScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        SOSScreen.routeName: (context) => const SOSScreen(),
        HealthScreen.routeName: (context) => const HealthScreen(),
        InteriorScreen.routeName: (context) => InteriorScreen(),
        CivilProtection.routeName: (context) => CivilProtection(),
        NasScreen.routeName: (context) => NasScreen(),
        ClerkScreen.routeName: (context) => ClerkScreen(),
        FeedbackScreen.routeName: (context) => const FeedbackScreen(),
      },
      home: const ReportScreen(),
    );
  }
}
