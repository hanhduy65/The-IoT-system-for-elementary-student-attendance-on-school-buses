import 'package:momentum/momentum.dart';

import '../controllers/register_controller.dart';

class RegisterModel extends MomentumModel<RegisterController> {
  final String? username, password, fullName, phone;
  final int? roleId;

  const RegisterModel(super.controller,
      {this.password, this.username, this.roleId, this.fullName, this.phone});

  @override
  void update({
    String? username,
    String? password,
    String? fullName,
    String? phone,
    int? roleId,
  }) {
    // TODO: implement update
    RegisterModel(
      controller,
      username: username ?? this.username,
      password: password ?? this.password,
      roleId: roleId ?? this.roleId,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
    ).updateMomentum();
  }

  @override
  Map<String, dynamic>? toJson() {
    return {
      "username": username,
      "password": password,
      "roleId": roleId,
    };
  }
}

class AuthRegisterResponse
    extends MomentumModel<AuthRegisterResponseController> {
  final bool? isAuthSuccessful;
  final String? authResponseMessage;
  const AuthRegisterResponse(AuthRegisterResponseController controller,
      {this.isAuthSuccessful, this.authResponseMessage})
      : super(controller);

  @override
  AuthRegisterResponse fromJson(Map<String, dynamic>? json) {
    return AuthRegisterResponse(
      controller,
      isAuthSuccessful: json?["success"],
      authResponseMessage: json?["message"],
    );
  }

  @override
  void update({bool? isAuthSuccessful, String? authResponseMessage}) {
    AuthRegisterResponse(controller,
            authResponseMessage:
                authResponseMessage ?? this.authResponseMessage,
            isAuthSuccessful: isAuthSuccessful ?? this.isAuthSuccessful)
        .updateMomentum();
  }
}
