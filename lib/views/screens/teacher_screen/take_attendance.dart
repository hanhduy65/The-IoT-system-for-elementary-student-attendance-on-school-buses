import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:momentum/momentum.dart';
import 'package:busmate/controllers/bus_controller.dart';
import 'package:busmate/controllers/student_on_bus_list_controller.dart';
import 'package:busmate/models/student_on_bus_list_model.dart';
import 'package:busmate/views/screens/detail_student.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/user_model.dart';

class TakeAttendanceScreen extends StatefulWidget {
  final User? user;
  final int? busId;

  const TakeAttendanceScreen({super.key, this.user, this.busId});

  @override
  State<TakeAttendanceScreen> createState() => _TakeAttendanceScreenState();
}

class _TakeAttendanceScreenState extends MomentumState<TakeAttendanceScreen> {
  bool isStart = false;
  int _elapsedSeconds = 0;
  int takeAttended =
      -1; // -1 : chưa bắt đầu, 0: điểm danh lên, 1: điểm danh xuống

  void getDataIsStart() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool newStart = await sp.getBool("key_isStart") ?? false;
    setState(() {
      isStart = newStart;
    });
    print("isStart trong getDataIsStart là $isStart");
  }

  @override
  Widget build(BuildContext context) {
    print("Giá trị của busId trong màn ViewStudentData  ${widget.busId}");
    if (widget.busId != 0) {
      return MomentumBuilder(
          controllers: const [StudentOnBusListController],
          builder: (context, state) {
            final listStudents = state<StudentOnBusListModel>();
            if (!(listStudents.isFetched)!) {
              listStudents.controller.getStudentList(widget.busId!);
              listStudents.update(isFetched: true);
            }

            print("list students${listStudents.studentList}");
            return RefreshIndicator(
                onRefresh: () async {
                  listStudents.controller.getStudentList(widget.busId!);
                },
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/ombre_blue.jpg"),
                            fit: BoxFit.fill),
                      ),
                      height: 1.sh,
                    ),
                    Scaffold(
                        backgroundColor: Colors.transparent,
                        appBar: PreferredSize(
                          preferredSize: Size.fromHeight(60.0),
                          child: AppBar(
                            backgroundColor: Colors.transparent,
                            automaticallyImplyLeading: false,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hello, teacher",
                                  style: TextStyle(
                                      fontSize: 16.sp, color: Colors.black87),
                                ),
                                Text(
                                  widget.user?.fullName ?? "",
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            actions: const [
                              Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: CircleAvatar(
                                  radius: 30.0,
                                  backgroundImage:
                                      AssetImage("assets/image_avt/avt.jpg"),
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        body: Container(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
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
                                                              .studentList[
                                                                  index]
                                                              .isOnBus!
                                                          ? Theme.of(context)
                                                              .colorScheme
                                                              .secondary
                                                          : Theme.of(context)
                                                              .primaryColor,
                                                      child: ListTile(
                                                        title: Text(
                                                          listStudents
                                                                  .studentList[
                                                                      index]
                                                                  .studentName ??
                                                              "",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18.sp),
                                                        ),
                                                        subtitle: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Starting/Ending time : ${listStudents.studentList[index].startBus!}",
                                                            ),
                                                            Text(
                                                                "Id card: ${listStudents.studentList[index].rfidId.toString()!}"),
                                                          ],
                                                        ),
                                                        trailing: listStudents
                                                                .studentList[
                                                                    index]
                                                                .isOnBus!
                                                            ? const Icon(
                                                                Icons
                                                                    .arrow_upward,
                                                                color: Color(
                                                                    0xFF00EC00),
                                                              )
                                                            : const Icon(
                                                                Icons
                                                                    .arrow_downward,
                                                                color: Color(
                                                                    0xFFF0F400)),
                                                        leading: CircleAvatar(
                                                          radius: 30.0,
                                                          backgroundImage: index ==
                                                                  0
                                                              ? const AssetImage(
                                                                  "assets/image_avt/images1.jpg")
                                                              : index == 1
                                                                  ? AssetImage(
                                                                      "assets/image_avt/images2.jpg")
                                                                  : index == 2
                                                                      ? AssetImage(
                                                                          "assets/image_avt/images3.jpg")
                                                                      : index ==
                                                                              3
                                                                          ? AssetImage(
                                                                              "assets/image_avt/images4.jpg")
                                                                          : AssetImage(
                                                                              "assets/image_avt/images5.jpg"),
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => StudentDetail(
                                                                studentId: listStudents
                                                                    .studentList[
                                                                        index]
                                                                    .studentId!
                                                                    .toString())),
                                                      );
                                                    },
                                                  ),
                                                ))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        persistentFooterButtons: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  Momentum.controller<BusController>(context)
                                      .startOrEndBus(widget.busId!, true);
                                  setState(() {
                                    isStart = true;
                                    _elapsedSeconds = 0;
                                    print("set lại state con isStart là true");
                                  });
                                  _startTimer();
                                },
                                child: Image.asset(
                                  "assets/icons/icon_start_green_grey.png",
                                  width: 80,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (isStart) {
                                    setState(() {
                                      if (takeAttended == -1) {
                                        takeAttended = 0;
                                      } else if (takeAttended == 0) {
                                        takeAttended = 1;
                                      } else {
                                        takeAttended = -1;
                                      }
                                    });
                                  }
                                  if (takeAttended == 0) {
                                    Momentum.controller<BusController>(context)
                                        .CheckAttendanceGetInOrOutBus(
                                            widget.busId!, true);
                                  } else if (takeAttended == 1) {
                                    Momentum.controller<BusController>(context)
                                        .CheckAttendanceGetInOrOutBus(
                                            widget.busId!, false);
                                  }
                                },
                                child: Card(
                                  color: Theme.of(context).primaryColor,
                                  // elevation: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, right: 16, top: 5),
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          takeAttended == -1
                                              ? Image.asset(
                                                  "assets/icons/icon_attendance.png",
                                                  width: 50)
                                              : takeAttended == 0
                                                  ? Text(
                                                      "${formatNumber(listStudents.studentsOnBusCount!)}/${formatNumber(listStudents.studentList.length)}",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF3947D5),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 28))
                                                  : Text(
                                                      "${formatNumber(listStudents.studentsOffBusCount!)}/${formatNumber(listStudents.studentList.length)}",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF3947D5),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 28)),
                                          SizedBox(
                                            height: 4.h,
                                          ),
                                          takeAttended == -1
                                              ? const Text(
                                                  "CHECK",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              : takeAttended == 0
                                                  ? const Text(
                                                      "GET IN",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  : const Text(
                                                      "GET OUT",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              /*
                                                    FloatingActionButton.extended(
                          onPressed: () {
                            setState(() {
                              isClickButton = true;
                              isCheckGetIn = !isCheckGetIn;
                            });
                            if (isCheckGetIn) {
                              Momentum.controller<BusController>(context)
                                  .CheckAttendanceGetInOrOutBus(
                                      widget.busId!, true);
                            } else {
                              Momentum.controller<BusController>(context)
                                  .CheckAttendanceGetInOrOutBus(
                                      widget.busId!, false);
                            }
                          },
                          icon: !isClickButton
                              ? Image.asset(
                                  "assets/icons/icon_attendance.png",
                                  width: 40)
                              : isCheckGetIn
                                  ? const Icon(
                                      Icons.arrow_downward,
                                      color: Colors.white,
                                    )
                                  : const Icon(
                                      Icons.arrow_upward,
                                      color: Colors.white,
                                    ),
                          label: !isClickButton
                              ? const Text("Attendance",
                                  style: TextStyle(color: Colors.white))
                              : isCheckGetIn
                                  ? const Text("Điểm danh xuống",
                                      style: TextStyle(color: Colors.white))
                                  : const Text("Điểm danh lên",
                                      style: TextStyle(color: Colors.white)),
                          backgroundColor: Color(0xFF58952D),
                                                    ),

                                                     */
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    takeAttended = -1;
                                    isStart = false;
                                    print("set lại state con isStart là false");
                                  });
                                  Momentum.controller<BusController>(context)
                                      .startOrEndBus(widget.busId!, false);
                                },
                                child: Image.asset(
                                  "assets/icons/icon_finish_green_grey.png",
                                  width: 85,
                                ),
                              ),
                            ],
                          )
                        ])
                  ],
                ));
          });
    }
    return const Center(child: Text("Không có lịch trình hôm nay"));
  }

  @override
  void initMomentumState() {
    // TODO: implement initMomentumState
    super.initMomentumState();
    getDataIsStart();
  }

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (isStart && _elapsedSeconds < 150) {
        Momentum.controller<StudentOnBusListController>(context)
            .getStudentList(widget.busId!);
        setState(() {
          _elapsedSeconds += 5;
        });
        print(" time đang chạy $_elapsedSeconds");
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("có vào didChangeDependencies");
    getDataIsStart();
  }
}

String formatNumber(int number) {
  return number < 10 ? '0$number' : number.toString();
}
