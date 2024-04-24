import 'package:momentum/momentum.dart';

import '../controllers/attendance_controller.dart';
import '../controllers/item_history_attendance_teacher_today_controller.dart';
import 'attendance_model.dart';

class ItemHistoryAttendanceTeacherModel
    extends MomentumModel<ItemHistoryAttendanceTeacherController> {
  final int? report;
  final List<AttendanceModel> studentList;
  bool? isFetched, isLoading;

  ItemHistoryAttendanceTeacherModel(
      ItemHistoryAttendanceTeacherController controller,
      {this.report,
      required this.studentList,
      this.isFetched,
      this.isLoading})
      : super(controller);

  @override
  void update(
      {int? report,
      List<AttendanceModel>? studentList,
      bool? isFetched,
      bool? isLoading}) {
    ItemHistoryAttendanceTeacherModel(
      controller,
      report: report ?? this.report,
      studentList: studentList ?? this.studentList,
      isFetched: isFetched ?? this.isFetched,
      isLoading: isLoading ?? this.isLoading,
    ).updateMomentum();
  }

  @override
  ItemHistoryAttendanceTeacherModel fromJson(Map<String, dynamic>? json) {
    AttendanceModel attendance = AttendanceController().init();
    return ItemHistoryAttendanceTeacherModel(controller,
        report: json?["report"],
        studentList: List.from(json?["detail"])
            .map((e) => attendance.fromJson(e))
            .toList());
  }
}
