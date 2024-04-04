import 'package:busmate/models/login_model.dart';

import '../models/location_model.dart';
import '../models/user_model.dart';

enum LoginEventActions {
  none,
  loginSuccess,
  usernameDoesNotExists,
  incorrectCredentials,
  passwordTooShort,
  unknownError,
}

class AuthEvent {
  final bool? action;
  final String? message;
  final User? user;
  AuthEvent({this.action, this.message, this.user});
}

class LocationEvent {
  final Location location;
  LocationEvent({required this.location});
}
