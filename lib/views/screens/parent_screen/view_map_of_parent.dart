import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:momentum/momentum.dart';
import 'package:school_bus_attendance_test/controllers/login_controller.dart';
import 'package:school_bus_attendance_test/events/login_events.dart';
import 'dart:async';
import '../../../models/user_model.dart';

class ViewMapOfParent extends StatefulWidget {
  final String? token;
  final User user;

  ViewMapOfParent({super.key, this.token, required this.user});

  @override
  State<ViewMapOfParent> createState() => _ViewMapOfParentState();
}

class _ViewMapOfParentState extends MomentumState<ViewMapOfParent> {
  String lat = "0", long = "0";
  String locationMess = "Current Location of the user";
  Timer? timer;

  // Future<Position> _getCurrentLocation() async {
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled');
  //   }
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location services are denied');
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     Future.error(
  //         'Location services are permanently denied, we cannot request');
  //   }
  //   return await Geolocator.getCurrentPosition();
  // }

  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  CameraPosition _position =
      CameraPosition(target: LatLng(21.0124959, 105.5228), zoom: 17);
  bool isInitGGMap = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(locationMess),
            // ElevatedButton(
            //   onPressed: () {
            //     Momentum.controller<LoginController>(context)
            //         .doGetGPS(widget.user.userId!);
            //   },
            //   child: const Text("Get GPS of child's bus"),
            // ),
            Visibility(
              visible: isInitGGMap,
              child: Container(
                width: 1.sw,
                height: 1.sh * 1.2,
                child: GoogleMap(
                  mapType: MapType.normal,
                  markers: {
                    Marker(
                      markerId: MarkerId('MyMarker'),
                      position: LatLng(double.parse(lat), double.parse(long)),
                      // Vị trí của đánh dấu
                      infoWindow: const InfoWindow(
                        title: 'My Location',
                      ),
                    ),
                  },
                  initialCameraPosition: _position,
                  onMapCreated: _onMapCreated,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initMomentumState() {
    super.initMomentumState();
    final loginController = Momentum.controller<LoginController>(context);
    Momentum.controller<LoginController>(context).doGetGPS(widget.user.userId!);
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      Momentum.controller<LoginController>(context)
          .doGetGPS(widget.user.userId!);
    });
    loginController.listen<LocationEvent>(
      state: this,
      invoke: (event) {
        if (event.location.lat != null) {
          if (event.location.lat! != "0" && event.location.long! != "0") {
            lat = event.location.lat!;
            long = event.location.long!;
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              setState(() {
                locationMess = 'Latitude: $lat, Longitude:$long';
                _position = CameraPosition(
                    target: LatLng(double.parse(lat), double.parse(long)),
                    zoom: 17);
                isInitGGMap = true;
              });
            });
          }
        }
      },
    );
  }
}
