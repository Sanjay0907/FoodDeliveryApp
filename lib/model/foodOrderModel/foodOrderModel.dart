// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:ubereatsresturant/model/addFoodModel/addFooModel.dart';
import 'package:ubereatsresturant/model/deliveryPartnerModel/driverModel.dart';
import 'package:ubereatsresturant/model/restaurantModel.dart';
import 'package:ubereatsresturant/model/userAddressModel.dart';
import 'package:ubereatsresturant/model/userModel.dart';

class FoodOrderModel {
  FoodModel foodDetails;
  RestaurantModel resturantDetails;
  UserAddressModel? userAddress;
  UserModel? userData;
  DeliveryPartnerModel? deliveryPartnerData;
  String? orderID;
  String resturantUID;
  String userUID;
  String? orderStatus;
  DateTime? addedTocartAt;
  DateTime? orderPlacedAt;
  DateTime? orderDeliveredAt;
  bool? requestedForDelivery;

  FoodOrderModel({
    required this.foodDetails,
    required this.resturantDetails,
    required this.userAddress,
    required this.userData,
    this.deliveryPartnerData,
    required this.orderID,
    required this.resturantUID,
    required this.userUID,
    required this.orderStatus,
    this.addedTocartAt,
    required this.orderPlacedAt,
    this.orderDeliveredAt,
    this.requestedForDelivery,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'foodDetails': foodDetails.toMap(),
      'resturantDetails': resturantDetails.toMap(),
      'userAddress': userAddress?.toMap(),
      'userData': userData?.toMap(),
      'deliveryPartnerData': deliveryPartnerData?.toMap(),
      'orderID': orderID,
      'resturantUID': resturantUID,
      'userUID': userUID,
      'orderStatus': orderStatus,
      'addedTocartAt': addedTocartAt?.millisecondsSinceEpoch,
      'orderPlacedAt': orderPlacedAt?.millisecondsSinceEpoch,
      'orderDeliveredAt': orderDeliveredAt?.millisecondsSinceEpoch,
      'requestedForDelivery': requestedForDelivery,
    };
  }

  factory FoodOrderModel.fromMap(Map<String, dynamic> map) {
    return FoodOrderModel(
      foodDetails: FoodModel.fromMap(map['foodDetails'] as Map<String,dynamic>),
      resturantDetails: RestaurantModel.fromMap(map['resturantDetails'] as Map<String,dynamic>),
      userAddress: map['userAddress'] != null ? UserAddressModel.fromMap(map['userAddress'] as Map<String,dynamic>) : null,
      userData: map['userData'] != null ? UserModel.fromMap(map['userData'] as Map<String,dynamic>) : null,
      deliveryPartnerData: map['deliveryPartnerData'] != null ? DeliveryPartnerModel.fromMap(map['deliveryPartnerData'] as Map<String,dynamic>) : null,
      orderID: map['orderID'] != null ? map['orderID'] as String : null,
      resturantUID: map['resturantUID'] as String,
      userUID: map['userUID'] as String,
      orderStatus: map['orderStatus'] != null ? map['orderStatus'] as String : null,
      addedTocartAt: map['addedTocartAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['addedTocartAt'] as int) : null,
      orderPlacedAt: map['orderPlacedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['orderPlacedAt'] as int) : null,
      orderDeliveredAt: map['orderDeliveredAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['orderDeliveredAt'] as int) : null,
      requestedForDelivery: map['requestedForDelivery'] != null ? map['requestedForDelivery'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FoodOrderModel.fromJson(String source) =>
      FoodOrderModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
