import 'package:momentum/momentum.dart';

import '../controllers/list_history_attendance_controller.dart';
import 'attendance_history_model.dart';

class ListHistoryAttendanceModel
    extends MomentumModel<ListHistoryAttendanceController> {
  final List<HistoryAttendanceModel> attendanceList;
  bool isFetched;

  ListHistoryAttendanceModel(super.controller,
      {required this.attendanceList, required this.isFetched});

  @override
  void update({List<HistoryAttendanceModel>? attendanceList, bool? isFetched}) {
    ListHistoryAttendanceModel(
      controller,
      attendanceList: attendanceList ?? this.attendanceList,
      isFetched: isFetched ?? this.isFetched,
    ).updateMomentum();
  }
}
