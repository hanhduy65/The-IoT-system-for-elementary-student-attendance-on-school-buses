import 'package:momentum/momentum.dart';
import 'package:school_bus_attendance_test/models/register_model.dart';

import '../controllers/bus_controller.dart';
import '../controllers/register_controller.dart';
import '../models/bus_model.dart';
import '../utils/global.dart';
import 'general_api_service.dart';

class BusServices extends MomentumService {
  Future<BusModel> getBusIdBySupervior(String teacherId) async {
    String url = "$serverURL/getBusIdBySupervior";
    print("Có vào đây");
    // print(requestModel.toJson());
    try {
      final response =
          await httpService.post(url, body: {"supervisorId": teacherId});
      print(response);
      BusModel bus = BusController().init();
      return bus.fromJson(response);
    } on Exception catch (e, stackTrace) {
      print("get bus error: $e");
      print("Stack trace: $stackTrace");
      return BusModel(BusController());
    }
  }

  Future<AuthRegisterResponse> StartOrEndBus(int busId, bool isRunning) async {
    String url = "$serverURL/isRunning";
    // print(requestModel.toJson());
    try {
      final response = await httpService
          .post(url, body: {"busId": busId, "isRunning": isRunning});
      print(response);
      AuthRegisterResponse rp = AuthRegisterResponseController().init();
      return rp.fromJson(response);
    } on Exception catch (e, stackTrace) {
      print("start/end bus error: $e");
      print("Stack trace: $stackTrace");
      return AuthRegisterResponse(AuthRegisterResponseController());
    }
  }
}
