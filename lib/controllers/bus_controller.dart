import 'package:momentum/momentum.dart';

import '../events/login_events.dart';
import '../models/bus_model.dart';
import '../services/bus_service.dart';

class BusController extends MomentumController<BusModel> {
  @override
  BusModel init() {
    return BusModel(this, busId: 0, isRunning: false, isCalled: false);
  }

  Future<void> getBusId(String teacherId) async {
    try {
      final busService = service<BusServices>();
      final fetchedBus = await busService.getBusIdBySupervior(teacherId);
      model.update(
          busId: fetchedBus.busId ?? 0,
          isRunning: fetchedBus.isRunning ?? false);
      print("busController: model " + model.busId.toString());
    } catch (e) {
      print("get bus id error: $e");
    }
  }

  Future<void> startOrEndBus(int busId, bool isRunning) async {
    try {
      final busService = service<BusServices>();
      final profile = await busService.StartOrEndBus(busId, isRunning);
      sendEvent(AuthEvent(
          action: profile.isAuthSuccessful,
          message: profile.authResponseMessage));
    } catch (e) {
      print("start or end bus error: $e");
    }
  }

  Future<void> CheckAttendanceGetInOrOutBus(int busId, bool isOnBus) async {
    try {
      final busService = service<BusServices>();
      final profile =
          await busService.CheckAttendanceGetInOrOutBus(busId, isOnBus);
      sendEvent(AuthEvent(
          action: profile.isAuthSuccessful,
          message: profile.authResponseMessage));
    } catch (e) {
      print("check attendance get in/ out bus: $e");
    }
  }
}
