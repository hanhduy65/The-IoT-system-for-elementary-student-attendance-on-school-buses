class Location {
  final String? lat, long;

  const Location({this.lat, this.long});

  Location fromJson(Map<String, dynamic>? json) {
    return Location(
      lat: json?["latitude"],
      long: json?["longitude"],
    );
  }
}
