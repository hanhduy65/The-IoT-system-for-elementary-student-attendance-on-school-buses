import 'package:momentum/momentum.dart';

import '../events/events.dart';
import '../models/take_attendance_response_model.dart';
import '../services/auth_service.dart';

class TakeAttendanceResponseController
    extends MomentumController<TakeAttendanceResponse> {
  @override
  TakeAttendanceResponse init() {
    return TakeAttendanceResponse(this,
        isSuccessful: true, responseMessage: '');
  }

  void setErrorMessage(String? value) {
    model.update(responseMessage: value);
  }

  Future<void> doTakeAttendance(List<String> studentIds) async {
    final authService = service<AuthServices>();
    final profile = await authService.takeAttendance(studentIds);
    sendEvent(TakeAttendanceEvent(
        action: profile.isSuccessful, message: profile.responseMessage));
  }
}
