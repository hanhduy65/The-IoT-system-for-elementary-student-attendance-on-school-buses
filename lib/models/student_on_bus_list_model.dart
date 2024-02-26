import 'package:momentum/momentum.dart';
import '../controllers/student_on_bus_list_controller.dart';
import 'attendance_model.dart';

class StudentOnBusListModel extends MomentumModel<StudentOnBusListController> {
  final List<AttendanceModel> studentList;
  bool isFetched;

  StudentOnBusListModel(super.controller,
      {required this.studentList, required this.isFetched});

  @override
  void update({List<AttendanceModel>? studentList, bool? isFetched}) {
    StudentOnBusListModel(
      controller,
      studentList: studentList ?? this.studentList,
      isFetched: isFetched ?? this.isFetched,
    ).updateMomentum();
  }
}
