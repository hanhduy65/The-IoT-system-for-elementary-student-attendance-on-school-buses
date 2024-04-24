import 'dart:math';

import 'package:busmate/controllers/register_smart_tag_response_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:momentum/momentum.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../events/events.dart';
import '../../widgets/widgets.dart';

class BluetoothScan extends StatelessWidget {
  final String? stuId;
  const BluetoothScan({Key? key, this.stuId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.lightBlue,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return FindDevicesScreen(
                stuId: stuId,
              );
            }
            return BluetoothOffScreen(state: state!);
          }),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, required this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 1.sw,
          height: 1.sh,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/ombre_blue.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.bluetooth_disabled,
                  size: 200.0,
                  color: Colors.black87,
                ),
                Text(
                  'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
                ),
                Text(
                  'Please turn on Bluetooth to continue.',
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class FindDevicesScreen extends StatefulWidget {
  final String? stuId;
  const FindDevicesScreen({Key? key, this.stuId}) : super(key: key);
  @override
  State<FindDevicesScreen> createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends MomentumState<FindDevicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 1.sw,
          height: 1.sh,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/ombre_blue.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              'Find Smart tag',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () =>
                FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  StreamBuilder<List<ScanResult>>(
                    stream: FlutterBlue.instance.scanResults,
                    initialData: [],
                    builder: (c, snapshot) => Column(
                      children: (snapshot.data)!
                          .map(
                            (r) => ScanResultTile(
                              result: r,
                              onTap: () {
                                Momentum.controller<
                                            RegisterSmartTagResponseController>(
                                        context)
                                    .doSendRegisterSmartTag(
                                  r.device.id.toString(),
                                  widget.stuId!,
                                );
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: StreamBuilder<bool>(
            stream: FlutterBlue.instance.isScanning,
            initialData: false,
            builder: (c, snapshot) {
              if ((snapshot.data)!) {
                return FloatingActionButton(
                  child: Icon(Icons.stop),
                  onPressed: () => FlutterBlue.instance.stopScan(),
                  backgroundColor: Colors.red,
                );
              } else {
                return FloatingActionButton(
                    child: Icon(Icons.search),
                    onPressed: () => FlutterBlue.instance
                        .startScan(timeout: Duration(seconds: 4)));
              }
            },
          ),
        )
      ],
    );
  }

  void initMomentumState() {
    // TODO: implement initMomentumState
    super.initMomentumState();
    final registerController =
        Momentum.controller<RegisterSmartTagResponseController>(context);
    registerController.listen<RegisterSmartTagEvent>(
      state: this,
      invoke: (event) {
        switch (event.action) {
          case true:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Register smart tag successful'),
                backgroundColor: Colors.green, // Thay đổi màu sắc ở đây
              ),
            );
            break;
          case false:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Register smart tag fail'),
                backgroundColor: Colors.red, // Thay đổi màu sắc ở đây
              ),
            );
            break;
          case null:
            print(event.message);
            break;
          default:
        }
      },
    );
  }
}
