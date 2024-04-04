import 'package:momentum/momentum.dart';
import 'package:busmate/models/student_model.dart';

import '../controllers/student_register_RFID_controller.dart';

class StudentRegisterRFIDListModel
    extends MomentumModel<StudentRegisterRFIDListController> {
  final List<StudentModel> studentList;
  bool isFetched, isLoading;

  StudentRegisterRFIDListModel(super.controller,
      {required this.studentList,
      required this.isFetched,
      required this.isLoading});

  @override
  void update(
      {List<StudentModel>? studentList, bool? isFetched, bool? isLoading}) {
    StudentRegisterRFIDListModel(
      controller,
      studentList: studentList ?? this.studentList,
      isFetched: isFetched ?? this.isFetched,
      isLoading: isLoading ?? this.isLoading,
    ).updateMomentum();
  }
}
