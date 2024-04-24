import 'dart:convert';

import 'package:busmate/views/screens/choose_role_remake.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_recaptcha_v2_compat/flutter_recaptcha_v2_compat.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:momentum/momentum.dart';

import '../../controllers/login_controller.dart';
import '../../controllers/register_controller.dart';
import '../../events/events.dart';
import '../../models/login_model.dart';
import '../../models/register_model.dart';
import '../../models/user_model.dart';
import '../widgets/input_decoration.dart';

class RegisterScreen extends StatefulWidget {
  final User? user;
  const RegisterScreen({super.key, this.user});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends MomentumState<RegisterScreen> {
  final _registerFormKey = GlobalKey<FormState>();
  String verifyResult = "";

  String hashPassword(String password) {
    // Sử dụng thuật toán mã hóa md5
    var bytes = utf8.encode(password); // Chuyển đổi mật khẩu sang dạng byte
    var digest = md5.convert(bytes); // Mã hóa mật khẩu
    return digest.toString(); // Trả về chuỗi mật khẩu đã được mã hóa
  }

  RecaptchaV2Controller recaptchaV2Controller = RecaptchaV2Controller();
  bool _isHidePassword = true;
  bool _isHideRePassrowd = true;
  @override
  Widget build(BuildContext context) {
    return MomentumBuilder(
        controllers: const [RegisterController, AuthResponseController],
        builder: (context, state) {
          final model = state<RegisterModel>();
          final responseModel = state<AuthResponse>();

          return Stack(
            children: [
              Container(
                height: 1.sh,
                width: 1.sw,
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
                  automaticallyImplyLeading: widget.user == null ? true : false,
                ),
                body: SingleChildScrollView(
                  child: Form(
                    key: _registerFormKey,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Bus Mate",
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                shadows: const [
                                  Shadow(
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 5.0,
                                    color: Colors.black,
                                  ),
                                ]),
                          ),
                          SizedBox(height: 40.h),
                          const Text(
                            "Sign up for Parent: ",
                            style: TextStyle(fontStyle: FontStyle.italic),
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
                                  textInputAction: TextInputAction.next,
                                  onChanged: (value) {
                                    Momentum.controller<RegisterController>(
                                            context)
                                        .recordUsername(value);
                                  },
                                  validator: (value) =>
                                      Momentum.controller<RegisterController>(
                                              context)
                                          .validateEmail(value),
                                  decoration: BoxedInputDecoration(
                                      displayHintText: "Email...",
                                      displayPrefixIcon: Icon(
                                        Icons.person_outline,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      filledColor: Colors.white)),
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
                                textInputAction: TextInputAction.next,
                                onChanged: (value) =>
                                    Momentum.controller<RegisterController>(
                                            context)
                                        .recordPassword(hashPassword(value)),
                                validator: (value) =>
                                    Momentum.controller<RegisterController>(
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
                                      !_isHidePassword
                                          ? Icons.lock_outline
                                          : Icons.lock_open,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  filledColor: Colors.white,
                                  displayHintText: "Password...",
                                ),
                              ),
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
                                obscureText: _isHideRePassrowd,
                                textInputAction: TextInputAction.next,
                                validator: (value) => Momentum.controller<
                                        RegisterController>(context)
                                    .checkConfirmPassWord(
                                        hashPassword(value!), model.password),
                                decoration: BoxedInputDecoration(
                                  displayPrefixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _isHideRePassrowd = !_isHideRePassrowd;
                                      });
                                    },
                                    child: Icon(
                                      !_isHideRePassrowd
                                          ? Icons.lock_outline
                                          : Icons.lock_open,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  filledColor: Colors.white,
                                  displayHintText: "Re-enter password...",
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
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
                          SizedBox(height: 10.h),
                          SizedBox(height: 30.h),
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
                                      if (_registerFormKey.currentState!
                                          .validate()) {
                                        recaptchaV2Controller.show();
                                      } else {
                                        responseModel.controller
                                            .setAuthErrorMessage("");
                                      }
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 13.h),
                                      child: Text(
                                        "Sign up".toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(color: Colors.white),
                                      ),
                                    )),
                              )),
                          Container(
                            height: 1.sh,
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: Text(verifyResult),
                                ),
                                Center(
                                  child: RecaptchaV2(
                                    apiKey:
                                        "6LflsV8pAAAAACw1Ez2IU6cqsOWOZJ5GzMt2D5MY",
                                    apiSecret:
                                        "6LflsV8pAAAAAJVSYr7yX3T2Hyi_i-BSqN1E-jS0",
                                    controller: recaptchaV2Controller,
                                    onVerifiedError: (err) {
                                      print(err);
                                    },
                                    onVerifiedSuccessfully: (success) {
                                      setState(() {
                                        if (success) {
                                          verifyResult =
                                              "You've been verified successfully";
                                          Momentum.controller<
                                                  RegisterController>(context)
                                              .doRegister(model);
                                        } else {
                                          verifyResult = "Failed to verify.";
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  @override
  void initMomentumState() {
    // TODO: implement initMomentumState
    super.initMomentumState();
    final registerController = Momentum.controller<RegisterController>(context);
    registerController.listen<AuthRegisterEvent>(
      state: this,
      invoke: (event) {
        switch (event.action) {
          case true:
            Momentum.controller<AuthResponseController>(context)
                .setAuthErrorMessage("");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(event.message ?? "Đăng kí thành công"),
                backgroundColor: Colors.green));
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChooseRoleRemake(),
                ));
            break;
          case false:
            Momentum.controller<AuthResponseController>(context)
                .setAuthErrorMessage(event.message);

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
