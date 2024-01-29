// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:ubereats/model/latitudeLongitudeModel.dart';

class RestaurantModel {
  String? restaurantName;
  String? restaurantLicenseNumber;
  String? restaurantUID;
  List<String>? bannerImages;
  AddressModel? address;
  String? cloudMessagingToken;
  RestaurantModel({
    this.restaurantName,
    this.restaurantLicenseNumber,
    this.restaurantUID,
    this.bannerImages,
    this.address,
    this.cloudMessagingToken,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'restaurantName': restaurantName,
      'restaurantLicenseNumber': restaurantLicenseNumber,
      'restaurantUID': restaurantUID,
      'bannerImages': bannerImages,
      'address': address?.toMap(),
      'cloudMessagingToken': cloudMessagingToken,
    };
  }

  factory RestaurantModel.fromMap(Map<String, dynamic> map) {
    return RestaurantModel(
      restaurantName: map['restaurantName'] != null ? map['restaurantName'] as String : null,
      restaurantLicenseNumber: map['restaurantLicenseNumber'] != null ? map['restaurantLicenseNumber'] as String : null,
      restaurantUID: map['restaurantUID'] != null ? map['restaurantUID'] as String : null,
      bannerImages: map['bannerImages'] != null
          ? List<String>.from(
              (map['bannerImages'] as List<dynamic>).cast<String>())
          : null,
      address: map['address'] != null ? AddressModel.fromMap(map['address'] as Map<String,dynamic>) : null,
      cloudMessagingToken: map['cloudMessagingToken'] != null ? map['cloudMessagingToken'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RestaurantModel.fromJson(String source) =>
      RestaurantModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
