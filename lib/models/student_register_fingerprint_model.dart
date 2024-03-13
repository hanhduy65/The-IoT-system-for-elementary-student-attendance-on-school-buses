import 'package:momentum/momentum.dart';
import 'package:school_bus_attendance_test/models/student_model.dart';

import '../controllers/student_register_fingerprint_controller.dart';

class StudentRegisterFingerprintListModel
    extends MomentumModel<StudentRegisterFingerprintListController> {
  final List<StudentModel> studentList;
  bool isFetched;

  StudentRegisterFingerprintListModel(super.controller,
      {required this.studentList, required this.isFetched});

  @override
  void update({List<StudentModel>? studentList, bool? isFetched}) {
    StudentRegisterFingerprintListModel(
      controller,
      studentList: studentList ?? this.studentList,
      isFetched: isFetched ?? this.isFetched,
    ).updateMomentum();
  }
}
