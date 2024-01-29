import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubereatsdriver/constants/constant.dart';
import 'package:ubereatsdriver/controller/provider/profileProvider/profileProvider.dart';
import 'package:ubereatsdriver/model/driverModel/driverModel.dart';
import 'package:ubereatsdriver/model/foodOrderModel/foodOrderModel.dart';
import 'package:ubereatsdriver/widgets/toastService.dart';

class OrderServices {
  static fetchOrderDetails(String orderID) async {
    try {
      var snapshot = await realTimeDatabaseRef.child('Orders/$orderID').get();
      FoodOrderModel foodData = FoodOrderModel.fromMap(
          jsonDecode(jsonEncode(snapshot.value)) as Map<String, dynamic>);
      return foodData;
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  static updateDiverProfileIntoFoodOrderModelNAddActiveDeliveryRequest(
      String orderID, BuildContext context) async {
    DeliveryPartnerModel deliveryPartnerData =
        context.read<ProfileProvider>().deliveryGuyProfile!;
    realTimeDatabaseRef
        .child('Orders/$orderID/deliveryPartnerData')
        .set(deliveryPartnerData.toMap());
    realTimeDatabaseRef
        .child('Driver/${auth.currentUser!.uid}/activeDeliveryRequestID')
        .set(orderID);
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

  static addOrderDataToHistory(
      FoodOrderModel foodOrderData, BuildContext context) async {
    FoodOrderModel foodData = FoodOrderModel(
      foodDetails: foodOrderData.foodDetails,
      deliveryCharges: foodOrderData.deliveryCharges,
      resturantDetails: foodOrderData.resturantDetails,
      userAddress: foodOrderData.userAddress,
      userData: foodOrderData.userData,
      deliveryPartnerData: foodOrderData.deliveryPartnerData,
      orderID: foodOrderData.orderID,
      resturantUID: foodOrderData.resturantUID,
      userUID: foodOrderData.userUID,
      deliveryGuyUID: auth.currentUser!.uid,
      orderStatus: foodOrderData.orderStatus,
      addedTocartAt: foodOrderData.addedTocartAt,
      orderPlacedAt: foodOrderData.orderPlacedAt,
      orderDeliveredAt: DateTime.now(),
    );

    String orderHistoryID = uuid.v1();
    await realTimeDatabaseRef
        .child('OrderHistory/$orderHistoryID')
        .set(foodData.toMap())
        .then((value) {
      ToastService.sendScaffoldAlert(
        msg: 'Order Added to History',
        toastStatus: 'SUCCESS',
        context: context,
      );
    }).onError((error, stackTrace) {
      ToastService.sendScaffoldAlert(
        msg: 'Opps! Error Adding Order Record',
        toastStatus: 'ERROR',
        context: context,
      );
    });
  }

  static removeOrder(String orderId) {
    realTimeDatabaseRef.child('Orders/$orderId').remove();
  }
}
