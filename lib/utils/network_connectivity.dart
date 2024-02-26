// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:momentum/momentum.dart';
// import 'package:nb_utils/nb_utils.dart';
//
// import '../controllers/network_controller.dart';
// import '../events/network_event.dart';
// import '../views/dialogs/notification_dialog.dart';
// import 'debouncer.dart';
//
// class NetworkConnectivity {
//   static final _instance = NetworkConnectivity._();
//   static NetworkConnectivity get instance => _instance;
//   final _networkConnectivity = Connectivity();
//   final _controller = StreamController.broadcast();
//   final Debouncer _debouncer = Debouncer(milliseconds: 1000);
//   NetworkConnectivity._();
//   Stream get myStream => _controller.stream;
//   void disposeStream() => _controller.close();
//
//   void initialise() async {
//     _networkConnectivity.onConnectivityChanged.listen((result) {
//       _debouncer.run(() => _checkStatus(result));
//     });
//   }
//
//   void _checkStatus(ConnectivityResult result) async {
//     bool isOnline = false;
//     try {
//       final result = await InternetAddress.lookup('example.com');
//       isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
//     } on SocketException catch (_) {
//       isOnline = false;
//     }
//     _controller.sink.add({result: isOnline});
//   }
//
//   static void connectionHandeler(
//       {required MomentumState<StatefulWidget> state,
//       required BuildContext context,
//       VoidCallback? reloadAction}) {
//     final networkController = Momentum.controller<NetworkController>(context);
//     networkController.listen<NetworkEvent>(
//       state: state,
//       invoke: (event) {
//         // if (loginController.model.autoLoginIndicator) return;
//         switch (event.isConnected) {
//           case true:
//             if (networkController.model.isDisconnected) {
//               print("connected");
//               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                 content: Text("Đã kết nối lại mạng"),
//                 backgroundColor: Colors.green,
//               ));
//               if (reloadAction != null) {
//                 reloadAction();
//               }
//               networkController.updateIsDisconnected(isDisconnected: false);
//             }
//             break;
//           case false:
//             print("disconnected");
//             networkController.updateIsDisconnected(isDisconnected: true);
//             showDialog(
//                 context: context, builder: (context) => noInternetDialog);
//             break;
//           default:
//         }
//       },
//     );
//   }
// }
