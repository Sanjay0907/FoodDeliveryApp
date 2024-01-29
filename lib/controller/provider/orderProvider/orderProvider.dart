import 'package:flutter/foundation.dart';
import 'package:ubereatsdriver/model/foodOrderModel/foodOrderModel.dart';

class OrderProvider extends ChangeNotifier {
  FoodOrderModel? orderData;

  updateFoodOrderData(FoodOrderModel data) {
    orderData = data;
    notifyListeners();
  }

  emptyOrderData() {
    orderData = null;
    notifyListeners();
  }
}
