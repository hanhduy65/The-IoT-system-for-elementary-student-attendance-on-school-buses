class LocationModel {
  final String? name, lat, long;
  final bool? isOnBusBySmartTag;

  const LocationModel({this.name, this.lat, this.long, this.isOnBusBySmartTag});

  LocationModel fromJson(Map<String, dynamic>? json) {
    return LocationModel(
      isOnBusBySmartTag: json?["isOnBusBySmartTag"],
      lat: json?["latitude"],
      long: json?["longitude"],
    );
  }
}
