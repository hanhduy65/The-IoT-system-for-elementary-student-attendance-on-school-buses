import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DemoMap extends StatefulWidget {
  const DemoMap({super.key});

  @override
  State<DemoMap> createState() => _DemoMapState();
}

class _DemoMapState extends State<DemoMap> {
  static const _initialPosition = LatLng(-33.852, 151.211);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Google Maps Integration')),
        body: GoogleMap(
          // Đặt vị trí ban đầu cho bản đồ
          initialCameraPosition: CameraPosition(
            target: _initialPosition,
            zoom: 10.0, // Đặt mức zoom ban đầu
          ),
          // Chọn kiểu bản đồ (normal, satellite, terrain, hybrid)
          mapType: MapType.normal,
        ),
      ),
    );
  }
}
