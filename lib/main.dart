import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:momentum/momentum.dart';
import 'package:school_bus_attendance_test/controllers/attendance_controller.dart';
import 'package:school_bus_attendance_test/controllers/bus_controller.dart';
import 'package:school_bus_attendance_test/controllers/login_controller.dart';
import 'package:school_bus_attendance_test/controllers/register_controller.dart';
import 'package:school_bus_attendance_test/controllers/student_controller.dart';
import 'package:school_bus_attendance_test/controllers/student_list_controller.dart';
import 'package:school_bus_attendance_test/controllers/student_on_bus_list_controller.dart';
import 'package:school_bus_attendance_test/firebase/firebase_messaging_setting.dart';
import 'package:school_bus_attendance_test/firebase/local_notification.dart';
import 'package:school_bus_attendance_test/services/auth_service.dart';
import 'package:school_bus_attendance_test/services/bus_service.dart';
import 'package:school_bus_attendance_test/services/student_service.dart';
import 'package:school_bus_attendance_test/views/screens/choose_role.dart';

import 'controllers/list_history_attendance_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  //local Notification setting
  await initLocalNotification();
  runApp(momentum);
}

Momentum momentum = Momentum(
  key: UniqueKey(),
  restartCallback: main,
  controllers: [
    StudentController(),
    StudentListController(),
    AttendanceController(),
    StudentOnBusListController(),
    LoginController(),
    AuthResponseController(),
    BusController(),
    RegisterController(),
    ListHistoryAttendanceController()
  ],
  services: [StudentServices(), AuthServices(), BusServices()],
  appLoader: ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => const MaterialApp(
              home: Scaffold(
            body: Text("này là Splash screen"),
          ))),
  child: const MyApp(),
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? FCMToken = "";
  bool FCMTokenLoaded = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FCMToken = await setupInteractedMessage();
      setState(() {
        FCMTokenLoaded = true;
      });
    });
    isAndroidPermissionGranted(flutterLocalNotificationPlugin);
    requestNotificationPermission(flutterLocalNotificationPlugin);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: FCMTokenLoaded
            ? ChoosingRole(FCMToken: FCMToken)
            : LoadingScreen());
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
