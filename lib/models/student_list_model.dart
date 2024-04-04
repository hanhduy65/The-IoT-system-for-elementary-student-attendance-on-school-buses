import 'package:momentum/momentum.dart';
import 'package:busmate/models/student_model.dart';

import '../controllers/student_controller.dart';
import '../controllers/student_list_controller.dart';

class StudentListModel extends MomentumModel<StudentListController> {
  final List<StudentModel> studentList;
  const StudentListModel(super.controller, {required this.studentList});

  @override
  void update({List<StudentModel>? studentList}) {
    StudentListModel(controller, studentList: studentList ?? this.studentList)
        .updateMomentum();
  }

  @override
  StudentListModel fromJson(Map<String, dynamic>? json) {
    StudentModel student = StudentController().init();
    return StudentListModel(controller,
        studentList: List.from(json?["students"])
            .map((e) => student.fromJson(e))
            .toList());
  }
}
