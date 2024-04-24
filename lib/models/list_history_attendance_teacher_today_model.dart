import 'package:busmate/models/item_history_attendance_teacher_today_model.dart';
import 'package:momentum/momentum.dart';

import '../controllers/list_history_attendance_teacher_today_controller.dart';

class ListHistoryAttendanceTeacherModel
    extends MomentumModel<ListHistoryAttendanceTeacherController> {
  final List<ItemHistoryAttendanceTeacherModel> listAttendance;
  bool? isFetched, isLoading;

  ListHistoryAttendanceTeacherModel(super.controller,
      {required this.listAttendance, this.isFetched, this.isLoading});

  @override
  void update(
      {List<ItemHistoryAttendanceTeacherModel>? listAttendance,
      bool? isFetched,
      bool? isLoading}) {
    ListHistoryAttendanceTeacherModel(
      controller,
      listAttendance: listAttendance ?? this.listAttendance,
      isFetched: isFetched ?? this.isFetched,
      isLoading: isLoading ?? this.isLoading,
    ).updateMomentum();
  }
}
