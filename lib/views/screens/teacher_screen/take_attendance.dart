import 'dart:async';

import 'package:busmate/controllers/save_attendance_history_response_controller.dart';
import 'package:busmate/controllers/take_attendance_response_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:momentum/momentum.dart';
import 'package:busmate/controllers/bus_controller.dart';
import 'package:busmate/controllers/student_on_bus_list_controller.dart';
import 'package:busmate/models/student_on_bus_list_model.dart';
import 'package:busmate/views/screens/detail_student.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../events/events.dart';
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
  Map<String, bool> studentSelections = {};
  List<String> studentIdList = [];
  int numberStuChecked = 0;
  int numberStuNotChecked = 0;
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
                                                      child: CheckboxListTile(
                                                        title: Row(
                                                          children: [
                                                            CircleAvatar(
                                                              radius: 30.0,
                                                              backgroundImage: index ==
                                                                      0
                                                                  ? const AssetImage(
                                                                      "assets/image_avt/images1.jpg")
                                                                  : index == 1
                                                                      ? AssetImage(
                                                                          "assets/image_avt/images2.jpg")
                                                                      : index ==
                                                                              2
                                                                          ? AssetImage(
                                                                              "assets/image_avt/images3.jpg")
                                                                          : index == 3
                                                                              ? AssetImage("assets/image_avt/images4.jpg")
                                                                              : AssetImage("assets/image_avt/images5.jpg"),
                                                            ),
                                                            SizedBox(
                                                              width: 10.w,
                                                            ),
                                                            Text(
                                                              listStudents
                                                                      .studentList[
                                                                          index]
                                                                      .studentName ??
                                                                  "",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      18.sp),
                                                            ),
                                                          ],
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
                                                        value: studentSelections[
                                                                listStudents
                                                                    .studentList[
                                                                        index]
                                                                    .studentId] ??
                                                            false,
                                                        onChanged:
                                                            (bool? value) {
                                                          if (takeAttended !=
                                                              -1) {
                                                            setState(() {
                                                              studentSelections[
                                                                  listStudents
                                                                      .studentList[
                                                                          index]
                                                                      .studentId!] = value!;
                                                            });
                                                          }
                                                        },
                                                        activeColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .secondary,
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
                                    SizedBox(height: 50.h),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        floatingActionButton: Visibility(
                          visible: studentSelections.isNotEmpty,
                          child: FloatingActionButton(
                            onPressed: () {
                              print(studentSelections);
                              studentSelections.forEach((key, value) {
                                if (value) {
                                  studentIdList.add(key);
                                }
                              });
                              print(studentIdList);
                              Momentum.controller<
                                      TakeAttendanceResponseController>(context)
                                  .doTakeAttendance(studentIdList);
                              setState(() {
                                studentSelections = {};
                                studentIdList = [];
                              });
                            },
                            child: Icon(Icons.check),
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
                                        setState(() {
                                          numberStuChecked =
                                              listStudents.studentsOnBusCount!;
                                          numberStuNotChecked =
                                              listStudents.studentsOffBusCount!;
                                        });
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
                                                          fontSize: 26.sp))
                                                  : Text(
                                                      "${formatNumber(listStudents.studentsOffBusCount! - numberStuNotChecked)}/${formatNumber(numberStuChecked)}",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF3947D5),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 26.sp)),
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
                                  if (numberStuChecked ==
                                      listStudents.studentsOffBusCount! -
                                          numberStuNotChecked) {
                                    setState(() {
                                      takeAttended = -1;
                                      isStart = false;
                                      print(
                                          "set lại state con isStart là false");

                                      studentSelections = {};
                                      studentIdList = [];
                                    });
                                    Momentum.controller<BusController>(context)
                                        .startOrEndBus(widget.busId!, false);
                                    Momentum.controller<
                                                SaveAttendanceHistoryResponseController>(
                                            context)
                                        .doSaveAttendanceHistoryReport(
                                            widget.user!.userId!,
                                            widget.busId!);
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Center(
                                              child: Text(
                                            'Warning !!!',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          )),
                                          content: const Text(
                                              'There are still students who havent gotten off the bus yet.'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Close'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
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
    final registerController =
        Momentum.controller<TakeAttendanceResponseController>(context);
    registerController.listen<TakeAttendanceEvent>(
      state: this,
      invoke: (event) {
        switch (event.action) {
          case true:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Take attendance successful'),
                backgroundColor: Colors.green, // Thay đổi màu sắc ở đây
              ),
            );
            break;
          case false:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Take attendance fail'),
                backgroundColor: Colors.red, // Thay đổi màu sắc ở đây
              ),
            );
            break;
          case null:
            print(event.message);
            break;
          default:
        }
      },
    );
  }

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (isStart && _elapsedSeconds < 300) {
        Momentum.controller<StudentOnBusListController>(context)
            .getStudentList(widget.busId!);
        setState(() {
          _elapsedSeconds += 2;
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
