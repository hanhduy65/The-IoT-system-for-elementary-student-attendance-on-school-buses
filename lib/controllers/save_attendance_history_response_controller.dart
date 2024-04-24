import 'package:momentum/momentum.dart';

import '../events/events.dart';
import '../models/save_attendance_history_response_model.dart';
import '../services/auth_service.dart';

class SaveAttendanceHistoryResponseController
    extends MomentumController<SaveAttendanceHistoryResponse> {
  @override
  SaveAttendanceHistoryResponse init() {
    return SaveAttendanceHistoryResponse(this,
        isSuccessful: true, responseMessage: '');
  }

  void setErrorMessage(String? value) {
    model.update(responseMessage: value);
  }

  Future<void> doSaveAttendanceHistoryReport(String suId, int busId) async {
    final authService = service<AuthServices>();
    final profile = await authService.saveAttendanceHistoryReport(suId, busId);
    sendEvent(SaveAttendanceHistoryReportEvent(
        action: profile.isSuccessful, message: profile.responseMessage));
  }
}
