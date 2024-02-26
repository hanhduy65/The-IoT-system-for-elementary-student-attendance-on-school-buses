import 'package:momentum/momentum.dart';

import '../models/attendance_history_model.dart';
import '../models/list_history_attendance_model.dart';
import '../services/student_service.dart';

class ListHistoryAttendanceController
    extends MomentumController<ListHistoryAttendanceModel> {
  @override
  init() {
    return ListHistoryAttendanceModel(this,
        attendanceList: const [], isFetched: false);
  }

  Future<void> getAttendanceList(String studentId) async {
    try {
      final studentService = service<StudentServices>();
      final fetchedStudentList =
          await studentService.getHistoryAttendanceById(studentId);
      model.update(
        attendanceList: fetchedStudentList,
      );
    } catch (e) {
      print("get list history attendance error: $e");
    }
  }
}
