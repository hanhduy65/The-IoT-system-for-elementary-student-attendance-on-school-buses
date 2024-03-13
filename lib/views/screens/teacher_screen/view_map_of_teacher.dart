import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:momentum/momentum.dart';
import 'package:school_bus_attendance_test/controllers/login_controller.dart';
import 'package:timer_builder/timer_builder.dart';
import 'dart:async';
import '../../../models/user_model.dart';

class ViewMapOfTeacher extends StatefulWidget {
  final User user;
  final int busId;

  ViewMapOfTeacher({super.key, required this.user, required this.busId});

  @override
  State<ViewMapOfTeacher> createState() => _ViewMapOfTeacherState();
}

class _ViewMapOfTeacherState extends MomentumState<ViewMapOfTeacher> {
  Timer? timer;
  late String lat, long;
  String locationMess = "Current Location of the user";

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location services are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Future.error(
          'Location services are permanently denied, we cannot request');
    }
    return await Geolocator.getCurrentPosition();
  }

  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  CameraPosition _position =
      CameraPosition(target: LatLng(21.0124959, 105.5228), zoom: 17);
  bool isInitGGMap = false;
  int count = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(locationMess),
            // ElevatedButton(
            //   onPressed: () {
            //     _getCurrentLocation().then((value) {
            //       lat = '${value.latitude}';
            //       long = '${value.longitude}';
            //       Momentum.controller<LoginController>(context).doSendGPS(
            //           widget.busId, double.parse(lat), double.parse(long));
            //       setState(() {
            //         locationMess = 'Latitude: $lat, Longitude:$long';
            //         _position = CameraPosition(
            //             target: LatLng(double.parse(lat), double.parse(long)),
            //             zoom: 17);
            //         isInitGGMap = true;
            //         count++;
            //       });
            //     });
            //   },
            //   child: Text("Get current location"),
            // ),
            Visibility(
              visible: isInitGGMap,
              child: Container(
                width: double.infinity,
                height: 1.sh * 1.2,
                child: GoogleMap(
                  mapType: MapType.normal,
                  myLocationEnabled: true,
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

    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
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
    });
  }
}
