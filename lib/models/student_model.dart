import 'package:momentum/momentum.dart';

import '../controllers/student_controller.dart';

class StudentModel extends MomentumModel<StudentController> {
  final int? busId;
  final String? busPosition,
      className,
      studentName,
      image,
      parentId,
      teacherId,
      parentName,
      studentId,
      teacherName;
  bool? isStudentLoaded, isGetStudentByParent;

  StudentModel(StudentController controller,
      {this.busId,
      this.busPosition,
      this.className,
      this.parentId,
      this.studentId,
      this.studentName,
      this.teacherId,
      this.image,
      this.parentName,
      this.teacherName,
      this.isStudentLoaded,
      this.isGetStudentByParent})
      : super(controller);

  void update(
      {String? className,
      String? studentName,
      String? parentName,
      String? teacherName,
      String? studentId,
      int? busId,
      bool? isStudentLoaded,
      bool? isGetStudentByParent}) {
    // TODO: implement update
    StudentModel(
      controller,
      className: className ?? this.className,
      studentName: studentName ?? this.studentName,
      parentName: parentName ?? this.parentName,
      teacherName: teacherName ?? this.teacherName,
      studentId: studentId ?? this.studentId,
      busId: busId ?? this.busId,
      isStudentLoaded: isStudentLoaded ?? this.isStudentLoaded,
      isGetStudentByParent: isGetStudentByParent ?? this.isGetStudentByParent,
    ).updateMomentum();
  }

  @override
  Map<String, dynamic>? toJson() {
    return {
      "bus_id": busId,
      "bus_position": busPosition,
      "class_name": className,
      "parent_id": parentId,
      "student_id": studentId,
      "student_name": studentName,
      "teacher_id": teacherId,
      "iamge": image,
      "teacher_name": teacherName,
      "parent_name": parentName
    };
  }

  @override
  StudentModel fromJson(Map<String, dynamic>? json) {
    return StudentModel(controller,
        busId: json?["bus_id"] ?? 0,
        busPosition: json?["bus_position"] ?? " ",
        className: json?["class_name"] ?? " ",
        parentId: json?["parent_id"] ?? "",
        studentId: json?["student_id"] ?? "",
        studentName: json?["student_name"] ?? "",
        teacherId: json?["teacher_id"] ?? "",
        image: json?["image"] ?? " ",
        teacherName: json?["teacher_name"] ?? " ",
        parentName: json?["parent_name"] ?? " ");
  }
}
