class Location {
  final double? lat, long;

  const Location({this.lat, this.long});

  Location fromJson(Map<String, dynamic>? json) {
    return Location(
      lat: json?["latitude"],
      long: json?["longitude"],
    );
  }
}
