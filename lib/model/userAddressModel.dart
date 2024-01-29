import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserAddressModel {
  String addressID;
  String userID;
  double latitude;
  double longitude;
  String roomNo;
  String apartment;
  String addressTitle;
  DateTime uploadTime;
  bool isActive;
  UserAddressModel({
    required this.addressID,
    required this.userID,
    required this.latitude,
    required this.longitude,
    required this.roomNo,
    required this.apartment,
    required this.addressTitle,
    required this.uploadTime,
    required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'addressID': addressID,
      'userID': userID,
      'latitude': latitude,
      'longitude': longitude,
      'roomNo': roomNo,
      'apartment': apartment,
      'addressTitle': addressTitle,
      'uploadTime': uploadTime.millisecondsSinceEpoch,
      'isActive': isActive,
    };
  }

  factory UserAddressModel.fromMap(Map<String, dynamic> map) {
    return UserAddressModel(
      addressID: map['addressID'] as String,
      userID: map['userID'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      roomNo: map['roomNo'] as String,
      apartment: map['apartment'] as String,
      addressTitle: map['addressTitle'] as String,
      uploadTime: DateTime.fromMillisecondsSinceEpoch(map['uploadTime'] as int),
      isActive: map['isActive'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserAddressModel.fromJson(String source) =>
      UserAddressModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
