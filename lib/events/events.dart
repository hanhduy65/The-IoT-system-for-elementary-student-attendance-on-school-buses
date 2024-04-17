import '../models/location_model.dart';
import '../models/user_model.dart';

class AuthEvent {
  final bool? action;
  final String? message;
  final User? user;
  AuthEvent({this.action, this.message, this.user});
}

class RegisterEvent {
  final bool? action;
  final String? message;
  RegisterEvent({this.action, this.message});
}

class LocationEvent {
  final LocationModel location;
  LocationEvent({required this.location});
}
