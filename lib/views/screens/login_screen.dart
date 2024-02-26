import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recaptcha_v2_compat/flutter_recaptcha_v2_compat.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:momentum/momentum.dart';
import 'package:school_bus_attendance_test/views/screens/choose_role.dart';
import 'package:school_bus_attendance_test/views/screens/home_manager.dart';
import 'package:school_bus_attendance_test/views/screens/home_parent.dart';
import 'package:school_bus_attendance_test/views/screens/home_teacher.dart';
import 'package:school_bus_attendance_test/views/screens/register_screen.dart';
import 'package:school_bus_attendance_test/views/screens/student_data.dart';
import 'package:school_bus_attendance_test/views/screens/view_map_of_parent.dart';

import '../../controllers/login_controller.dart';
import '../../events/login_events.dart';
import '../../models/login_model.dart';
import '../widgets/input_decoration.dart';

class LoginScreen extends StatefulWidget {
  final String? token;
  final Role role;

  LoginScreen({super.key, required this.role, this.token});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends MomentumState<LoginScreen> {
  bool _isHidePassword = true;
  final _loginFormKey = GlobalKey<FormState>();

  String hashPassword(String password) {
    // Sử dụng thuật toán mã hóa md5
    var bytes = utf8.encode(password); // Chuyển đổi mật khẩu sang dạng byte
    var digest = md5.convert(bytes); // Mã hóa mật khẩu
    return digest.toString(); // Trả về chuỗi mật khẩu đã được mã hóa
  }

  @override
  Widget build(BuildContext context) {
    return MomentumBuilder(
        controllers: const [LoginController, AuthResponseController],
        builder: (context, state) {
          final model = state<LoginModel>();
          final responseModel = state<AuthResponse>();
          if (widget.role == Role.parent) {
            Momentum.controller<LoginController>(context).recordRoleId(1);
          }
          if (widget.role == Role.teacher) {
            Momentum.controller<LoginController>(context).recordRoleId(3);
          }
          if (widget.role == Role.manager) {
            Momentum.controller<LoginController>(context).recordRoleId(4);
          }
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Form(
                // autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _loginFormKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 50.h),
                      const Text(
                        "Bus Mate",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFECAB33)),
                      ),
                      SizedBox(height: 1.sh * 1 / 8),
                      Text("Bạn đang đăng nhập dưới vai trò: " +
                          roleToString(widget.role)),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          onChanged: (value) =>
                              Momentum.controller<LoginController>(context)
                                  .recordUsername(value),
                          validator: (value) =>
                              Momentum.controller<LoginController>(context)
                                  .validateUsernameString(value),
                          decoration: BoxedInputDecoration(
                              displayHintText: "Tên người dùng...",
                              displayPrefixIcon: Icon(
                                Icons.person_outline,
                                color: Theme.of(context).primaryColor,
                              ),
                              filledColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer)),
                      SizedBox(height: 20.h),
                      TextFormField(
                        obscureText: _isHidePassword,
                        textInputAction: TextInputAction.done,

                        onChanged: (value) =>
                            Momentum.controller<LoginController>(context)
                                .recordPassword(hashPassword(value)),
                        // onChanged: (value) =>
                        //     Momentum.controller<LoginController>(context)
                        //         .recordPassword(value),
                        validator: (value) =>
                            Momentum.controller<LoginController>(context)
                                .validatePasswordString(value),
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
                          filledColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          displayHintText: "Mật khẩu...",
                        ),
                      ),
                      Visibility(
                          visible: responseModel.authResponseMessage != "",
                          child: SizedBox(height: 15.h)),
                      Visibility(
                          visible: responseModel.authResponseMessage != "",
                          child: Text(
                            responseModel.authResponseMessage!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.red),
                          )),
                      SizedBox(height: 20.h),
                      SizedBox(
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
                                onPressed: () {
                                  if (_loginFormKey.currentState!.validate()) {
                                    // recaptchaV2Controller.show();
                                    Momentum.controller<LoginController>(
                                            context)
                                        .doLogin(model);
                                  } else {
                                    responseModel.controller
                                        .setAuthErrorMessage("");
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 13.h),
                                  child: Text(
                                    "Đăng nhập".toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(color: Colors.white),
                                  ),
                                )),
                          )),
                      SizedBox(height: 10.h),
                      Visibility(
                        visible: widget.role == Role.parent,
                        child: SizedBox(
                            width: 1.sw,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Bạn chưa có tài khoản? "),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterScreen(
                                                  token: widget.token,
                                                )),
                                      );
                                    },
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16),
                                      child: Text("Đăng kí tài khoản"),
                                    )),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  void initMomentumState() {
    // TODO: implement initMomentumState
    super.initMomentumState();
    final loginController = Momentum.controller<LoginController>(context);
    loginController.listen<AuthEvent>(
      state: this,
      invoke: (event) {
        switch (event.action) {
          case true:
            if (widget.role == Role.teacher) {
              Momentum.controller<AuthResponseController>(context)
                  .setAuthErrorMessage("");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeTeacher(user: event.user)),
              );
            }
            if (widget.role == Role.parent) {
              Momentum.controller<AuthResponseController>(context)
                  .setAuthErrorMessage("");
              print("LoginScreen token " + widget.token!);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeParent(
                          token: widget.token,
                          user: event.user!,
                        )),
              );
            }
            if (widget.role == Role.manager) {
              Momentum.controller<AuthResponseController>(context)
                  .setAuthErrorMessage("");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeManager(user: event.user)),
              );
            }
            break;
          case false:
            Momentum.controller<AuthResponseController>(context)
                .setAuthErrorMessage("Username or password wrong!!!");

            break;
          case null:
            print(event.message);
            break;
          default:
        }
      },
    );
  }
}
