import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';
import 'package:school_bus_attendance_test/controllers/bus_controller.dart';
import 'package:school_bus_attendance_test/controllers/student_controller.dart';
import 'package:school_bus_attendance_test/models/login_model.dart';
import 'package:school_bus_attendance_test/views/screens/attendance_history.dart';
import 'package:school_bus_attendance_test/views/screens/student_data.dart';
import 'package:school_bus_attendance_test/views/screens/view_map_of_parent.dart';
import 'package:school_bus_attendance_test/views/screens/view_map_of_teacher.dart';

import '../../controllers/login_controller.dart';
import '../../models/user_model.dart';

class HomeParent extends StatefulWidget {
  final User user;
  final String? token;

  const HomeParent({super.key, required this.user, this.token});

  @override
  State<HomeParent> createState() => _HomeParentState();
}

class _HomeParentState extends MomentumState<HomeParent> {
  @override
  Widget build(BuildContext context) {
    if (widget.token != null) {
      print("userId${widget.user.userId}");
      Momentum.controller<LoginController>(context)
          .doSendFCMToken(widget.token!, widget.user.userId!);
    } else {
      print("không có token đou");
    }
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
          return DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                    automaticallyImplyLeading: false,
                    bottom: TabBar(
                      tabs: [
                        Tab(
                            icon: Image.asset(
                                "assets/icons/icon_attendance.png",
                                height: 35),
                            text: "Lịch sử điểm danh"),
                        Tab(
                            icon: Image.asset("assets/icons/icon_map.png",
                                height: 35),
                            text: "Tracking"),
                      ],
                    ),
                    title:
                        // Text(
                        //     'Welcome to BusMate, teacher ${widget.user?.fullName}!'),
                        Text(
                            "Welcome to BusMate, parent ${widget.user.fullName}! ")),
                body: TabBarView(
                  children: [
                    AttendanceHistory(
                        user: widget.user,
                        studentId: stuController.model.studentId),
                    ViewMapOfParent(
                      user: widget.user,
                    )
                  ],
                ),
              ));
        });
  }
}
