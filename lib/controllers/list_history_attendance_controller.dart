import 'package:momentum/momentum.dart';

import '../models/attendance_history_model.dart';
import '../models/list_history_attendance_model.dart';
import '../services/student_service.dart';

class ListHistoryAttendanceController
    extends MomentumController<ListHistoryAttendanceModel> {
  @override
  init() {
    return ListHistoryAttendanceModel(this,
        attendanceList: const [], isFetched: false, isLoading: true);
  }

  Future<void> getAttendanceList(String studentId) async {
    model.update(isLoading: true);
    print("isLoading đang là true");
    try {
      final studentService = service<StudentServices>();
      final fetchedStudentList =
          await studentService.getHistoryAttendanceById(studentId);
      model.update(attendanceList: fetchedStudentList, isLoading: false);
      print("isLoading đang là false");
    } catch (e) {
      print("get list history attendance error: $e");
    }
  }
}
