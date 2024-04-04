import 'package:momentum/momentum.dart';

import '../controllers/list_history_attendance_controller.dart';
import 'attendance_history_model.dart';

class ListHistoryAttendanceModel
    extends MomentumModel<ListHistoryAttendanceController> {
  final List<HistoryAttendanceModel> attendanceList;
  bool isFetched, isLoading;

  ListHistoryAttendanceModel(super.controller,
      {required this.attendanceList,
      required this.isFetched,
      required this.isLoading});

  @override
  void update(
      {List<HistoryAttendanceModel>? attendanceList,
      bool? isFetched,
      bool? isLoading}) {
    ListHistoryAttendanceModel(
      controller,
      attendanceList: attendanceList ?? this.attendanceList,
      isFetched: isFetched ?? this.isFetched,
      isLoading: isLoading ?? this.isLoading,
    ).updateMomentum();
  }
}
