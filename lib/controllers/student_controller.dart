import 'package:momentum/momentum.dart';

import '../models/student_model.dart';
import '../services/student_service.dart';

class StudentController extends MomentumController<StudentModel> {
  @override
  init() {
    return StudentModel(this,
        studentId: "",
        studentName: '',
        className: "",
        parentName: "",
        teacherName: "",
        busId: 0,
        busPosition: "",
        image: "",
        parentId: "",
        teacherId: "",
        isStudentLoaded: false,
        isGetStudentByParent: false);
  }

  Future<void> getStudentById(String studentId) async {
    try {
      final studentService = service<StudentServices>();
      final fetchedStudent = await studentService.searchStudentById(studentId);

      model.update(
          studentId: fetchedStudent.studentId ?? "",
          busId: fetchedStudent.busId ?? 0,
          teacherName: fetchedStudent.teacherName ?? "",
          parentName: fetchedStudent.parentName ?? "",
          studentName: fetchedStudent.studentName ?? "",
          className: fetchedStudent.className ?? "");
    } catch (e) {
      print("get student by id error: $e");
    }
  }

  Future<void> getStudentByParentId(String parentId) async {
    try {
      final studentService = service<StudentServices>();
      final fetchedStudent =
          await studentService.getStudentIdByParentId(parentId);
      print("Get student by parent id" + fetchedStudent.toString());
      model.update(
          studentId: fetchedStudent.studentId ?? "",
          studentName: fetchedStudent.studentName ?? "",
          className: fetchedStudent.className ?? "");
    } catch (e) {
      print("get student by id error: $e");
    }
  }
}
