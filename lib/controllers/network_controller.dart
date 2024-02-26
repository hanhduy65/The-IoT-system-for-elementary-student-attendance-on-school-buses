// import 'package:momentum/momentum.dart';
// import 'package:nb_utils/nb_utils.dart';
//
// import '../events/network_event.dart';
// import '../models/network_connection_model.dart';
//
// class NetworkController extends MomentumController<NetworkConnectionModel> {
//   @override
//   NetworkConnectionModel init() {
//     return NetworkConnectionModel(
//       this,
//       connectionStatus: ConnectivityResult.none,
//     );
//   }
//
//   void onConnectionStatusChange(ConnectivityResult status) {
//     model.update(connectionStatus: status);
//     if (status == ConnectivityResult.wifi ||
//         status == ConnectivityResult.mobile) {
//       sendEvent(NetworkEvent(isConnected: true));
//     } else {
//       sendEvent(NetworkEvent(isConnected: false));
//     }
//   }
//
//   void updateIsDisconnected({required bool isDisconnected}) {
//     model.update(isDisconnected: isDisconnected);
//   }
// }
