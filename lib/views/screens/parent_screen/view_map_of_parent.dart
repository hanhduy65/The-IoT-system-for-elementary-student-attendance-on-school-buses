import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:momentum/momentum.dart';
import 'package:busmate/controllers/login_controller.dart';
import 'package:busmate/events/events.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import '../../../models/student_model.dart';
import '../../../models/user_model.dart';
import '../../widgets/card_student_register.dart';

class ViewMapOfParent extends StatefulWidget {
  final String? token;
  final User user;
  final StudentModel? student;

  ViewMapOfParent({super.key, this.token, required this.user, this.student});

  @override
  State<ViewMapOfParent> createState() => _ViewMapOfParentState();
}

class _ViewMapOfParentState extends MomentumState<ViewMapOfParent> {
  String lat = "0", long = "0";
  bool isOnBusBySmartTag = false;
  String locationMess = "Current Location of the user";
  Timer? timer;
  double startLatitude = 0, startLongitude = 0;
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  CameraPosition _position =
      CameraPosition(target: LatLng(21.0124959, 105.5228), zoom: 17);
  bool isInitGGMap = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  void initData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    startLatitude = double.parse(sp.getString("key_latBusStop") ?? "0");
    startLongitude = double.parse(sp.getString("key_longBusStop") ?? "0");
  }

  // double calculateDistance(double endLatitude, double endLongitude) {
  //   double distanceInMeters = Geolocator.distanceBetween(
  //     startLatitude,
  //     startLongitude,
  //     endLatitude,
  //     endLongitude,
  //   );
  //   return startLatitude == 0 ? -1 : distanceInMeters;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, parent",
                style: TextStyle(fontSize: 16.sp, color: Colors.white70),
              ),
              Text(
                "Le Duc Minh",
                style: TextStyle(
                    fontSize: 20.sp,
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: CircleAvatar(
                radius: 30.0,
                backgroundImage: AssetImage('assets/image_avt/avt_parent.jpg'),
                backgroundColor: Colors.transparent,
              ),
            ),
          ],
        ),
      ),

       */
      body: Visibility(
        visible: isInitGGMap,
        child: Container(
          width: 1.sw,
          height: 1.sh,
          child: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                markers: {
                  Marker(
                    markerId: MarkerId('BusLocation'),
                    position: LatLng(double.parse(lat), double.parse(long)),
                    // Vị trí của đánh dấu
                    infoWindow: const InfoWindow(
                      title: 'My Location',
                    ),
                  ),
                  Marker(
                    visible: startLatitude != 0,
                    markerId: MarkerId('MyPoint'),
                    position: LatLng(startLatitude, startLongitude),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueOrange),
                    // Vị trí của đánh dấu
                    infoWindow: const InfoWindow(
                      title: 'My Location',
                    ),
                  )
                },
                initialCameraPosition: _position,
                onMapCreated: _onMapCreated,
              ),
              /*
              Positioned(
                top: 15,
                left: 10,
                right: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Card(
                      color: Color(0xFFF1DCCE),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/icons/icon_driver.png",
                              width: 50,
                              height: 50,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Driver",
                                  style: TextStyle(
                                      color: Color(0xFFDC7D32),
                                      fontWeight: FontWeight.bold),
                                ),
                                Text("Ngo Van Long"),
                                Text("0986825596"),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Card(
                      color: Color(0xFFF1DCCE),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/icons/teacher.png",
                              width: 50,
                              height: 50,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Supervisor",
                                  style: TextStyle(
                                      color: Color(0xFFDC7D32),
                                      fontWeight: FontWeight.bold),
                                ),
                                Text("Le Thi Hien"),
                                Text("0986825596"),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

               */
              Positioned(
                bottom: 0,
                left: 10,
                right: 10,
                child: Card(
                  color: Color(0xFFFAE4BF),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExpansionTile(
                          shape: Border.all(color: Colors.transparent),
                          childrenPadding: EdgeInsetsDirectional.zero,
                          title: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Bus id: 01"),
                              Text("Plate No: 17B - 17026"),
                            ],
                          ),
                          children: [
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
                            Container(
                              height: 1, // Chiều cao của đường chia
                              color: Colors.grey, // Màu của đường chia
                            ),
                            ListTile(
                              leading: Image.asset(
                                "assets/icons/teacher.png",
                                width: 40,
                                height: 40,
                              ),
                              title: Text(
                                "Teacher",
                                style: TextStyle(
                                    color: Color(0xFFDC7D32),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text("Le Minh Hien/ 0856898687",
                                  style: TextStyle(fontSize: 14.sp)),
                              trailing: InkWell(
                                child: const Icon(
                                  Icons.call,
                                  color: Color(0xFFDC7D32),
                                ),
                                onTap: () => _makePhoneCall("0856898687"),
                              ),
                            ),
                          ]),
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Card(
                        color: isOnBusBySmartTag
                            ? Colors.green
                            : Color(0xFFFAE4BF),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(widget.student?.studentName ?? " "),
                            leading: Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: CircleAvatar(
                                radius: 30.0,
                                backgroundImage:
                                    AssetImage("assets/image_avt/images1.jpg"),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            // subtitle: Text(calculateDistance(
                            //         double.parse(lat), double.parse(long))
                            //     .toString()),
                          ),
                        )),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initMomentumState() {
    super.initMomentumState();
    final loginController = Momentum.controller<LoginController>(context);
    Momentum.controller<LoginController>(context).doGetGPS(widget.user.userId!);
    timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        Momentum.controller<LoginController>(context)
            .doGetGPS(widget.user.userId!);
      }
    });
    loginController.listen<LocationEvent>(
      state: this,
      invoke: (event) {
        if (event.location.lat != null) {
          if (event.location.lat! != "0" && event.location.long! != "0") {
            lat = event.location.lat!;
            long = event.location.long!;
            setState(() {
              isOnBusBySmartTag = event.location.isOnBusBySmartTag!;
              locationMess = 'Latitude: $lat, Longitude:$long';
              _position = CameraPosition(
                  target: LatLng(double.parse(lat), double.parse(long)),
                  zoom: 17);
              isInitGGMap = true;
              print("isInitGGMap: " + isInitGGMap.toString());
            });
          }
        }
      },
    );
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
