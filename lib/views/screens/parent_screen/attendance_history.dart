import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:momentum/momentum.dart';
import 'package:busmate/views/screens/parent_screen/view_attandance_history.dart';

import '../../../controllers/list_history_attendance_controller.dart';
import '../../../models/list_history_attendance_model.dart';
import '../../../models/user_model.dart';

class AttendanceHistory extends StatefulWidget {
  final User user;
  final String? studentId;

  const AttendanceHistory({super.key, required this.user, this.studentId});

  @override
  State<AttendanceHistory> createState() => _AttendanceHistoryState();
}

class _AttendanceHistoryState extends State<AttendanceHistory> {
  @override
  Widget build(BuildContext context) {
    print("widget.studentId " + widget.studentId.toString());
    if (widget.studentId != null) {
      return MomentumBuilder(
          controllers: const [ListHistoryAttendanceController],
          builder: (context, state) {
            final listAttandance = state<ListHistoryAttendanceModel>();
            if (!listAttandance.isFetched) {
              listAttandance.controller.getAttendanceList(widget.studentId!);
              listAttandance.update(isFetched: true);
            }
            print(
                "list attandance ${listAttandance.attendanceList.toString()}");

            return RefreshIndicator(
              onRefresh: () async {
                listAttandance.controller.getAttendanceList(widget.studentId!);
              },
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(60.0),
                  child: AppBar(
                    backgroundColor: Color(0xFFECAB33),
                    automaticallyImplyLeading: false,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, parent",
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.white70),
                        ),
                        Text(
                          "Le Duc Minh",
                          style: TextStyle(
                              fontSize: 20.sp,
                              color: Theme.of(context).colorScheme.secondary,
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
                              AssetImage('assets/image_avt/avt_parent.jpg'),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: listAttandance.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Text(
                              "Xem lịch sử điểm danh",
                              style: TextStyle(
                                  fontSize: 18.sp, fontWeight: FontWeight.bold),
                            )),
                            SizedBox(height: 10.h),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: listAttandance.attendanceList.length,
                              itemBuilder: (context, index) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    listAttandance.attendanceList[index].date ??
                                        "",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      itemCount: (listAttandance
                                                  .attendanceList[index]
                                                  .listHistoryAttend!
                                                  .length /
                                              2)
                                          .ceil(),
                                      itemBuilder: (context, indexx) => Row(
                                            children: [
                                              Expanded(
                                                child: Card(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15,
                                                            vertical: 12),
                                                    child: Column(
                                                      children: [
                                                        Text(listAttandance
                                                            .attendanceList[
                                                                index]
                                                            .listHistoryAttend![
                                                                indexx * 2]
                                                            .eventType!),
                                                        Text(listAttandance
                                                            .attendanceList[
                                                                index]
                                                            .listHistoryAttend![
                                                                indexx * 2]
                                                            .timestamp!),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10.w),
                                              indexx * 2 + 1 <
                                                      listAttandance
                                                          .attendanceList[index]
                                                          .listHistoryAttend!
                                                          .length
                                                  ? Expanded(
                                                      child: Card(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 15,
                                                                vertical: 12),
                                                        child: Column(
                                                          children: [
                                                            Text(listAttandance
                                                                .attendanceList[
                                                                    index]
                                                                .listHistoryAttend![
                                                                    indexx * 2 +
                                                                        1]
                                                                .eventType!),
                                                            Text(listAttandance
                                                                .attendanceList[
                                                                    index]
                                                                .listHistoryAttend![
                                                                    indexx * 2 +
                                                                        1]
                                                                .timestamp!),
                                                          ],
                                                        ),
                                                      ),
                                                    ))
                                                  : Expanded(child: SizedBox())
                                            ],
                                          ))
                                ],
                              ),
                            ),
                          ],
                        )),
                ),
              ),
            );
          });
    }
    return Center();
  }
}
