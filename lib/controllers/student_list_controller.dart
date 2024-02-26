import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:momentum/momentum.dart';

import '../events/login_events.dart';
import '../models/student_list_model.dart';
import '../services/student_service.dart';

class StudentListController extends MomentumController<StudentListModel> {
  @override
  init() {
    return StudentListModel(this, studentList: const []);
  }

  Future<void> getStudentList() async {
    // bool hasInternet = await InternetConnectionChecker().hasConnection;
    // if (hasInternet) {
    //   try {
    //     final studentService = service<StudentServices>();
    //     final fetchedStudentList = await studentService.getAllStudent();
    //     model.update(
    //       studentList: fetchedStudentList,
    //     );
    //   } catch (e) {
    //     print("search customer list error: $e");
    //   }
    // } else {
    //   sendEvent(AuthEvent(action: false, message: "No internet connection"));
    // }
    try {
      final studentService = service<StudentServices>();
      final fetchedStudentList = await studentService.getAllStudent();
      model.update(
        studentList: fetchedStudentList,
      );
    } catch (e) {
      print("search customer list error: $e");
    }
  }
}
