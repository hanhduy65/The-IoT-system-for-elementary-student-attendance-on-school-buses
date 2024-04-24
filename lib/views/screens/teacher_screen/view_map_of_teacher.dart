import 'package:busmate/controllers/send_smart_tags_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:momentum/momentum.dart';
import 'package:busmate/controllers/login_controller.dart';
import 'dart:async';
import '../../../models/user_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../parent_screen/bluetooth_scan.dart';

class ViewMapOfTeacher extends StatefulWidget {
  final User user;
  final int busId;

  const ViewMapOfTeacher({super.key, required this.user, required this.busId});

  @override
  State<ViewMapOfTeacher> createState() => _ViewMapOfTeacherState();
}

class _ViewMapOfTeacherState extends MomentumState<ViewMapOfTeacher> {
  Timer? timer;
  late String lat, long;
  bool isScanning = false;
  String locationMess = "Current Location of the user";

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bạn chưa bật location của thiết bị'),
          backgroundColor: Colors.red, // Thay đổi màu sắc ở đây
        ),
      );
      return Future.error('Location services are disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bạn đã từ chối quyền truy cập location'),
            backgroundColor: Colors.red, // Thay đổi màu sắc ở đây
          ),
        );
        return Future.error('Location services are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Future.error(
          'Location services are permanently denied, we cannot request');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bạn đã từ chối quyền truy cập location vĩnh viễn'),
          backgroundColor: Colors.red, // Thay đổi màu sắc ở đây
        ),
      );
    }
    return await Geolocator.getCurrentPosition();
  }

  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  CameraPosition _position =
      const CameraPosition(target: LatLng(21.0124959, 105.5228), zoom: 17);
  bool isInitGGMap = false;
  int count = 1;
  void startScan() {
    if (!isScanning) {
      List<String> smartTagsId = [];
      setState(() {
        isScanning = true;
      });
      StreamSubscription<List<ScanResult>>? scanSubscription;
      FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
      print("Scan bluetooth");
      scanSubscription =
          FlutterBlue.instance.scanResults.listen((List<ScanResult> results) {
        for (ScanResult result in results) {
          if (result.device.name == "iTAG") {
            if (!smartTagsId.contains(result.device.id.toString())) {
              smartTagsId.add(result.device.id.toString());
            }
            print("Device ID: ${result.device.id}");
          }
        }
      });
      Future.delayed(Duration(seconds: 4), () {
        if (scanSubscription != null) {
          scanSubscription.cancel(); // Hủy đăng ký nghe sự kiện khi hoàn tất
          print("heheehe gửi Smart tags");
          if (mounted) {
            print("smartTagsId : $smartTagsId");
            Momentum.controller<SendSmartTagsResponseController>(context)
                .doSendSmartTags(widget.busId, smartTagsId);
          }
          setState(() {
            isScanning = false;
          });
        }
      });
    }
  }

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
            )),
        Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60.0),
              child: AppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello, teacher",
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    Text(
                      widget.user?.fullName ?? "",
                      style: TextStyle(
                          fontSize: 20.sp,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                actions: const [
                  Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: CircleAvatar(
                      radius: 30.0,
                      backgroundImage: AssetImage("assets/image_avt/avt.jpg"),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
            body: StreamBuilder<BluetoothState>(
                stream: FlutterBlue.instance.state,
                initialData: BluetoothState.unknown,
                builder: (c, snapshot) {
                  final state = snapshot.data;
                  if (state == BluetoothState.on) {
                    return Visibility(
                      visible: isInitGGMap,
                      child: Stack(
                        children: [
                          GoogleMap(
                            mapType: MapType.normal,
                            myLocationEnabled: true,
                            initialCameraPosition: _position,
                            onMapCreated: _onMapCreated,
                          ),
                          Positioned(
                            bottom: 0,
                            left: 10,
                            right: 10,
                            child: Card(
                              color: Colors.white,
                              elevation: 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const ListTile(
                                      title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Bus id: 01"),
                                      Text("Plate No: 17B - 17026"),
                                    ],
                                  )),
                                  Container(
                                    height: 1, // Chiều cao của đường chia
                                    color: Colors.grey, // Màu của đường chia
                                  ),
                                  ListTile(
                                    leading: Image.asset(
                                      "assets/icons/icon_driver.png",
                                      width: 40,
                                      height: 40,
                                    ),
                                    title: Text(
                                      "Driver",
                                      style: TextStyle(
                                          color: Color(0xFFDC7D32),
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text("Ngo Van Long / 0986825596",
                                        style: TextStyle(fontSize: 14.sp)),
                                    trailing: InkWell(
                                      child: const Icon(
                                        Icons.call,
                                        color: Color(0xFFDC7D32),
                                      ),
                                      onTap: () => _makePhoneCall("0986825596"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return BluetoothOffScreen(state: state!);
                })),
      ],
    );
  }

  @override
  void initMomentumState() {
    _getCurrentLocation().then((value) {
      lat = '${value.latitude}';
      long = '${value.longitude}';

      Momentum.controller<LoginController>(context)
          .doSendGPS(widget.busId, lat, long);

      setState(() {
        locationMess = 'Latitude: $lat, Longitude:$long';
        _position = CameraPosition(
            target: LatLng(double.parse(lat), double.parse(long)), zoom: 17);
        isInitGGMap = true;
        count++;
      });
    });
    startScan();
    timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      isScanning = false;
      startScan();
      _getCurrentLocation().then((value) {
        lat = '${value.latitude}';
        long = '${value.longitude}';
        if (mounted) {
          Momentum.controller<LoginController>(context)
              .doSendGPS(widget.busId, lat, long);
        }

        setState(() {
          locationMess = 'Latitude: $lat, Longitude:$long';
          _position = CameraPosition(
              target: LatLng(double.parse(lat), double.parse(long)), zoom: 17);
          isInitGGMap = true;
          count++;
        });
      });
    });
  }
}

_makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri);
  } else {
    throw 'Could not launch ';
  }
}
