// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Location {
  const Location({
    this.longitude,
    this.latitude,
  });

  final double? longitude;

  final double? latitude;

  Location copyWith({
    double? longitude,
    double? latitude,
  }) {
    return Location(
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'longitude': longitude,
      'latitude': latitude,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      longitude: map['longitude'] != null ? map['longitude'] as double : null,
      latitude: map['latitude'] != null ? map['latitude'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Location.fromJson(String source) =>
      Location.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Location(longitude: $longitude, latitude: $latitude)';

  @override
  bool operator ==(covariant Location other) {
    if (identical(this, other)) return true;

    return other.longitude == longitude && other.latitude == latitude;
  }

  @override
  int get hashCode => longitude.hashCode ^ latitude.hashCode;
}
