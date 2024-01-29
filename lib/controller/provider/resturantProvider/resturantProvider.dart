import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ubereats/controller/services/fetchResturantsServices/fetchResturantServices.dart';
import 'package:ubereats/model/foodModel.dart';
import 'package:ubereats/model/restaurantModel.dart';

class ResturantProvider extends ChangeNotifier {
  List<RestaurantModel> resturants = [];
  List<FoodModel> foods = [];
  List<FoodModel> resturantMenu = [];
  List<FoodModel> searchedFood = [];

  addResturants(String resturantID) async {
    RestaurantModel data =
        await ResturantServices.fetchResturantData(resturantID);
    resturants.add(data);
    notifyListeners();
    log('Total Resturants Fetched are');
    log(resturants.length.toString());
  }

  addFoods(String resturantID) async {
    List<FoodModel> foodData =
        await ResturantServices.fetchFoodData(resturantID);
    foods.addAll(foodData);
    notifyListeners();
    log('Total Food Items Fetched are');
    log(foods.length.toString());
  }

  getResturantMenu(String resturantID) {
    for (var data in foods) {
      if (data.resturantUID == resturantID) {
        resturantMenu.add(data);
      }
    }
    notifyListeners();
  }

  emptyResturantMenu() {
    resturantMenu = [];
    notifyListeners();
  }

  defaultSearchedFood() {
    searchedFood = foods;
    notifyListeners();
  }

  searchFoodItems(String foodName) {
    searchedFood = [];
    notifyListeners();
    for (var data in foods) {
      if (data.name.toLowerCase().contains(foodName.toLowerCase())) {
        searchedFood.add(data);
      }
    }
    notifyListeners();
  }
}
