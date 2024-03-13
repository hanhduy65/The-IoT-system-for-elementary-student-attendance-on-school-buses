import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';
import 'package:school_bus_attendance_test/views/screens/parent_screen/view_attandance_history.dart';

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
    if (widget.studentId != null) {
      return Scaffold(
        body: Center(
          child: Column(
            children: [
              Text(widget.studentId ?? " ùhewuf"),
              Text(widget.user.userName!),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewAttendanceHistory(
                                studentId: widget.studentId,
                              )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: Color(0xFFECAB33),
                      elevation: 0),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 80.0, vertical: 10),
                    child: Text("Xem lịch sử điểm danh",
                        style: TextStyle(
                            color: Color(0xFF58952D),
                            fontWeight: FontWeight.bold)),
                  ))
            ],
          ),
        ),
      );
    }
    return Center();
  }
}
