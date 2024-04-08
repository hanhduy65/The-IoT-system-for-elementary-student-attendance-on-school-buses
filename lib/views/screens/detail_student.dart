import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:momentum/momentum.dart';
import 'package:busmate/controllers/student_controller.dart';
import 'package:busmate/models/student_model.dart';

class StudentDetail extends StatefulWidget {
  final String studentId;

  const StudentDetail({super.key, required this.studentId});

  @override
  State<StudentDetail> createState() => _StudentDetailState();
}

class _StudentDetailState extends MomentumState<StudentDetail> {
  final circleRadius = 136.0;
  final TextStyle detailTextStyle =
      TextStyle(fontSize: 14.sp, color: const Color(0xff51697E));
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
              body: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Stack(children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(30.r),
                        child: Column(children: [
                          Stack(
                              alignment: Alignment.topCenter,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(
                                      top: circleRadius / 2.0,
                                    ),
                                    child: Card(
                                        margin: EdgeInsets.zero,
                                        color: Color(0xFFFAD364),
                                        child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.symmetric(
                                                    vertical: 15.h),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  SizedBox(
                                                      height: circleRadius / 2),
                                                  Text(
                                                    (student.studentName ??
                                                            "Luu Minh Huong")
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                        fontSize: 18.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 2.h,
                                                  ),
                                                  const Text("STUDENT",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff51697E),
                                                          fontSize: 12.0)),
                                                  SizedBox(height: 32.h),
                                                  Divider(
                                                      endIndent: 40,
                                                      indent: 40,
                                                      thickness: 3.h,
                                                      color: Colors.white),
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 25.h,
                                                              horizontal: 30.w),
                                                      // color: const Color(0xffF5F7FD),
                                                      child:
                                                          Table(columnWidths: {
                                                        0: const FlexColumnWidth(),
                                                        1: FixedColumnWidth(
                                                            26.w),
                                                        2: const FlexColumnWidth(
                                                            2)
                                                      }, children: [
                                                        TableRow(children: [
                                                          Text("Parent:",
                                                              style:
                                                                  detailTextStyle),
                                                          const SizedBox
                                                              .shrink(),
                                                          Text(
                                                              student.parentName ??
                                                                  "",
                                                              style:
                                                                  detailTextStyle,
                                                              softWrap: false,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis)
                                                        ]),
                                                        TableRow(children: [
                                                          SizedBox(
                                                              height: 10.h),
                                                          const SizedBox
                                                              .shrink(),
                                                          const SizedBox
                                                              .shrink()
                                                        ]),
                                                        TableRow(children: [
                                                          Text("Teacher:",
                                                              style:
                                                                  detailTextStyle),
                                                          const SizedBox
                                                              .shrink(),
                                                          Text(
                                                              student.teacherName ??
                                                                  "",
                                                              style:
                                                                  detailTextStyle,
                                                              softWrap: false,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis)
                                                        ]),
                                                        TableRow(children: [
                                                          SizedBox(
                                                              height: 10.h),
                                                          const SizedBox
                                                              .shrink(),
                                                          const SizedBox
                                                              .shrink(),
                                                        ]),
                                                        TableRow(children: [
                                                          Text("Class:",
                                                              style:
                                                                  detailTextStyle),
                                                          const SizedBox
                                                              .shrink(),
                                                          Text(
                                                              student.className ??
                                                                  "",
                                                              style:
                                                                  detailTextStyle,
                                                              softWrap: false,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis)
                                                        ]),
                                                        TableRow(children: [
                                                          SizedBox(
                                                              height: 10.h),
                                                          const SizedBox
                                                              .shrink(),
                                                          const SizedBox
                                                              .shrink(),
                                                        ]),
                                                        TableRow(children: [
                                                          Text("Bus ID:",
                                                              style:
                                                                  detailTextStyle),
                                                          const SizedBox
                                                              .shrink(),
                                                          Text(
                                                              student.busId
                                                                      .toString() ??
                                                                  "",
                                                              style:
                                                                  detailTextStyle,
                                                              softWrap: false,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis)
                                                        ]),
                                                      ]))
                                                ])))),

                                ///Image Avatar
                                Container(
                                    width: circleRadius,
                                    height: circleRadius,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                                  .withOpacity(0.3),
                                              blurRadius: 10.0,
                                              offset: const Offset(0.0, 5.0))
                                        ]),
                                    child: Container(
                                        padding: const EdgeInsets.all(4.0),
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                    'assets/images/avt.png')))))
                              ]),
                          SizedBox(height: 50.h),
                        ]))
                  ])),
            );
          }),
    );
  }
}
