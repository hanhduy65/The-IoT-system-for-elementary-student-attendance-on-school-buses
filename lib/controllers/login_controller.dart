import 'package:momentum/momentum.dart';
import 'package:busmate/utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../events/events.dart';
import '../models/login_model.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class LoginController extends MomentumController<LoginModel> {
  @override
  LoginModel init() {
    return LoginModel(this, username: "", password: "", roleId: 1);
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

  String? validateUsernameString(String? value) {
    if (value == null || value == "") {
      return "Username cannot be blank";
    }
    return null;
  }

  String? validatePasswordString(String? value) {
    if (value == null || value == "") {
      return "Password cannot be blank";
    }
    return null;
  }

  Future<void> doLogin(LoginModel requestModel) async {
    print("Loggin in with model: ${requestModel.toJson()}");
    final authService = service<AuthServices>();
    final profile = await authService.login(requestModel);
    print("Thông tin tài khoản sau login" + profile.toString());
    if ((profile.isAuthSuccessful)!) {
      User user = User(
          fullName: profile.fullName,
          phone: profile.phone,
          roleId: profile.roleId,
          userId: profile.userId,
          userName: profile.userName);
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('key_username', profile.userName!);
      sp.setString('key_roleId', profile.roleId.toString());
      sp.setString('key_userId', profile.userId!);
      sp.setString('key_fullname', profile.fullName!);
      sp.setString('key_phone', profile.phone!);
      sp.setBool('isLogin', true);
      print(user.toString());
      sendEvent(AuthEvent(
          action: profile.isAuthSuccessful,
          message: profile.authResponseMessage,
          user: user));
    } else {
      sendEvent(AuthEvent(
          action: profile.isAuthSuccessful,
          message: profile.authResponseMessage));
    }
  }

  Future<void> doSendFCMToken(String token, String parentId) async {
    final authService = service<AuthServices>();
    final profile = await authService.sendFCMToken(token, parentId);
    sendEvent(AuthEvent(
        action: profile.isAuthSuccessful,
        message: profile.authResponseMessage));
  }

  Future<void> doSendGPS(int busId, String latitude, String longitude) async {
    final authService = service<AuthServices>();
    final profile = await authService.sendGPS(busId, latitude, longitude);
    sendEvent(AuthEvent(
        action: profile.isAuthSuccessful,
        message: profile.authResponseMessage));
  }

  Future<void> doSendRequestRegisterStudent(
      int deviceId, String studentId) async {
    final authService = service<AuthServices>();
    final profile =
        await authService.sendRequestRegisterStudent(deviceId, studentId);
    sendEvent(RegisterEvent(
        action: profile.isAuthSuccessful,
        message: profile.authResponseMessage));
  }

  Future<void> doGetGPS(String parentId) async {
    print("controller getGPS");
    final authService = service<AuthServices>();
    final profile = await authService.getGPSByParentId(parentId);
    sendEvent(LocationEvent(location: profile));
  }

  Future<void> doSendRegisterBusStop(
      String studentId, String lat, String long) async {
    final authService = service<AuthServices>();
    final profile = await authService.sendRegisterBusStop(studentId, lat, long);
    sendEvent(RegisterEvent(
        action: profile.isAuthSuccessful,
        message: profile.authResponseMessage));
  }
}

class AuthResponseController extends MomentumController<AuthResponse> {
  @override
  AuthResponse init() {
    // TODO: implement init
    return AuthResponse(this,
        isAuthSuccessful: true,
        authResponseMessage: '',
        fullName: "",
        phone: "",
        userId: "",
        roleId: 0,
        userName: " ");
  }

  void setAuthErrorMessage(String? value) {
    model.update(authResponseMessage: value);
  }

  void setUserInfor(String? userId, String? userName, String? fullName,
      String? phone, int? roleId) {
    model.update(fullName: fullName);
    model.update(userName: userName);
    model.update(phone: phone);
    model.update(userId: userId);
    model.update(roleId: roleId);
  }
}
