import 'dart:async';

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
import 'package:school_bus_attendance_test/models/user_model.dart';
import 'package:school_bus_attendance_test/services/auth_service.dart';
import 'package:school_bus_attendance_test/services/bus_service.dart';
import 'package:school_bus_attendance_test/services/student_service.dart';
import 'package:school_bus_attendance_test/utils/global.dart';
import 'package:school_bus_attendance_test/views/screens/choose_role.dart';
import 'package:school_bus_attendance_test/views/screens/login_screen.dart';
import 'package:school_bus_attendance_test/views/screens/manager_screen/home_manager.dart';
import 'package:school_bus_attendance_test/views/screens/parent_screen/home_parent.dart';
import 'package:school_bus_attendance_test/views/screens/teacher_screen/home_teacher.dart';
import 'package:school_bus_attendance_test/views/screens/teacher_screen/infor_teacher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/list_history_attendance_controller.dart';
import 'controllers/student_register_RFID_controller.dart';
import 'controllers/student_register_fingerprint_controller.dart';
import 'generated/color_schemes.g.dart';

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
    ListHistoryAttendanceController(),
    StudentRegisterRFIDListController(),
    StudentRegisterFingerprintListController()
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
  String username = "testdemo";
  String? roleId = "";
  String? userId = "";
  bool? isLogin = false;

  @override
  void initState() {
    super.initState();
    // secureStorage.read(key: "key_username").then((value) =>
    //     {username = value ?? "testdemo", print("username: " + username)});
    // secureStorage.read(key: "key_roleId").then((value) =>
    //     {roleId = value ?? "", print("roleId: ${roleId ?? " null"}")});
    // secureStorage.read(key: "key_userId").then((value) =>
    //     {userId = value ?? "", print("userId: ${userId ?? " null"}")});
    isLoginFun();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FCMToken = await setupInteractedMessage();
      setState(() {
        FCMTokenLoaded = true;
        secureStorage.write(key: "key_FCMToken", value: FCMToken);
      });
    });
    isAndroidPermissionGranted(flutterLocalNotificationPlugin);
    requestNotificationPermission(flutterLocalNotificationPlugin);
  }

  void isLoginFun() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    username = await sp.getString('key_username') ?? "testdemo";
    print("username ${username}");
    roleId = await sp.getString('key_roleId') ?? "";
    print("roleId ${roleId}");
    userId = await sp.getString('key_userId') ?? "";
    print("userId ${userId}");
    isLogin = sp.getBool('isLogin') ?? false;
    print(isLogin.toString());
    if (isLogin!) {
      print("isLogin trueee");
    } else {
      print("isLogin falseeee");
    }
  }

  Widget NavigatorHomeScreen(int? roleId) {
    if (roleId == 1) {
      return HomeParent(
          user: User(userName: username, roleId: 1, userId: userId),
          token: FCMToken);
    } else if (roleId == 3) {
      return HomeTeacher(
          user: User(userName: username, roleId: 3, userId: userId));
    } else if (roleId == 4) {
      return HomeManager(
          user: User(userName: username, roleId: 4, userId: userId));
    }
    return Center(
      child: Text("aaaaaaaaa"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        home: isLogin!
            ? NavigatorHomeScreen(int.tryParse(roleId!))
            : FCMTokenLoaded
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
