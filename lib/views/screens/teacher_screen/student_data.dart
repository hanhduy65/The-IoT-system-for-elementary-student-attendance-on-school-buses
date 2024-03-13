import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:momentum/momentum.dart';
import 'package:school_bus_attendance_test/controllers/bus_controller.dart';
import 'package:school_bus_attendance_test/controllers/student_on_bus_list_controller.dart';
import 'package:school_bus_attendance_test/models/student_on_bus_list_model.dart';
import 'package:school_bus_attendance_test/views/screens/detail_student.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/user_model.dart';

class ViewStudentData extends StatefulWidget {
  final User? user;
  final int? busId;

  const ViewStudentData({super.key, this.user, this.busId});

  @override
  State<ViewStudentData> createState() => _ViewStudentDataState();
}

class _ViewStudentDataState extends MomentumState<ViewStudentData> {
  bool isStart = false;
  late Future<bool> _delayedFuture;

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    _delayedFuture = delayedFuture();
  }

  void getDataIsStart() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool newStart = await sp.getBool("key_isStart") ?? false;
    setState(() {
      isStart = newStart;
    });
    print("isStart trong getDataIsStart là $isStart");
  }

  Future<bool> delayedFuture() async {
    return Future.delayed(Duration(seconds: 2), () => true);
  }

  @override
  Widget build(BuildContext context) {
    print("Giá trị của busId trong màn ViewStudentData  ${widget.busId}");
    return FutureBuilder(
      future: _delayedFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Hiển thị widget loading khi đang chờ future hoàn thành
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Xử lý lỗi nếu có
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          if (widget.busId != 0) {
            return MomentumBuilder(
                controllers: const [StudentOnBusListController],
                builder: (context, state) {
                  final listStudents = state<StudentOnBusListModel>();
                  if (!listStudents.isFetched) {
                    listStudents.controller.getStudentList(widget.busId!);
                    listStudents.update(isFetched: true);
                  }
                  print("list students${listStudents.studentList}");
                  return FutureBuilder(
                    future: _delayedFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Hiển thị widget loading khi đang chờ future hoàn thành
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        // Xử lý lỗi nếu có
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        // Hiển thị widget chính sau khi future hoàn thành
                        return RefreshIndicator(
                            onRefresh: () async {
                              listStudents.controller
                                  .getStudentList(widget.busId!);
                            },
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Momentum.controller<BusController>(
                                                context)
                                            .startOrEndBus(widget.busId!, true);
                                        setState(() {
                                          isStart = true;
                                          print(
                                              "set lại state con isStart là true");
                                        });
                                      },
                                      child: const Text("Bắt đầu chuyến đi"),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Visibility(
                                      visible: isStart,
                                      child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              listStudents.studentList.length,
                                          itemBuilder: (context, index) =>
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.w),
                                                child: InkWell(
                                                  child: Card(
                                                    color: listStudents
                                                            .studentList[index]
                                                            .isOnBus!
                                                        ? Color(0xFF58952D)
                                                        : Color(0xFFECAB33),
                                                    child: ListTile(
                                                      title: Text(listStudents
                                                              .studentList[
                                                                  index]
                                                              .studentName ??
                                                          ""),
                                                      subtitle: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              "Giờ lên/xuống xe: ${listStudents.studentList[index].startBus!}"),
                                                          Text(
                                                              "Id card: ${listStudents.studentList[index].rfidId.toString()!}"),
                                                        ],
                                                      ),
                                                      leading: listStudents
                                                              .studentList[
                                                                  index]
                                                              .isOnBus!
                                                          ? Icon(Icons
                                                              .arrow_upward)
                                                          : Icon(Icons
                                                              .arrow_downward),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              StudentDetail(
                                                                  studentId: listStudents
                                                                      .studentList[
                                                                          index]
                                                                      .studentId!
                                                                      .toString())),
                                                    );
                                                  },
                                                ),
                                              ))),
                                  SizedBox(height: 10.h),
                                  Visibility(
                                    visible: isStart,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Momentum.controller<BusController>(
                                                context)
                                            .startOrEndBus(
                                                widget.busId!, false);
                                        setState(() {
                                          isStart = false;
                                          print(
                                              "set lại state con isStart là false");
                                        });
                                      },
                                      child: const Text("Kết thúc chuyến đi"),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                ],
                              ),
                            ));
                      }
                    },
                  );
                });
          }
          return const Center(child: Text("Không có lịch trình hôm nay"));
        }
      },
    );
  }

  // @override
  // Future<void> dispose() async {
  //   // TODO: implement dispose
  //   super.dispose();
  //   getDataIsStart();
  // }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("có vào didChangeDependencies");
    getDataIsStart();
  }
}
