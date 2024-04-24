import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/attendance_model.dart';
import '../../models/item_history_attendance_teacher_today_model.dart';

class ItemTodayHistoryAttendance extends StatelessWidget {
  final List<AttendanceModel> list;
  const ItemTodayHistoryAttendance({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 1.sw,
          height: 1.sh,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/ombre_blue.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
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
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, indexx) => Card(
                      child: ListTile(
                        title: Text(list[indexx].studentName ?? " "),
                        subtitle: Column(
                          children: [
                            Text("Starting time: " + list[indexx].startBus!),
                            Text("Ending time: " + list[indexx].startBus!),
                          ],
                        ),
                      ),
                    )),
          ),
        )
      ],
    );
  }
}
