import 'package:momentum/momentum.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/network_controller.dart';

class NetworkConnectionModel extends MomentumModel<NetworkController> {
  final ConnectivityResult connectionStatus;
  final bool isDisconnected;

  const NetworkConnectionModel(NetworkController controller,
      {required this.connectionStatus, this.isDisconnected = false})
      : super(controller);

  @override
  void update({ConnectivityResult? connectionStatus, bool? isDisconnected}) {
    NetworkConnectionModel(controller,
            connectionStatus: connectionStatus ?? this.connectionStatus,
            isDisconnected: isDisconnected ?? this.isDisconnected)
        .updateMomentum();
  }
}
