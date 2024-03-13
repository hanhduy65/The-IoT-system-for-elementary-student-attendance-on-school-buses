import 'package:momentum/momentum.dart';

import '../models/student_register_RFID_model.dart';
import '../services/student_service.dart';

class StudentRegisterRFIDListController
    extends MomentumController<StudentRegisterRFIDListModel> {
  @override
  init() {
    return StudentRegisterRFIDListModel(this,
        studentList: const [], isFetched: false);
  }

  Future<void> getStudentRegisterRFIDList(int busId) async {
    print("service + getStudentRegisterRFIDList");
    try {
      final studentService = service<StudentServices>();
      final fetchedStudentList =
          await studentService.getStudentRegisterRFID(busId);
      model.update(
        studentList: fetchedStudentList,
      );
    } catch (e) {
      print("get student register RFID error: $e");
    }
  }
}
