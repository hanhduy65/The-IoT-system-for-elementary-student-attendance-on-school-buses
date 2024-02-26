import 'package:momentum/momentum.dart';

import '../controllers/login_controller.dart';

class LoginModel extends MomentumModel<LoginController> {
  final String? username, password;
  final int? roleId;

  const LoginModel(LoginController controller,
      {this.password, this.username, this.roleId})
      : super(controller);

  @override
  void update(
      {String? username,
      String? password,
      bool? passwordVisibility,
      int? roleId}) {
    // TODO: implement update
    LoginModel(controller,
            username: username ?? this.username,
            password: password ?? this.password,
            roleId: roleId ?? this.roleId)
        .updateMomentum();
  }

  @override
  Map<String, dynamic>? toJson() {
    return {"username": username, "password": password, "roleId": roleId};
  }
}

class AuthResponse extends MomentumModel<AuthResponseController> {
  final bool? isAuthSuccessful;
  final String? authResponseMessage, userId, userName, fullName;
  final dynamic? phone;
  final int? roleId;

  const AuthResponse(AuthResponseController controller,
      {this.isAuthSuccessful,
      this.authResponseMessage,
      this.roleId,
      this.userId,
      this.phone,
      this.fullName,
      this.userName})
      : super(controller);

  @override
  AuthResponse fromJson(Map<String, dynamic>? json) {
    return AuthResponse(controller,
        isAuthSuccessful: json?["success"] ?? true,
        authResponseMessage: json?["message"] ?? " ",
        roleId: json?["role_id"] ?? 0,
        userId: json?["user_id"] ?? " ",
        userName: json?["user_name"] ?? " ",
        phone: json?["phone"],
        fullName: json?["full_name"] ?? " ");
  }

  @override
  void update({
    bool? isAuthSuccessful,
    String? authResponseMessage,
    String? userId,
    String? userName,
    String? fullName,
    String? phone,
    int? roleId,
  }) {
    AuthResponse(
      controller,
      authResponseMessage: authResponseMessage ?? this.authResponseMessage,
      isAuthSuccessful: isAuthSuccessful ?? this.isAuthSuccessful,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      roleId: roleId ?? this.roleId,
    ).updateMomentum();
  }
}
