import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:momentum/momentum.dart';
import 'package:school_bus_attendance_test/controllers/student_register_RFID_controller.dart';
import 'package:school_bus_attendance_test/views/screens/teacher_screen/register_RFID.dart';
import 'package:school_bus_attendance_test/views/screens/teacher_screen/register_fingerprint.dart';

import '../../../models/student_register_RFID_model.dart';
import '../../../models/user_model.dart';
import '../detail_student.dart';

class RegisterStudent extends StatelessWidget {
  final User? user;
  final int? busId;

  const RegisterStudent({super.key, this.user, this.busId});

  @override
  Widget build(BuildContext context) {
    print("Giá trị của busId trong màn RegisterStudent  $busId");
    if (busId != 0) {
      print("busid != 0");

      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Center(child: Text("Đăng kí cho học sinh mới")),
            bottom: const TabBar(
              tabs: [
                Tab(text: "Đăng kí RFID"),
                Tab(text: "Đăng kí vân tay"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              RegisterStudentByRFID(
                busId: busId,
                user: user,
              ),
              RegisterStudentByFingerprint(busId: busId, user: user)
            ],
          ),
        ),
      );
    } else {
      return const Center(child: Text("Không có gì hết"));
    }
  }
}
