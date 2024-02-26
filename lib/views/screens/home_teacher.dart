import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';
import 'package:school_bus_attendance_test/controllers/bus_controller.dart';
import 'package:school_bus_attendance_test/models/login_model.dart';
import 'package:school_bus_attendance_test/views/screens/student_data.dart';
import 'package:school_bus_attendance_test/views/screens/view_map_of_parent.dart';
import 'package:school_bus_attendance_test/views/screens/view_map_of_teacher.dart';

import '../../models/user_model.dart';

class HomeTeacher extends StatefulWidget {
  final User? user;

  const HomeTeacher({super.key, this.user});

  @override
  State<HomeTeacher> createState() => _HomeTeacherState();
}

class _HomeTeacherState extends MomentumState<HomeTeacher> {
  @override
  Widget build(BuildContext context) {
    return MomentumBuilder(
        controllers: const [BusController],
        builder: (context, state) {
          final busController = Momentum.controller<BusController>(context);
          if (!busController.model.isCalled!) {
            busController.getBusId(widget.user?.userId ?? "");
            setState(() {
              busController.model.update(isCalled: true);
            });
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
                            text: "Điểm danh"),
                        Tab(
                            icon: Image.asset("assets/icons/icon_map.png",
                                height: 35),
                            text: "Tracking"),
                      ],
                    ),
                    title:
                        // Text(
                        //     'Welcome to BusMate, teacher ${widget.user?.fullName}!'),
                        Text("busId of teacher: " +
                            busController.model.busId.toString())),
                body: TabBarView(
                  children: [
                    ViewStudentData(
                        user: widget.user, busId: busController.model.busId),
                    ViewMapOfTeacher(
                      user: widget.user!,
                      busId: busController.model.busId ?? 0,
                    )
                  ],
                ),
              ));
        });
  }
}
