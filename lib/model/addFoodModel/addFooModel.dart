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
  int? quantity;
  String discountedPrice;
  FoodModel({
    required this.name,
    required this.resturantUID,
    required this.uploadTime,
    required this.foodID,
    required this.description,
    required this.foodImageURL,
    required this.isVegetrain,
    required this.actualPrice,
    this.quantity,
    required this.discountedPrice,
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
      'quantity': quantity,
      'discountedPrice': discountedPrice,
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
      quantity: map['quantity'] != null ? map['quantity'] as int : null,
      discountedPrice: map['discountedPrice'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FoodModel.fromJson(String source) =>
      FoodModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
