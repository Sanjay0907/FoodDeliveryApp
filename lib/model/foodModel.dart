import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class FoodModel {
  String name;
  String resturantUID;
  DateTime uploadTime;
  String foodID;
  String description;
  String foodImageURL;
  bool isVegetrain;
  String actualPrice;
  String discountedPrice;
  String? orderID;
  int? quantity;
  DateTime? addedToCartAt;
  FoodModel({
    required this.name,
    required this.resturantUID,
    required this.uploadTime,
    required this.foodID,
    required this.description,
    required this.foodImageURL,
    required this.isVegetrain,
    required this.actualPrice,
    required this.discountedPrice,
    this.orderID,
    this.quantity,
    this.addedToCartAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'resturantUID': resturantUID,
      'uploadTime': uploadTime.millisecondsSinceEpoch,
      'foodID': foodID,
      'description': description,
      'foodImageURL': foodImageURL,
      'isVegetrain': isVegetrain,
      'actualPrice': actualPrice,
      'discountedPrice': discountedPrice,
      'orderID': orderID,
      'quantity': quantity,
      'addedToCartAt': addedToCartAt?.millisecondsSinceEpoch,
    };
  }

  factory FoodModel.fromMap(Map<String, dynamic> map) {
    return FoodModel(
      name: map['name'] as String,
      resturantUID: map['resturantUID'] as String,
      uploadTime: DateTime.fromMillisecondsSinceEpoch(map['uploadTime'] as int),
      foodID: map['foodID'] as String,
      description: map['description'] as String,
      foodImageURL: map['foodImageURL'] as String,
      isVegetrain: map['isVegetrain'] as bool,
      actualPrice: map['actualPrice'] as String,
      discountedPrice: map['discountedPrice'] as String,
      orderID: map['orderID'] != null ? map['orderID'] as String : null,
      quantity: map['quantity'] != null ? map['quantity'] as int : null,
      addedToCartAt: map['addedToCartAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['addedToCartAt'] as int) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FoodModel.fromJson(String source) =>
      FoodModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
