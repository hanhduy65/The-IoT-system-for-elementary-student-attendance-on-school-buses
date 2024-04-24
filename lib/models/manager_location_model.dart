class ManagerLocationModel {
  final String? lat, long;
  final int? busId;

  const ManagerLocationModel({
    this.busId,
    this.lat,
    this.long,
  });

  factory ManagerLocationModel.fromJson(Map<String, dynamic>? json) {
    return ManagerLocationModel(
      busId: json?["bus_id"],
      lat: json?["latitude"],
      long: json?["longitude"],
    );
  }
}
