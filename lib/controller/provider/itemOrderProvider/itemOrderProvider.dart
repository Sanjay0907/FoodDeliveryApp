import 'package:flutter/foundation.dart';
import 'package:ubereats/controller/services/foodOrderServices/foodOrderServices.dart';
import 'package:ubereats/model/foodModel.dart';

class ItemOrderProvider extends ChangeNotifier {
  List<FoodModel> cartItems = [];

  fetchCartItems() async {
    cartItems = await FoodOrderServices.fetchCartData();
    notifyListeners();
  }
}
