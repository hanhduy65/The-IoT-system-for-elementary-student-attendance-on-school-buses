import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recaptcha_v2_compat/flutter_recaptcha_v2_compat.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:momentum/momentum.dart';
import 'package:busmate/views/screens/choose_role.dart';
import 'package:busmate/views/screens/manager_screen/home_manager.dart';
import 'package:busmate/views/screens/parent_screen/home_parent.dart';
import 'package:busmate/views/screens/teacher_screen/home_teacher.dart';
import 'package:busmate/views/screens/register_screen.dart';
import 'package:busmate/views/screens/teacher_screen/take_attendance.dart';
import 'package:busmate/views/screens/parent_screen/view_map_of_parent.dart';

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
  void initState() {
    // TODO: implement initState
    super.initState();
    // getInputUsernameSaved();
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
            appBar: AppBar(
              backgroundColor: Color(0xFF87CCED),
              elevation: 0,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF87CCED),
                ),
              ),
            ),
            body: Container(
              height: 1.sh * 2 / 3,
              color: Color(0xFF87CCED),
              child: SingleChildScrollView(
                child: Form(
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _loginFormKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: AutofillGroup(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
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
                          SizedBox(height: 40.h),
                          Text(
                            "HELLO " + roleToString(widget.role),
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold),
                          ),
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
                                  onChanged: (value) =>
                                      Momentum.controller<LoginController>(
                                              context)
                                          .recordUsername(value),
                                  validator: (value) =>
                                      Momentum.controller<LoginController>(
                                              context)
                                          .validateUsernameString(value),
                                  decoration: BoxedInputDecoration(
                                    displayHintText: "Username...",
                                    displayPrefixIcon: Icon(
                                      Icons.person_outline,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    filledColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
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

                                onChanged: (value) =>
                                    Momentum.controller<LoginController>(
                                            context)
                                        .recordPassword(hashPassword(value)),
                                // onChanged: (value) =>
                                //     Momentum.controller<LoginController>(context)
                                //         .recordPassword(value),
                                validator: (value) =>
                                    Momentum.controller<LoginController>(
                                            context)
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
                                  filledColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  displayHintText: "Password...",
                                ),
                              ),
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
                                          Momentum.controller<LoginController>(
                                                  context)
                                              .doLogin(model);
                                        } else {
                                          responseModel.controller
                                              .setAuthErrorMessage("");
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
                                              ?.copyWith(color: Colors.white),
                                        ),
                                      )),
                                )),
                          ),
                          SizedBox(height: 10.h),
                          Visibility(
                            visible: widget.role == Role.parent,
                            child: SizedBox(
                                width: 1.sw,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Don't have an account? "),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegisterScreen()),
                                          );
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16),
                                          child: Text(
                                            "Sign up",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
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
