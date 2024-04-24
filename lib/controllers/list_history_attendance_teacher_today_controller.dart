import 'package:busmate/services/auth_service.dart';
import 'package:momentum/momentum.dart';

import '../models/list_history_attendance_teacher_today_model.dart';

class ListHistoryAttendanceTeacherController
    extends MomentumController<ListHistoryAttendanceTeacherModel> {
  @override
  init() {
    return ListHistoryAttendanceTeacherModel(this,
        listAttendance: const [], isFetched: false, isLoading: true);
  }

  Future<void> getBusAttendanceReport(String suId) async {
    print("service + getBusAttendanceReport");
    model.update(isLoading: true);
    try {
      final authService = service<AuthServices>();
      final fetchedAttendanceReport =
          await authService.getBusAttendanceReport(suId);
      model.update(listAttendance: fetchedAttendanceReport, isLoading: false);
    } catch (e) {
      print("get bus attendance report error: $e");
    }
  }
}
