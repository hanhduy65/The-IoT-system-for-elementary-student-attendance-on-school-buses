import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_bus_attendance_test/views/screens/login_screen.dart';

enum Role { parent, teacher, manager }

String roleToString(Role role) {
  switch (role) {
    case Role.parent:
      return 'Phụ huynh';
    case Role.teacher:
      return 'Giáo viên';
    case Role.manager:
      return 'Quản lí';
    default:
      return '';
  }
}

class ChoosingRole extends StatefulWidget {
  final String? FCMToken;
  ChoosingRole({super.key, this.FCMToken});

  @override
  State<ChoosingRole> createState() => _ChoosingRoleState();
}

class _ChoosingRoleState extends State<ChoosingRole> {
  Role role = Role.teacher;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1.sh * 2 / 3,
        color: Color(0xFF87CCED),
        child: Center(
          child: IntrinsicHeight(
            child: Column(
              children: [
                const Text(
                  "Bus Mate",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFECAB33)),
                ),
                SizedBox(height: 20.h),
                const Text(
                  "CHÀO MỪNG BẠN",
                  style: TextStyle(
                      color: Color(0xFF58952D),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.h),
                Text("vui lòng cho chúng tôi biết bạn là: "),
                SizedBox(height: 20.h),
                InkWell(
                  child: Card(
                    color: role == Role.teacher
                        ? Color(0xFFECAB33)
                        : Color(0xFFCEE5ED),
                    elevation: 5,
                    child: IntrinsicWidth(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/icons/teacher.png",
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(width: 5),
                            Text("Giáo viên")
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => const ViewStudentData()),
                    // );
                    setState(() {
                      role = Role.teacher;
                    });
                  },
                ),
                SizedBox(height: 10.h),
                InkWell(
                  onTap: () {
                    setState(() {
                      role = Role.parent;
                    });
                  },
                  child: Card(
                    color: role == Role.parent
                        ? Color(0xFFECAB33)
                        : Color(0xFFCEE5ED),
                    elevation: 5,
                    child: IntrinsicWidth(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/icons/parents.png",
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(width: 5),
                            Text("Phụ huynh")
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                InkWell(
                  onTap: () {
                    setState(() {
                      role = Role.manager;
                    });
                  },
                  child: Card(
                    color:
                        role == Role.manager ? Colors.white : Color(0xFFCEE5ED),
                    elevation: 5,
                    child: IntrinsicWidth(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/icons/manager.png",
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(width: 5),
                            Text("Quản lí")
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginScreen(
                                  role: role,
                                  token: widget.FCMToken ?? "",
                                )),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Color(0xFFECAB33),
                        elevation: 0),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 80.0, vertical: 10),
                      child: Text("Xác nhận",
                          style: TextStyle(
                              color: Color(0xFF58952D),
                              fontWeight: FontWeight.bold)),
                    ))
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
          width: 1.sw,
          height: 1.sh * 1 / 3,
          child: Image.asset(
            "assets/images/background.jpg",
            fit: BoxFit.fill,
          )),
    );
  }
}
