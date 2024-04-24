import 'package:busmate/views/screens/info_account.dart';
import 'package:busmate/views/screens/parent_screen/bluetooth_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:momentum/momentum.dart';
import 'package:busmate/controllers/bus_controller.dart';
import 'package:busmate/controllers/student_controller.dart';
import 'package:busmate/models/login_model.dart';
import 'package:busmate/utils/global.dart';
import 'package:busmate/views/screens/parent_screen/attendance_history.dart';
import 'package:busmate/views/screens/teacher_screen/take_attendance.dart';
import 'package:busmate/views/screens/parent_screen/view_map_of_parent.dart';
import 'package:busmate/views/screens/teacher_screen/view_map_of_teacher.dart';

import '../../../controllers/login_controller.dart';
import '../../../models/user_model.dart';
import '../account_screen.dart';
import 'main_screen_parent.dart';

class HomeParent extends StatefulWidget {
  final User user;
  final String? token;

  const HomeParent({super.key, required this.user, this.token});

  @override
  State<HomeParent> createState() => _HomeParentState();
}

class _HomeParentState extends MomentumState<HomeParent> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String? FCMToken = "";

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    secureStorage.read(key: "key_FCMToken").then((value) => {
          FCMToken = value ?? "",
          Momentum.controller<LoginController>(context)
              .doSendFCMToken(FCMToken!, widget.user.userId!),
          print("gửi FCM theo diện secureStorage")
        });
  }

  @override
  Widget build(BuildContext context) {
    return MomentumBuilder(
        controllers: const [StudentController],
        builder: (context, state) {
          final stuController = Momentum.controller<StudentController>(context);
          if (stuController.model.studentId == "") {
            stuController.getStudentByParentId(widget.user.userId ?? "");
            // setState(() {
            //   stuController.model.update(isGetStudentByParent: true);
            // }
            //);
          }

          List<Widget> _widgetOptions = <Widget>[
            MainScreenParent(user: widget.user, student: stuController.model),
            ViewMapOfParent(user: widget.user, student: stuController.model),
            AttendanceHistory(
                user: widget.user, studentId: stuController.model.studentId),
            // InfoAccount(
            //   user: widget.user,
            // ),
            BluetoothScan(stuId: stuController.model.studentId),
            AccountScreen(
                user: widget.user, stuId: stuController.model.studentId)
          ];
          return PopScope(
            canPop: false,
            child: Scaffold(
              body: Center(
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
              bottomNavigationBar: BottomNavigationBar(
                // backgroundColor: Color(0xFF58952D),

                type: BottomNavigationBarType.fixed,
                elevation: 0,
                backgroundColor: Colors.transparent,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_filled),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.location_on),
                    label: 'Tracking',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.border_color),
                    label: 'Attendance',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.bluetooth),
                    label: 'Tag',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Account',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedFontSize: 16,
                unselectedFontSize: 12,
                selectedItemColor: Color(0xFFECAB33),
                onTap: _onItemTapped,
              ),
            ),
          );
        });
  }
}
