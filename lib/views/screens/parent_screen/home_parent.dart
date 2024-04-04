import 'package:busmate/views/screens/info_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:momentum/momentum.dart';
import 'package:busmate/controllers/bus_controller.dart';
import 'package:busmate/controllers/student_controller.dart';
import 'package:busmate/models/login_model.dart';
import 'package:busmate/utils/global.dart';
import 'package:busmate/views/screens/parent_screen/attendance_history.dart';
import 'package:busmate/views/screens/teacher_screen/student_data.dart';
import 'package:busmate/views/screens/parent_screen/view_map_of_parent.dart';
import 'package:busmate/views/screens/teacher_screen/view_map_of_teacher.dart';

import '../../../controllers/login_controller.dart';
import '../../../models/user_model.dart';
import '../teacher_screen/infor_teacher.dart';
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
    if (widget.token != null) {
      print("userId${widget.user.userId}");
      Momentum.controller<LoginController>(context)
          .doSendFCMToken(widget.token!, widget.user.userId!);
      print("gửi FCM theo diện token navigator");
    } else {
      print("k có FCM");
    }
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
            MainScreenParent(),
            AttendanceHistory(
                user: widget.user, studentId: stuController.model.studentId),
            ViewMapOfParent(
              user: widget.user,
            ),
            InfoAccount(
              user: widget.user,
            ),
          ];
          return Scaffold(
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
                  icon: Icon(Icons.border_color),
                  label: 'Attendance',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.location_on),
                  label: 'Tracking',
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
          );
        });
  }
}
