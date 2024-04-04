import 'package:momentum/momentum.dart';

import '../models/student_register_fingerprint_model.dart';
import '../services/student_service.dart';

class StudentRegisterFingerprintListController
    extends MomentumController<StudentRegisterFingerprintListModel> {
  @override
  init() {
    return StudentRegisterFingerprintListModel(this,
        studentList: const [], isFetched: false, isLoading: true);
  }

  Future<void> getStudentRegisterFingerprintList(int busId) async {
    print("service + getStudentRegisterFingerprintList");
    model.update(isLoading: true);
    try {
      final studentService = service<StudentServices>();
      final fetchedStudentList =
          await studentService.getStudentRegisterFingerprint(busId);
      model.update(studentList: fetchedStudentList, isLoading: false);
    } catch (e) {
      print("get student register Fingerprint error: $e");
    }
  }
}
