import 'package:busmate/views/screens/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:momentum/momentum.dart';
import 'package:busmate/controllers/attendance_controller.dart';
import 'package:busmate/controllers/bus_controller.dart';
import 'package:busmate/controllers/login_controller.dart';
import 'package:busmate/controllers/register_controller.dart';
import 'package:busmate/controllers/student_controller.dart';
import 'package:busmate/controllers/student_list_controller.dart';
import 'package:busmate/controllers/student_on_bus_list_controller.dart';
import 'package:busmate/firebase/firebase_messaging_setting.dart';
import 'package:busmate/firebase/local_notification.dart';
import 'package:busmate/models/user_model.dart';
import 'package:busmate/services/auth_service.dart';
import 'package:busmate/services/bus_service.dart';
import 'package:busmate/services/student_service.dart';
import 'package:busmate/utils/global.dart';
import 'package:busmate/views/screens/choose_role.dart';
import 'package:busmate/views/screens/login_screen.dart';
import 'package:busmate/views/screens/manager_screen/home_manager.dart';
import 'package:busmate/views/screens/parent_screen/home_parent.dart';
import 'package:busmate/views/screens/teacher_screen/home_teacher.dart';
import 'package:busmate/views/screens/teacher_screen/infor_teacher.dart';
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
      builder: (context, child) => MaterialApp(
              home: Scaffold(
            body: Image.asset("assets/images/background_check1.png"),
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
  String? fullname = "";
  String? phone = "";
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
    setUpFCMToken();
    isAndroidPermissionGranted(flutterLocalNotificationPlugin);
    requestNotificationPermission(flutterLocalNotificationPlugin);
  }

  void setUpFCMToken() async {
    FCMToken = await setupInteractedMessage();
    setState(() {
      FCMTokenLoaded = true;
      secureStorage.write(key: "key_FCMToken", value: FCMToken);
    });
  }

  void isLoginFun() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    username = await sp.getString('key_username') ?? "testdemo";
    print("username ${username}");
    roleId = await sp.getString('key_roleId') ?? "";
    print("roleId ${roleId}");
    userId = await sp.getString('key_userId') ?? "";
    print("userId ${userId}");
    fullname = await sp.getString('key_fullname') ?? "";
    print("fullname ${fullname}");
    phone = await sp.getString('key_phone') ?? "";
    print("phone ${phone}");
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
          user: User(
              userName: username,
              roleId: 1,
              userId: userId,
              phone: phone,
              fullName: fullname),
          token: FCMToken);
    } else if (roleId == 3) {
      return HomeTeacher(
          user: User(
              userName: username,
              roleId: 3,
              userId: userId,
              phone: phone,
              fullName: fullname));
    } else if (roleId == 4) {
      return HomeManager(
          user: User(
              userName: username,
              roleId: 4,
              userId: userId,
              phone: phone,
              fullName: fullname));
    }
    return const Scaffold(
      body: Center(
        child: Text("Lỗi không tìm thấy trang chủ"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        // home: isLogin!
        //     ? NavigatorHomeScreen(int.tryParse(roleId!))
        //     : FCMTokenLoaded
        //         ? ChoosingRole(FCMToken: FCMToken)
        //         : LoadingScreen()
        home: WelcomeScreen());
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
