import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:momentum/momentum.dart';
import 'package:busmate/controllers/student_register_RFID_controller.dart';
import 'package:busmate/views/screens/teacher_screen/register_RFID.dart';
import 'package:busmate/views/screens/teacher_screen/register_fingerprint.dart';

import '../../../models/student_register_RFID_model.dart';
import '../../../models/user_model.dart';
import '../detail_student.dart';

class RegisterStudent extends StatelessWidget {
  final User? user;
  final int? busId;

  const RegisterStudent({super.key, this.user, this.busId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Stack(
        children: [
          Container(
            width: 1.sw,
            height: 1.sh,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/ombre_blue.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.roleId == 3 ? "Hello, teacher" : "Hello, manager",
                    style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                  ),
                  Text(
                    user?.fullName ?? "",
                    style: TextStyle(
                        fontSize: 20.sp,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: CircleAvatar(
                    radius: 30.0,
                    backgroundImage: AssetImage("assets/image_avt/avt.jpg"),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ],
              bottom: TabBar(
                indicatorColor: Theme.of(context).colorScheme.secondary,
                labelColor: Theme.of(context).colorScheme.secondary,
                tabs: [
                  Tab(text: "Register RFID/NFC"),
                  Tab(text: "FINGERPRINT"),
                ],
              ),
              automaticallyImplyLeading: false,
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
          )
        ],
      ),
    );
  }
}
