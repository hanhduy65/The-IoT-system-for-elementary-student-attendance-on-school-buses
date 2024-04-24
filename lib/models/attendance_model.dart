import 'package:momentum/momentum.dart';

import '../controllers/attendance_controller.dart';

class AttendanceModel extends MomentumModel<AttendanceController> {
  final int? busId, rfidId;
  final String? startBus, studentName, studentId, endBus;
  final bool? isOnBus;

  const AttendanceModel(AttendanceController controller,
      {this.busId,
      this.studentId,
      this.isOnBus,
      this.startBus,
      this.endBus,
      this.rfidId,
      this.studentName})
      : super(controller);

  @override
  void update() {}

  @override
  AttendanceModel fromJson(Map<String, dynamic>? json) {
    return AttendanceModel(
      controller,
      busId: json?["bus_id"],
      studentId: json?["student_id"],
      startBus: json?["start_bus"],
      endBus: json?["end_bus"] ?? " ",
      isOnBus: json?["is_on_bus"],
      studentName: json?["student_name"],
      rfidId: json?["rfid_id"],
    );
  }
}
