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
import '../../../models/manager_location_model.dart';
import '../../../models/user_model.dart';
import '../../widgets/card_student_register.dart';

class ViewMapOfManager extends StatefulWidget {
  final User user;

  ViewMapOfManager({super.key, required this.user});

  @override
  State<ViewMapOfManager> createState() => _ViewMapOfManagerState();
}

class _ViewMapOfManagerState extends MomentumState<ViewMapOfManager> {
  List<ManagerLocationModel> listGPS = [];
  String locationMess = "Current Location of the user";
  Timer? timer;
  double startLatitude = 0, startLongitude = 0;
  List<Marker> markers = [];
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  CameraPosition _position =
      CameraPosition(target: LatLng(21.0124959, 105.5228), zoom: 17);
  bool isInitGGMap = false;
  void _createMarkers() {
    markers.clear();

    for (int i = 0; i < listGPS.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId('marker${(i + 1)}'),
          position: LatLng(
              double.parse(listGPS[i].lat!), double.parse(listGPS[i].long!)),
          infoWindow:
              InfoWindow(title: 'BusId: ${listGPS[i].busId.toString()} '),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Visibility(
        visible: isInitGGMap,
        child: Container(
          width: 1.sw,
          height: 1.sh,
          child: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                markers: Set.from(markers),
                initialCameraPosition: _position,
                onMapCreated: _onMapCreated,
              ),
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
    Momentum.controller<LoginController>(context).doGetGPSForManager();
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        Momentum.controller<LoginController>(context).doGetGPSForManager();
      }
    });
    loginController.listen<ManagerLocationEvent>(
      state: this,
      invoke: (event) {
        setState(() {
          isInitGGMap = true;
          listGPS = event.locations;
          print("Đang có ... xe bus" + listGPS.length.toString());
          _createMarkers();
        });
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
