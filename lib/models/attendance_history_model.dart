import 'package:school_bus_attendance_test/models/detail_history_attendance_model.dart';

class HistoryAttendanceModel {
  final String? date;
  final List<DetailHistoryAttendanceModel>? listHistoryAttend;

  const HistoryAttendanceModel({this.date, this.listHistoryAttend});

  factory HistoryAttendanceModel.fromJson(Map<String, dynamic>? json) {
    return HistoryAttendanceModel(
        date: json?["date"] ?? " ",
        listHistoryAttend: json?["history"] != null
            ? List.from(json?["history"])
                .map((e) => DetailHistoryAttendanceModel.fromJson(e))
                .toList()
            : null);
  }
}
