import 'package:momentum/momentum.dart';

import '../models/student_on_bus_list_model.dart';
import '../services/student_service.dart';

class StudentOnBusListController
    extends MomentumController<StudentOnBusListModel> {
  @override
  init() {
    return StudentOnBusListModel(this,
        studentList: const [],
        isFetched: false,
        isLoading: true,
        studentsOffBusCount: 0,
        studentsOnBusCount: 0);
  }

  Future<void> getStudentList(int busId) async {
    print("get list student on bus");
    model.update(isLoading: true);
    try {
      final studentService = service<StudentServices>();
      final fetchedStudentList = await studentService.getStudentOnBus(busId);
      model.update(
          studentList: fetchedStudentList.studentList,
          isLoading: false,
          studentsOnBusCount: fetchedStudentList.studentsOnBusCount,
          studentsOffBusCount: fetchedStudentList.studentsOffBusCount);
    } catch (e) {
      print("get student on bus list error: $e");
    }
  }
}
