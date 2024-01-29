import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ResturantIDnLocationModel {
  String id;
  double latitude;
  double longitude;
  ResturantIDnLocationModel({
    required this.id,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory ResturantIDnLocationModel.fromMap(Map<String, dynamic> map) {
    return ResturantIDnLocationModel(
      id: map['id'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResturantIDnLocationModel.fromJson(String source) => ResturantIDnLocationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
