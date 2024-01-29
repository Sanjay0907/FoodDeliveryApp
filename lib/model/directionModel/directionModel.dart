import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DirectionModel {
   final String distanceInKM;
  final int distanceInMeter;
  final String durationInHour;
  final int duration;
  final String polylinePoints;
  DirectionModel({
    required this.distanceInKM,
    required this.distanceInMeter,
    required this.durationInHour,
    required this.duration,
    required this.polylinePoints,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'distanceInKM': distanceInKM,
      'distanceInMeter': distanceInMeter,
      'durationInHour': durationInHour,
      'duration': duration,
      'polylinePoints': polylinePoints,
    };
  }

  factory DirectionModel.fromMap(Map<String, dynamic> map) {
    return DirectionModel(
      distanceInKM: map['distanceInKM'] as String,
      distanceInMeter: map['distanceInMeter'] as int,
      durationInHour: map['durationInHour'] as String,
      duration: map['duration'] as int,
      polylinePoints: map['polylinePoints'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DirectionModel.fromJson(String source) => DirectionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
