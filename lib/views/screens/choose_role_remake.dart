import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../widgets/input_decoration.dart';

class ChooseRoleRemake extends StatefulWidget {
  const ChooseRoleRemake({super.key});

  @override
  State<ChooseRoleRemake> createState() => _ChooseRoleRemakeState();
}

class _ChooseRoleRemakeState extends State<ChooseRoleRemake> {
  bool _isHidePassword = true;
  final _loginFormKey = GlobalKey<FormState>();

  String hashPassword(String password) {
    // Sử dụng thuật toán mã hóa md5
    var bytes = utf8.encode(password); // Chuyển đổi mật khẩu sang dạng byte
    var digest = md5.convert(bytes); // Mã hóa mật khẩu
    return digest.toString(); // Trả về chuỗi mật khẩu đã được mã hóa
  }

  void getInputUsernameSaved() async {
    String? name = await storage.read(key: _keyUsername);
    setState(() {
      _inputUsernameTextController.text = name!;
    });
  }

  var _inputUsernameTextController = TextEditingController();
  final storage = new FlutterSecureStorage();
  final _keyUsername = "key_username";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: 1.sw,
            height: 1.sh,
            child:
                Image.asset("assets/images/ombre_blue.jpg", fit: BoxFit.fill),
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  const Text(
                    "BusMate",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFA82C),
                        shadows: [
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 7.0,
                            color: Colors.black,
                          ),
                        ]),
                  ),
                  SizedBox(height: 30.h),
                  SingleChildScrollView(
                    child: Form(
                      // autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: _loginFormKey,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: AutofillGroup(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 40.h),
                              SizedBox(
                                height: 20.h,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        offset: Offset(0, 3),
                                        blurRadius: 5,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: TextFormField(
                                      textInputAction: TextInputAction.next,
                                      autofillHints: [AutofillHints.username],
                                      controller: _inputUsernameTextController,
                                      // onChanged: (value) =>
                                      //     Momentum.controller<LoginController>(
                                      //         context)
                                      //         .recordUsername(value),
                                      // validator: (value) =>
                                      //     Momentum.controller<LoginController>(
                                      //         context)
                                      //         .validateUsernameString(value),
                                      decoration: BoxedInputDecoration(
                                        displayHintText: "Username...",
                                        displayPrefixIcon: Icon(
                                          Icons.person_outline,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        filledColor: Colors.white,
                                      )),
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        offset: Offset(0, 3),
                                        blurRadius: 5,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: TextFormField(
                                    obscureText: _isHidePassword,
                                    textInputAction: TextInputAction.done,

                                    // onChanged: (value) =>
                                    // Momentum.controller<LoginController>(
                                    //     context)
                                    //     .recordPassword(hashPassword(value)),
                                    // onChanged: (value) =>
                                    //     Momentum.controller<LoginController>(context)
                                    //         .recordPassword(value),
                                    // validator: (value) =>
                                    //     Momentum.controller<LoginController>(
                                    //         context)
                                    //         .validatePasswordString(value),
                                    decoration: BoxedInputDecoration(
                                      displayPrefixIcon: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _isHidePassword = !_isHidePassword;
                                          });
                                        },
                                        child: Icon(
                                          Icons.lock_outline,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      filledColor: Colors.white,
                                      displayHintText: "Password...",
                                    ),
                                  ),
                                ),
                              ),
                              // Visibility(
                              //     visible: responseModel.authResponseMessage != "",
                              //     child: SizedBox(height: 15.h)),
                              // Visibility(
                              //     visible: responseModel.authResponseMessage != "",
                              //     child: Text(
                              //       responseModel.authResponseMessage!,
                              //       style: Theme.of(context)
                              //           .textTheme
                              //           .bodyMedium
                              //           ?.copyWith(color: Colors.red),
                              //     )),
                              SizedBox(height: 30.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: SizedBox(
                                    width: 1.sw,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.3),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: FilledButton(
                                          onPressed: () async {
                                            if (_loginFormKey.currentState!
                                                .validate()) {
                                              await storage.write(
                                                  key: _keyUsername,
                                                  value:
                                                      _inputUsernameTextController
                                                          .text);
                                              // Momentum.controller<LoginController>(
                                              //     context)
                                              //     .doLogin(model);
                                            } else {
                                              // responseModel.controller
                                              //     .setAuthErrorMessage("");
                                            }
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 13.h),
                                            child: Text(
                                              "Login".toUpperCase(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                      color: Colors.white),
                                            ),
                                          )),
                                    )),
                              ),
                              SizedBox(height: 10.h),
                              Visibility(
                                //visible: widget.role == Role.parent,
                                child: SizedBox(
                                    width: 1.sw,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Don't have an account? "),
                                        TextButton(
                                            onPressed: () {
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           RegisterScreen(
                                              //             token: widget.token,
                                              //           )),
                                              // );
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 16),
                                              child: Text(
                                                "Sign up",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    decoration: TextDecoration
                                                        .underline),
                                              ),
                                            )),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
/*
//Style chia trang chọn role -> đăng nhập
Scaffold(
        body: Stack(
      children: [
        Container(
          width: 1.sw,
          height: 1.sh,
          child:
              Image.asset("assets/images/ombre_blue_car.jpg", fit: BoxFit.fill),
        ),
        Positioned(
            top: 1.sh * 0.3,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  Text("Choose role you want to login: ", style: TextStyle()),
                  SizedBox(height: 20.h),
                  InkWell(
                    child: Material(
                        color: Theme.of(context).primaryColor,
                        elevation: 5,
                        shadowColor: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        child: Card(
                          margin: EdgeInsets.all(0),
                          color: Color(0xFF36A945),
                          elevation: 0,
                          child: Container(
                            width: 1.sw * 0.5,
                            height: 80,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 8),
                            child: Center(
                              child: IntrinsicWidth(
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/icons/teacher.png",
                                      width: 50,
                                      height: 50,
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      "Teacher",
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
                    onTap: () {
                      // setState(() {
                      //   role = Role.teacher;
                      // });
                    },
                  ),
                  SizedBox(height: 20.h),
                  InkWell(
                    onTap: () {
                      // setState(() {
                      //   role = Role.parent;
                      // });
                    },
                    child: Material(
                        color: Theme.of(context).primaryColor,
                        elevation: 5,
                        shadowColor: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        child: Card(
                          margin: EdgeInsets.all(0),
                          color: Colors.white,
                          elevation: 0,
                          child: Container(
                            width: 1.sw * 0.5,
                            height: 80,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 8),
                            child: Center(
                              child: IntrinsicWidth(
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/icons/parents.png",
                                      width: 50,
                                      height: 50,
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      "Parent",
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
                  ),
                  SizedBox(height: 20.h),
                  InkWell(
                    onTap: () {
                      // setState(() {
                      //   role = Role.manager;
                      // });
                    },
                    child: Material(
                        color: Theme.of(context).primaryColor,
                        elevation: 5,
                        shadowColor: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        child: Card(
                          margin: EdgeInsets.all(0),
                          color: Colors.white,
                          elevation: 0,
                          child: Container(
                            width: 1.sw * 0.5,
                            height: 80,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 8),
                            child: Center(
                              child: IntrinsicWidth(
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/icons/manager.png",
                                      width: 50,
                                      height: 50,
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      "Manager",
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ))
      ],
    ));
 */
