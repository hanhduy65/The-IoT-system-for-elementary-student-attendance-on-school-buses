class LocationModel {
  final String? name, lat, long;

  const LocationModel({this.name, this.lat, this.long});

  LocationModel fromJson(Map<String, dynamic>? json) {
    return LocationModel(
      lat: json?["latitude"],
      long: json?["longitude"],
    );
  }
}
