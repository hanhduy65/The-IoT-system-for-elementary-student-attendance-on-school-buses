import 'package:momentum/momentum.dart';

import '../models/attendance_model.dart';

class AttendanceController extends MomentumController<AttendanceModel> {
  @override
  init() {
    return AttendanceModel(this,
        busId: 0,
        isOnBus: false,
        startBus: "",
        studentId: "",
        studentName: "",
        rfidId: 0);
  }
}
