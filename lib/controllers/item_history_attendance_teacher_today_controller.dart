import 'package:momentum/momentum.dart';

import '../models/item_history_attendance_teacher_today_model.dart';

class ItemHistoryAttendanceTeacherController
    extends MomentumController<ItemHistoryAttendanceTeacherModel> {
  @override
  init() {
    return ItemHistoryAttendanceTeacherModel(this,
        report: 0, studentList: const [], isFetched: false, isLoading: true);
  }
}
