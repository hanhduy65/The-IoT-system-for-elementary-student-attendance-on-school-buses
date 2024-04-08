import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recaptcha_v2_compat/flutter_recaptcha_v2_compat.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:momentum/momentum.dart';

import '../../controllers/login_controller.dart';
import '../../controllers/register_controller.dart';
import '../../events/login_events.dart';
import '../../models/login_model.dart';
import '../../models/register_model.dart';
import '../widgets/input_decoration.dart';
import 'choose_role.dart';

class RegisterScreen extends StatefulWidget {
  final String? token;
  const RegisterScreen({super.key, this.token});

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

          return Scaffold(
            body: Container(
              height: 1.sh * 2 / 3,
              color: Color(0xFF87CCED),
              child: SingleChildScrollView(
                child: Form(
                  key: _registerFormKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 50.h),
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
                        Text("Sign up for Parent: "),
                        TextFormField(
                            textInputAction: TextInputAction.next,
                            onChanged: (value) {
                              Momentum.controller<RegisterController>(context)
                                  .recordUsername(value);
                            },
                            validator: (value) =>
                                Momentum.controller<RegisterController>(context)
                                    .validateEmail(value),
                            decoration: BoxedInputDecoration(
                                displayHintText: "Email...",
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
                          textInputAction: TextInputAction.next,
                          onChanged: (value) =>
                              Momentum.controller<RegisterController>(context)
                                  .recordPassword(hashPassword(value)),
                          validator: (value) =>
                              Momentum.controller<RegisterController>(context)
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
                            displayHintText: "Password...",
                          ),
                        ),
                        SizedBox(height: 20.h),
                        TextFormField(
                          obscureText: _isHideRePassrowd,
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                              Momentum.controller<RegisterController>(context)
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
                                Icons.lock_outline,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            filledColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            displayHintText: "Re-enter password...",
                          ),
                        ),
                        SizedBox(height: 20.h),
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
                                        Momentum.controller<RegisterController>(
                                                context)
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
    final registerController = Momentum.controller<RegisterController>(context);
    registerController.listen<AuthEvent>(
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
                  builder: (context) => ChoosingRole(FCMToken: widget.token),
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
