import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:busmate/views/screens/login_screen.dart';

import '../widgets/input_decoration.dart';

enum Role { parent, teacher, manager }

String roleToString(Role role) {
  switch (role) {
    case Role.parent:
      return 'PARENT';
    case Role.teacher:
      return 'TEACHER';
    case Role.manager:
      return 'MANAGER';
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
  Role role = Role.parent;

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
                SizedBox(height: 10.h),
                Image.asset("assets/images/logo_fpt_uni.png", height: 50.h),
                SizedBox(height: 10.h),
                Text(
                  "Bus Mate",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      shadows: [
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 7.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ]),
                ),
                SizedBox(height: 20.h),
                Text(
                  "WELCOME TO ATTENDANCE APPLICATION",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30.h),
                // Text("Vui lòng cho chúng tôi biết bạn là :"),
                // SizedBox(height: 10.h),
                /*
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.grey.withOpacity(0.4), // Màu của đổ bóng
                          spreadRadius: 5, // Bán kính màu sắc
                          blurRadius: 7, // Độ mờ
                          offset: Offset(-1,
                              3), // Độ dịch chuyển đổ bóng theo chiều ngang và dọc
                        ),
                      ],
                    ),
                    child: TextFormField(
                        textInputAction: TextInputAction.next,
                        autofillHints: [AutofillHints.username],
                        //      controller: _inputUsernameTextController,
                        //       onChanged: (value) =>
                        //           Momentum.controller<LoginController>(context)
                        //               .recordUsername(value),
                        //       validator: (value) =>
                        //           Momentum.controller<LoginController>(context)
                        //               .validateUsernameString(value),
                        decoration: BoxedInputDecoration(
                            displayHintText: "Tên người dùng...",
                            displayPrefixIcon: Icon(
                              Icons.person_outline,
                              color: Theme.of(context).primaryColor,
                            ),
                            filledColor: Theme.of(context)
                                .colorScheme
                                .primaryContainer)),
                  ),
                ),
                SizedBox(height: 25.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.grey.withOpacity(0.4), // Màu của đổ bóng
                          spreadRadius: 5, // Bán kính màu sắc
                          blurRadius: 7, // Độ mờ
                          offset: Offset(-1,
                              3), // Độ dịch chuyển đổ bóng theo chiều ngang và dọc
                        ),
                      ],
                    ),
                    child: TextFormField(
                      // obscureText: _isHidePassword,
                      // textInputAction: TextInputAction.done,
                      //
                      // onChanged: (value) =>
                      //     Momentum.controller<LoginController>(context)
                      //         .recordPassword(hashPassword(value)),
                      // onChanged: (value) =>
                      //     Momentum.controller<LoginController>(context)
                      //         .recordPassword(value),
                      // validator: (value) =>
                      //     Momentum.controller<LoginController>(context)
                      //         .validatePasswordString(value),
                      decoration: BoxedInputDecoration(
                        displayPrefixIcon: InkWell(
                          onTap: () {
                            // setState(() {
                            //   _isHidePassword = !_isHidePassword;
                            // });
                          },
                          child: Icon(
                            Icons.lock_outline,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        filledColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        displayHintText: "Mật khẩu...",
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                 */
                InkWell(
                  child: Material(
                      color: Theme.of(context).primaryColor,
                      elevation: 5,
                      shadowColor: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                      child: Card(
                        margin: EdgeInsets.all(0),
                        color: role == Role.teacher
                            ? Theme.of(context).primaryColor
                            : Color(0xFFCEE5ED),
                        elevation: 0,
                        child: Container(
                          width: 1.sw * 1 / 3,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 8),
                          child: Center(
                            child: IntrinsicWidth(
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/icons/teacher.png",
                                    width: 40,
                                    height: 40,
                                  ),
                                  const SizedBox(width: 5),
                                  Text("Teacher")
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
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
                  child: Material(
                      color: Theme.of(context).primaryColor,
                      elevation: 5,
                      shadowColor: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                      child: Card(
                        margin: EdgeInsets.all(0),
                        color: role == Role.parent
                            ? Theme.of(context).primaryColor
                            : Color(0xFFCEE5ED),
                        elevation: 0,
                        child: Container(
                          width: 1.sw * 1 / 3,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 8),
                          child: Center(
                            child: IntrinsicWidth(
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/icons/parents.png",
                                    width: 40,
                                    height: 40,
                                  ),
                                  const SizedBox(width: 5),
                                  Text("Parent")
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                ),
                SizedBox(height: 10.h),
                InkWell(
                  onTap: () {
                    setState(() {
                      role = Role.manager;
                    });
                  },
                  child: Material(
                      color: Theme.of(context).primaryColor,
                      elevation: 5,
                      shadowColor: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                      child: Card(
                        margin: EdgeInsets.all(0),
                        color: role == Role.manager
                            ? Theme.of(context).primaryColor
                            : Color(0xFFCEE5ED),
                        elevation: 0,
                        child: Container(
                          width: 1.sw * 1 / 3,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 8),
                          child: Center(
                            child: IntrinsicWidth(
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/icons/manager.png",
                                    width: 40,
                                    height: 40,
                                  ),
                                  const SizedBox(width: 5),
                                  Text("Manager")
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
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
                        backgroundColor: Theme.of(context).primaryColor,
                        elevation: 0),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 65.0, vertical: 15),
                      child: Text("CONTINUE",
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold)),
                    ))
                /*
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
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                        elevation: 5),
                    child: Material(
                      color: Theme.of(context).primaryColor,
                      elevation: 5,
                      shadowColor: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 80.0, vertical: 10),
                        child: Text("Xác nhận",
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold)),
                      ),
                    ))

                 */

/*
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _elevation = 1.0;
                      color = Color(0xFF947D03);
                      textColor = Colors.white;
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginScreen(
                                role: role,
                                token: widget.FCMToken ?? "",
                              )),
                    );
                  },
                  child: Material(
                      color: color,
                      elevation: _elevation,
                      shadowColor: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                      child: Card(
                        margin: EdgeInsets.all(0),
                        color: color,
                        elevation: 0,
                        child: Container(
                          width: 1.sw * 0.7,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 16),
                            child: Center(
                              child: Text("Xác nhận",
                                  style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      )),
                ),

 */
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
