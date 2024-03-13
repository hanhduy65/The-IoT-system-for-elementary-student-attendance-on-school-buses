import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';

import '../../../controllers/list_history_attendance_controller.dart';
import '../../../models/list_history_attendance_model.dart';
import '../../../models/user_model.dart';

class ViewAttendanceHistory extends StatefulWidget {
  final String? studentId;

  const ViewAttendanceHistory({super.key, this.studentId});

  @override
  State<ViewAttendanceHistory> createState() => _ViewAttendanceHistoryState();
}

class _ViewAttendanceHistoryState extends State<ViewAttendanceHistory> {
  @override
  Widget build(BuildContext context) {
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
                appBar: AppBar(title: Text("Xem lịch sử điểm danh")),
                body: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Visibility(
                      visible: listAttandance.isFetched,
                      child: SingleChildScrollView(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                    itemCount: listAttandance
                                        .attendanceList[index]
                                        .listHistoryAttend!
                                        .length,
                                    itemBuilder: (context, indexx) => Card(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 12),
                                            child: Column(
                                              children: [
                                                Text(listAttandance
                                                    .attendanceList[index]
                                                    .listHistoryAttend![indexx]
                                                    .eventType!),
                                                Text(listAttandance
                                                    .attendanceList[index]
                                                    .listHistoryAttend![indexx]
                                                    .timestamp!),
                                              ],
                                            ),
                                          ),
                                        ))
                              ],
                            ),
                          ),
                        ],
                      ))),
                ),
              ),
            );
          });
    }
    return Center();
  }
}
