import 'package:busmate/models/manager_location_model.dart';

import '../models/location_model.dart';
import '../models/user_model.dart';

class AuthEvent {
  final bool? action;
  final String? message;
  final User? user;
  AuthEvent({this.action, this.message, this.user});
}

class AuthRegisterEvent {
  final bool? action;
  final String? message;
  AuthRegisterEvent({this.action, this.message});
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

class ManagerLocationEvent {
  final List<ManagerLocationModel> locations;
  ManagerLocationEvent({required this.locations});
}

class RegisterSmartTagEvent {
  final bool? action;
  final String? message;
  RegisterSmartTagEvent({this.action, this.message});
}

class SaveAttendanceHistoryReportEvent {
  final bool? action;
  final String? message;
  SaveAttendanceHistoryReportEvent({this.action, this.message});
}

class TakeAttendanceEvent {
  final bool? action;
  final String? message;
  TakeAttendanceEvent({this.action, this.message});
}

class SendSmartTagsEvent {
  final bool? action;
  final String? message;
  SendSmartTagsEvent({this.action, this.message});
}
