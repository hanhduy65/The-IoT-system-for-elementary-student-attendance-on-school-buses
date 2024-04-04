import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:momentum/momentum.dart';
import 'package:busmate/controllers/bus_controller.dart';
import 'package:busmate/models/login_model.dart';
import 'package:busmate/views/screens/teacher_screen/infor_teacher.dart';
import 'package:busmate/views/screens/teacher_screen/main_screen_teacher.dart';
import 'package:busmate/views/screens/teacher_screen/register_student.dart';
import 'package:busmate/views/screens/teacher_screen/student_data.dart';
import 'package:busmate/views/screens/parent_screen/view_map_of_parent.dart';
import 'package:busmate/views/screens/teacher_screen/test_map.dart';
import 'package:busmate/views/screens/teacher_screen/view_map_of_teacher.dart';

import '../../../models/user_model.dart';
import '../info_account.dart';

class HomeTeacher extends StatefulWidget {
  final User? user;

  const HomeTeacher({super.key, this.user});

  @override
  State<HomeTeacher> createState() => _HomeTeacherState();
}

class _HomeTeacherState extends MomentumState<HomeTeacher> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MomentumBuilder(
        controllers: const [BusController],
        builder: (context, state) {
          final busController = Momentum.controller<BusController>(context);
          if (!busController.model.isCalled!) {
            busController.getBusId(widget.user?.userId ?? "");
            busController.model.update(isCalled: true);
          }
          List<Widget> _widgetOptions = <Widget>[
            MainScreenTeacher(),
            ViewStudentData(
                user: widget.user, busId: busController.model.busId),
            RegisterStudent(
                user: widget.user, busId: busController.model.busId),
            ViewMapOfTeacher(
              user: widget.user!,
              busId: busController.model.busId ?? 0,
            ),
            // DemoMap(),
            InfoAccount(
              user: widget.user!,
            )
          ];
          return Scaffold(
            // appBar: AppBar(
            //   automaticallyImplyLeading: false,
            //   title: const Center(child: Text('Hello, supervisor!')),
            // ),
            body: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              // backgroundColor: Colors.transparent,
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
                  icon: Icon(Icons.person_add),
                  label: 'Register',
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
              selectedFontSize: 14,
              unselectedFontSize: 10,
              selectedItemColor: Theme.of(context).primaryColor,
              onTap: _onItemTapped,
            ),
          );
        });
  }
}
