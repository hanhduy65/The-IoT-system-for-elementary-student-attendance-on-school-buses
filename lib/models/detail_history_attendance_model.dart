import 'package:momentum/momentum.dart';

class DetailHistoryAttendanceModel {
  final String? eventType, timestamp;
  const DetailHistoryAttendanceModel({this.eventType, this.timestamp});

  factory DetailHistoryAttendanceModel.fromJson(Map<String, dynamic>? json) {
    return DetailHistoryAttendanceModel(
        eventType: json?["event_type"] ?? " ",
        timestamp: json?["timestamp"] ?? " ");
  }
}
