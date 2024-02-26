import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';
import 'package:school_bus_attendance_test/controllers/student_controller.dart';
import 'package:school_bus_attendance_test/models/student_model.dart';

class StudentDetail extends StatefulWidget {
  final String studentId;

  const StudentDetail({super.key, required this.studentId});

  @override
  State<StudentDetail> createState() => _StudentDetailState();
}

class _StudentDetailState extends MomentumState<StudentDetail> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Momentum.controller<StudentController>(context).model.isStudentLoaded =
            false;
        return true;
      },
      child: MomentumBuilder(
          controllers: const [StudentController],
          builder: (context, state) {
            final studentController =
                Momentum.controller<StudentController>(context);

            if (studentController.model.isStudentLoaded != null &&
                !studentController.model.isStudentLoaded!) {
              studentController.getStudentById(widget.studentId);
              studentController.model.isStudentLoaded = true;
            }

            final student = state<StudentModel>();
            return Scaffold(
              appBar: AppBar(
                title: Text("Chi tiết học sinh"),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    studentController.model.isStudentLoaded = false;
                    Navigator.pop(context);
                  },
                ),
              ),
              body: Center(
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tên học sinh: ${student.studentName!}"),
                      Text("Tên phụ huynh: ${student.parentName!}"),
                      Text("Tên giáo viên: ${student.teacherName!}"),
                      Text("Tên lớp: ${student.className!}"),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
