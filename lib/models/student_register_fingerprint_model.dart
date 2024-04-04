import 'package:momentum/momentum.dart';
import 'package:busmate/models/student_model.dart';

import '../controllers/student_register_fingerprint_controller.dart';

class StudentRegisterFingerprintListModel
    extends MomentumModel<StudentRegisterFingerprintListController> {
  final List<StudentModel> studentList;
  bool isFetched, isLoading;

  StudentRegisterFingerprintListModel(super.controller,
      {required this.studentList,
      required this.isFetched,
      required this.isLoading});

  @override
  void update(
      {List<StudentModel>? studentList, bool? isFetched, bool? isLoading}) {
    StudentRegisterFingerprintListModel(
      controller,
      studentList: studentList ?? this.studentList,
      isFetched: isFetched ?? this.isFetched,
      isLoading: isLoading ?? this.isLoading,
    ).updateMomentum();
  }
}
