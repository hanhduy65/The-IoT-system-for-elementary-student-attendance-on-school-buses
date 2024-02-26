import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:momentum/momentum.dart';
import 'package:school_bus_attendance_test/controllers/bus_controller.dart';
import 'package:school_bus_attendance_test/controllers/student_on_bus_list_controller.dart';
import 'package:school_bus_attendance_test/models/student_on_bus_list_model.dart';
import 'package:school_bus_attendance_test/views/screens/detail_student.dart';

import '../../models/user_model.dart';

class ViewStudentData extends StatefulWidget {
  final User? user;
  final int? busId;

  const ViewStudentData({super.key, this.user, this.busId});

  @override
  State<ViewStudentData> createState() => _ViewStudentDataState();
}

class _ViewStudentDataState extends MomentumState<ViewStudentData> {
  bool isStart = false;

  @override
  Widget build(BuildContext context) {
    if (widget.busId != 0) {
      return MomentumBuilder(
          controllers: const [StudentOnBusListController],
          builder: (context, state) {
            final listStudents = state<StudentOnBusListModel>();
            if (!listStudents.isFetched) {
              listStudents.controller.getStudentList(widget.busId!);
              setState(() {
                listStudents.isFetched = true;
              });
            }
            print("list students${listStudents.studentList}");

            return Scaffold(
                body: RefreshIndicator(
              onRefresh: () async {
                listStudents.controller.getStudentList(widget.busId!);
              },
              // child: listStudents.studentList.isEmpty
              //     ? const Text("Chưa có dữ liệu")
              //     : SafeArea(
              //         child: ListView.builder(
              //             itemCount: listStudents.studentList.length,
              //             itemBuilder: (context, index) => Padding(
              //                   padding: EdgeInsets.symmetric(horizontal: 10.w),
              //                   child: InkWell(
              //                     child: Card(
              //                       child: ListTile(
              //                         title: Text(listStudents
              //                                 .studentList[index].studentName ??
              //                             ""),
              //                         subtitle: Column(
              //                           crossAxisAlignment:
              //                               CrossAxisAlignment.start,
              //                           children: [
              //                             Text(
              //                                 "Giờ lên xe: ${listStudents.studentList[index].startBus!}"),
              //                             Text(
              //                                 "Id card: ${listStudents.studentList[index].rfidId.toString()!}"),
              //                           ],
              //                         ),
              //                       ),
              //                     ),
              //                     onTap: () {
              //                       Navigator.push(
              //                         context,
              //                         MaterialPageRoute(
              //                             builder: (context) => StudentDetail(
              //                                 studentId: listStudents
              //                                     .studentList[index]
              //                                     .studentId!)),
              //                       );
              //                     },
              //                   ),
              //                 ))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Momentum.controller<BusController>(context)
                          .startOrEndBus(widget.busId!, true);
                      setState(() {
                        isStart = true;
                      });
                    },
                    child: const Text("Bắt đầu chuyến đi"),
                  ),
                  SizedBox(height: 10.h),
                  Visibility(
                      visible: isStart,
                      child: Container(
                        height: 1.sh * 1 / 2,
                        child: SafeArea(
                            child: ListView.builder(
                                itemCount: listStudents.studentList.length,
                                itemBuilder: (context, index) => Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      child: InkWell(
                                        child: Card(
                                          color: listStudents
                                                  .studentList[index].isOnBus!
                                              ? Color(0xFF58952D)
                                              : Color(0xFFECAB33),
                                          child: ListTile(
                                            title: Text(listStudents
                                                    .studentList[index]
                                                    .studentName ??
                                                ""),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "Giờ lên/xuống xe: ${listStudents.studentList[index].startBus!}"),
                                                Text(
                                                    "Id card: ${listStudents.studentList[index].rfidId.toString()!}"),
                                              ],
                                            ),
                                            leading: listStudents
                                                    .studentList[index].isOnBus!
                                                ? Icon(Icons.arrow_upward)
                                                : Icon(Icons.arrow_downward),
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    StudentDetail(
                                                        studentId: listStudents
                                                            .studentList[index]
                                                            .studentId!
                                                            .toString())),
                                          );
                                        },
                                      ),
                                    ))),
                      )),
                  SizedBox(height: 10.h),
                  Visibility(
                    visible: isStart,
                    child: ElevatedButton(
                      onPressed: () {
                        Momentum.controller<BusController>(context)
                            .startOrEndBus(widget.busId!, false);
                        setState(() {
                          isStart = false;
                        });
                      },
                      child: const Text("Kết thúc chuyến đi"),
                    ),
                  ),
                ],
              ),
            ));
          });
    }
    return const Scaffold(
      body: Center(
        child: Text("Không có lịch điểm danh đưa đón hôm nay"),
      ),
    );
  }
}
