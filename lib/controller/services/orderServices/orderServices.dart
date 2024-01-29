import 'dart:convert';
import 'dart:developer';

import 'package:ubereatsresturant/constant/constant.dart';

class OrderServices {
  static fetchOrders() async {
    try {
      var snapshot = await realTimeDatabaseRef
          .child('Orders')
          .orderByChild('resturantUID')
          .equalTo(auth.currentUser!.uid)
          .onValue
          .listen((event) {
        if (event.snapshot.value != null) {
          log('Food Orders fetched');
          log(jsonEncode(event.snapshot.value.toString()) );
        }
      });
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  static orderStatus(int status) {
    switch (status) {
      case 0:
        return 'FOOD_UNDER_PREPERATION';
      case 1:
        return 'FOOD_PICKED_UP_BY_DELIVERY_PARTNER';
      case 2:
        'FOOD_DELIVERED';
    }
  }
}
