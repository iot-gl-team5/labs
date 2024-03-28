// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'accelerometer.dart';
import 'location.dart';

class AgentData {
  const AgentData({
    required this.userId,
    required this.accelerometer,
    required this.gps,
    required this.timestamp,
  });

  final int userId;
  final Accelerometer accelerometer;
  final Location gps;
  final String timestamp;

  AgentData copyWith({
    int? userId,
    Accelerometer? accelerometer,
    Location? gps,
    String? timestamp,
  }) {
    return AgentData(
      userId: userId ?? this.userId,
      accelerometer: accelerometer ?? this.accelerometer,
      gps: gps ?? this.gps,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': userId,
      'accelerometer': accelerometer.toMap(),
      'gps': gps.toMap(),
      'timestamp': timestamp,
    };
  }

  factory AgentData.fromMap(Map<String, dynamic> map) {
    return AgentData(
      userId: map['userId'] as int,
      accelerometer:
          Accelerometer.fromMap(map['accelerometer'] as Map<String, dynamic>),
      gps: Location.fromMap(map['gps'] as Map<String, dynamic>),
      timestamp: map['timestamp'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AgentData.fromJson(String source) =>
      AgentData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AgentData(userId: $userId, accelerometer: $accelerometer, gps: $gps, timestamp: $timestamp)';
  }

  @override
  bool operator ==(covariant AgentData other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.accelerometer == accelerometer &&
        other.gps == gps &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        accelerometer.hashCode ^
        gps.hashCode ^
        timestamp.hashCode;
  }
}
