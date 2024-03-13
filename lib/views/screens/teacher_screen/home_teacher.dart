import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:momentum/momentum.dart';
import 'package:school_bus_attendance_test/controllers/bus_controller.dart';
import 'package:school_bus_attendance_test/models/login_model.dart';
import 'package:school_bus_attendance_test/views/screens/teacher_screen/infor_teacher.dart';
import 'package:school_bus_attendance_test/views/screens/teacher_screen/register_student.dart';
import 'package:school_bus_attendance_test/views/screens/teacher_screen/student_data.dart';
import 'package:school_bus_attendance_test/views/screens/parent_screen/view_map_of_parent.dart';
import 'package:school_bus_attendance_test/views/screens/teacher_screen/view_map_of_teacher.dart';

import '../../../models/user_model.dart';

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
            ViewStudentData(
                user: widget.user, busId: busController.model.busId),
            RegisterStudent(
                user: widget.user, busId: busController.model.busId),
            // ViewMapOfTeacher(
            //   user: widget.user!,
            //   busId: busController.model.busId ?? 0,
            // ),
            InforTeacher(
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
            bottomNavigationBar: Container(
              clipBehavior: Clip.antiAlias,
              height: kBottomNavigationBarHeight + 14,
              margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(40.r),
              ),
              //   boxShadow: const [
              //     BoxShadow(
              //         color: Color(0xFF58952D),
              //         blurRadius: 20,
              //         offset: Offset(0, -2)),
              //   ],
              // ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                elevation: 0,
                backgroundColor: Colors.transparent,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.border_color),
                    label: 'Attendance',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_add),
                    label: 'Register',
                  ),
                  // BottomNavigationBarItem(
                  //   icon: Icon(Icons.location_on),
                  //   label: 'Tracking',
                  // ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Account',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedFontSize: 16,
                unselectedFontSize: 12,
                selectedItemColor: Color(0xFF58952D),
                onTap: _onItemTapped,
              ),
            ),
          );
        });
  }
}
