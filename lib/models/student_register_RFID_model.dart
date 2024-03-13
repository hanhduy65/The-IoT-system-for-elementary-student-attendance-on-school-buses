import 'package:momentum/momentum.dart';
import 'package:school_bus_attendance_test/models/student_model.dart';

import '../controllers/student_register_RFID_controller.dart';

class StudentRegisterRFIDListModel
    extends MomentumModel<StudentRegisterRFIDListController> {
  final List<StudentModel> studentList;
  bool isFetched;

  StudentRegisterRFIDListModel(super.controller,
      {required this.studentList, required this.isFetched});

  @override
  void update({List<StudentModel>? studentList, bool? isFetched}) {
    StudentRegisterRFIDListModel(
      controller,
      studentList: studentList ?? this.studentList,
      isFetched: isFetched ?? this.isFetched,
    ).updateMomentum();
  }
}
