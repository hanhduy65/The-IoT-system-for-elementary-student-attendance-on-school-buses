import 'package:momentum/momentum.dart';
import '../controllers/attendance_controller.dart';
import '../controllers/student_on_bus_list_controller.dart';
import 'attendance_model.dart';

class StudentOnBusListModel extends MomentumModel<StudentOnBusListController> {
  final int? studentsOnBusCount, studentsOffBusCount;
  final List<AttendanceModel> studentList;
  bool? isFetched, isLoading;

  StudentOnBusListModel(super.controller,
      {required this.studentList,
      this.studentsOffBusCount,
      this.studentsOnBusCount,
      this.isFetched,
      this.isLoading});

  @override
  void update(
      {List<AttendanceModel>? studentList,
      bool? isFetched,
      bool? isLoading,
      int? studentsOnBusCount,
      int? studentsOffBusCount}) {
    StudentOnBusListModel(
      controller,
      studentList: studentList ?? this.studentList,
      isFetched: isFetched ?? this.isFetched,
      isLoading: isLoading ?? this.isLoading,
      studentsOnBusCount: studentsOnBusCount ?? this.studentsOnBusCount,
      studentsOffBusCount: studentsOffBusCount ?? this.studentsOffBusCount,
    ).updateMomentum();
  }

  @override
  StudentOnBusListModel fromJson(Map<String, dynamic>? json) {
    AttendanceModel attendance = AttendanceController().init();
    return StudentOnBusListModel(controller,
        studentsOnBusCount: json?["studentsOnBusCount"] ?? 0,
        studentsOffBusCount: json?["studentsOffBusCount"] ?? 0,
        studentList: List.from(json?["listStudent"])
            .map((e) => attendance.fromJson(e))
            .toList());
  }
}
