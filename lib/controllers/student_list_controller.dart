import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:momentum/momentum.dart';

import '../events/login_events.dart';
import '../models/student_list_model.dart';
import '../services/student_service.dart';

class StudentListController extends MomentumController<StudentListModel> {
  @override
  init() {
    return StudentListModel(this, studentList: const []);
  }

  Future<void> getStudentList() async {
    try {
      final studentService = service<StudentServices>();
      final fetchedStudentList = await studentService.getAllStudent();
      model.update(
        studentList: fetchedStudentList,
      );
    } catch (e) {
      print("search Student list error: $e");
    }
  }
}
