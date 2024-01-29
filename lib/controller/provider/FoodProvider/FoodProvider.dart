import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ubereatsresturant/controller/services/foodDataCRUDServices/foodDataCRUDServices.dart';
import 'package:ubereatsresturant/controller/services/imagesServices/imagesServices.dart';
import 'package:ubereatsresturant/model/addFoodModel/addFooModel.dart';

class FoodProvider extends ChangeNotifier {
  File? foodImage;
  String? foodImageURL;
  List<FoodModel> items = [];

  pickFoodImageFromGallery(BuildContext context) async {
    foodImage = await ImageServices.pickSingleImage(context: context);
    notifyListeners();
  }

  uploadImageAndGetImageURL(BuildContext context) async {
    List<String> url = await ImageServices.uploadImagesToFirebaseStorageNGetURL(
      images: [foodImage!],
      context: context,
    );
    if (url.isNotEmpty) {
      foodImageURL = url[0];
      log(foodImageURL!);
    }
    notifyListeners();
  }

  getFoodData() async {
    items = await FoodDataCRUDServices.fetchFoodData();
    notifyListeners();
  }
}
