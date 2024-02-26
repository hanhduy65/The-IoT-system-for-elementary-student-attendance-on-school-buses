import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:momentum/momentum.dart';

import '../models/student_on_bus_list_model.dart';
import '../services/student_service.dart';

class StudentOnBusListController
    extends MomentumController<StudentOnBusListModel> {
  @override
  init() {
    return StudentOnBusListModel(this, studentList: const [], isFetched: false);
  }

  Future<void> getStudentList(int busId) async {
    //   bool hasInternet = await InternetConnectionChecker().hasConnection;
    //   if (hasInternet) {
    //     try {
    //       final studentService = service<StudentServices>();
    //       final fetchedStudentList = await studentService.getStudentOnBus();
    //       model.update(
    //         studentList: fetchedStudentList,
    //       );
    //     } catch (e) {
    //       print("search customer list error: $e");
    //     }
    //   } else {
    //     sendEvent(AuthEvent(action: false, message: "No internet connection"));
    //   }
    // }

    try {
      final studentService = service<StudentServices>();
      final fetchedStudentList = await studentService.getStudentOnBus(busId);
      model.update(
        studentList: fetchedStudentList,
      );
    } catch (e) {
      print("get student on bus list error: $e");
    }
  }
}
