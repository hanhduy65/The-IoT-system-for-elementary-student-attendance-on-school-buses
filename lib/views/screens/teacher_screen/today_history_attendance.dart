import 'package:busmate/controllers/list_history_attendance_teacher_today_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:momentum/momentum.dart';

import '../../../models/list_history_attendance_teacher_today_model.dart';
import '../../../models/user_model.dart';
import '../../widgets/item_today_history_attendance.dart';

class TodayHistoryAttendance extends StatefulWidget {
  final User? user;
  const TodayHistoryAttendance({super.key, this.user});

  @override
  State<TodayHistoryAttendance> createState() => _TodayHistoryAttendanceState();
}

class _TodayHistoryAttendanceState extends State<TodayHistoryAttendance> {
  Widget build(BuildContext context) {
    if (widget.user?.userId != null) {
      return MomentumBuilder(
          controllers: const [ListHistoryAttendanceTeacherController],
          builder: (context, state) {
            final listAttandance = state<ListHistoryAttendanceTeacherModel>();
            if (!listAttandance.isFetched!) {
              listAttandance.controller
                  .getBusAttendanceReport(widget.user!.userId!);
              listAttandance.update(isFetched: true);
            }
            print(
                "list attandance ${listAttandance.listAttendance.toString()}");

            return RefreshIndicator(
              onRefresh: () async {
                listAttandance.controller
                    .getBusAttendanceReport(widget.user!.userId!);
              },
              child: Scaffold(
                body: Container(
                  width: 1.sw,
                  height: 1.sh,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/ombre_blue.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: listAttandance.isLoading!
                      ? const Center(child: CircularProgressIndicator())
                      : Scaffold(
                          backgroundColor: Colors.transparent,
                          appBar: AppBar(
                            backgroundColor: Colors.transparent,
                            centerTitle: true,
                            title: Text(
                              "History Attendance Today",
                              style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          body: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: SingleChildScrollView(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // SizedBox(height: 10.h),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount:
                                      listAttandance.listAttendance.length,
                                  itemBuilder: (context, index) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ItemTodayHistoryAttendance(
                                                      list: listAttandance
                                                          .listAttendance[index]
                                                          .studentList!,
                                                    )),
                                          );
                                        },
                                        child: Card(
                                          child: ListTile(
                                            leading: Text(
                                              (index + 1).toString(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                            title: Text(" Attendanced in bus " +
                                                    listAttandance
                                                        .listAttendance[index]
                                                        .studentList[0]
                                                        .busId
                                                        .toString() ??
                                                " "),
                                            trailing:
                                                Icon(Icons.arrow_forward_ios),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                          ),
                        ),
                ),
              ),
            );
          });
    }
    return Center(
      child: Text("Chưa có lịch sử điểm danh hôm nay"),
    );
  }
}
