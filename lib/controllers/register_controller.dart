import 'package:momentum/momentum.dart';

import '../events/login_events.dart';
import '../models/register_model.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class RegisterController extends MomentumController<RegisterModel> {
  @override
  RegisterModel init() {
    return RegisterModel(this, username: "", password: "", roleId: 1);
  }

  void recordUsername(String value) {
    model.update(username: value);
  }

  void recordRoleId(int value) {
    model.update(roleId: value);
  }

  void recordPassword(String value) {
    // validatePassword(value);
    model.update(password: value);
  }

  String? validateEmail(String? email) {
    if (email!.isEmpty) {
      return "Vui lòng nhập địa chỉ email";
    }
    if (!email.contains('@') ||
        !email.contains('.') ||
        email.split('@')[0].isEmpty ||
        email.split('@')[1].split('.')[0].isEmpty ||
        email.split('.')[1].isEmpty) {
      return "Địa chỉ email sai cú pháp";
    }
    return null;
  }
  // String? validatePhoneString(String? value) {
  //   if (value == null || value == "") {
  //     return "Số điện thoại người dùng không được để trống";
  //   }
  //   if (!isValidPhoneNumber(value)) {
  //     return "Số điện thoại người dùng không đúng định dạng";
  //   }
  //   return null;
  // }

  // String? validateFullNameString(String? value) {
  //   if (value == null || value == "") {
  //     return "Tên đầy đủ không được để trống";
  //   }
  //   return null;
  // }

  String? validatePasswordString(String? value) {
    if (value == null || value == "") {
      return "Mật khẩu không được để trống";
    }
    return null;
  }

  String? checkConfirmPassWord(String? confirmPassword, String? password) {
    if (password!.isEmpty) {
      return "Vui lòng nhập mật khẩu";
    }
    if (confirmPassword!.isEmpty) {
      return "Vui lòng nhập lại mật khẩu";
    }
    if (password != confirmPassword) {
      return "Mật khẩu không trùng";
    }
    return null;
  }

  Future<void> doRegister(RegisterModel requestModel) async {
    print("Register in with model: ${requestModel.toJson()}");
    final authService = service<AuthServices>();
    final profile = await authService.register(requestModel);
    print("controller of register: " + profile.isAuthSuccessful.toString());
    sendEvent(AuthEvent(
      action: profile.isAuthSuccessful,
      message: profile.authResponseMessage ?? "",
    ));
  }

  bool isValidPhoneNumber(String phoneNumber) {
    final RegExp regex = RegExp(r'^[0-9]{10}$');
    return regex.hasMatch(phoneNumber);
  }
}

class AuthRegisterResponseController
    extends MomentumController<AuthRegisterResponse> {
  @override
  AuthRegisterResponse init() {
    // TODO: implement init
    return AuthRegisterResponse(this,
        isAuthSuccessful: true, authResponseMessage: '');
  }

  void setAuthErrorMessage(String? value) {
    model.update(authResponseMessage: value);
  }
}
