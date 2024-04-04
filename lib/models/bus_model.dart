import 'package:momentum/momentum.dart';

import '../controllers/bus_controller.dart';

class BusModel extends MomentumModel<BusController> {
  final bool? isRunning, isOnBus;
  final int? busId;
  final bool? isCalled;

  const BusModel(BusController controller,
      {this.busId, this.isRunning, this.isCalled, this.isOnBus})
      : super(controller);

  @override
  void update({bool? isRunning, bool? isOnBus, int? busId, bool? isCalled}) {
    // TODO: implement update
    BusModel(controller,
            busId: busId ?? this.busId,
            isRunning: isRunning ?? this.isRunning,
            isOnBus: isOnBus ?? this.isOnBus,
            isCalled: isCalled ?? this.isCalled)
        .updateMomentum();
  }

  @override
  Map<String, dynamic>? toJson() {
    return {"busId": busId, "isRunning": isRunning, "isOnBus": isOnBus};
  }

  @override
  BusModel fromJson(Map<String, dynamic>? json) {
    return BusModel(controller, busId: json?["bus_id"] ?? 0);
  }
}
