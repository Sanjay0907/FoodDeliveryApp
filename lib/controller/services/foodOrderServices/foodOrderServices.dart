// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubereats/constant/constant.dart';
import 'package:ubereats/controller/provider/itemOrderProvider/itemOrderProvider.dart';
import 'package:ubereats/controller/services/pushNotificationServices/pushNotificationServices.dart';
import 'package:ubereats/model/foodModel.dart';
import 'package:ubereats/model/foodOrderModel/foodOrderModel.dart';
import 'package:ubereats/widgets/toastService.dart';

class FoodOrderServices {
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

  static removeItemFromBasket(String cartItemID, BuildContext context) async {
    log(cartItemID);
    try {
      await firestore
          .collection('Cart')
          .doc(auth.currentUser!.uid)
          .collection('CartItem')
          .doc(cartItemID)
          .delete()
          .then((value) {
        log('Item Deleted');
        // print(value);
        context.read<ItemOrderProvider>().fetchCartItems();
      });
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  static placeFoodOrderRequest(
      FoodOrderModel foodOrderModel, String cartOrderID,BuildContext context) async {
    realTimeDatabaseRef
        .child('Orders/${foodOrderModel.orderID}')
        .set(foodOrderModel.toMap())
        .then((value) async {
      log(foodOrderModel.toMap().toString());
      PushNotificationServices.sendPushNotificationToResturant(foodOrderModel);
      await removeItemFromBasket(cartOrderID, context);
      Navigator.pop(context);
      ToastService.sendScaffoldAlert(
        msg: 'Order Placed Successful',
        toastStatus: 'SUCCESS',
        context: context,
      );
    }).onError((error, stackTrace) {
      ToastService.sendScaffoldAlert(
        msg: 'Opps! issues Placing order',
        toastStatus: 'ERROR',
        context: context,
      );
    });
  }

  static addItemToCart(FoodModel foodData, BuildContext context) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('Cart')
          .doc(auth.currentUser!.uid)
          .collection('CartItem')
          .where('foodID', isEqualTo: foodData.foodID)
          .get();
      if (snapshot.docs.isEmpty) {
        await firestore
            .collection('Cart')
            .doc(auth.currentUser!.uid)
            .collection('CartItem')
            .doc(foodData.orderID)
            .set(foodData.toMap())
            .whenComplete(() {
          ToastService.sendScaffoldAlert(
            msg: 'Item Added to Cart',
            toastStatus: 'SUCCESS',
            context: context,
          );
        });
      } else {
        int quantity = snapshot.docs[0]['quantity'];
        String orderId = snapshot.docs[0]['orderID'];
        log(quantity.toString());
        await firestore
            .collection('Cart')
            .doc(auth.currentUser!.uid)
            .collection('CartItem')
            .doc(orderId)
            .update({'quantity': quantity + foodData.quantity!}).then((value) {
          context.read<ItemOrderProvider>().fetchCartItems();
          ToastService.sendScaffoldAlert(
            msg: 'Item Added to Cart',
            toastStatus: 'SUCCESS',
            context: context,
          );
        });
      }
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  static fetchCartData() async {
    List<FoodModel> itemAddedToCart = [];
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('Cart')
          .doc(auth.currentUser!.uid)
          .collection('CartItem')
          .orderBy(
            'addedToCartAt',
            descending: true,
          )
          .get();
      snapshot.docs.forEach((element) {
        itemAddedToCart.add(FoodModel.fromMap(element.data()));
      });
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
    return itemAddedToCart;
  }

  static updateQuantity(String cartItemID, int currentQty, BuildContext context,
      bool isAdded) async {
    try {
      if (currentQty == 1 && !isAdded) {
        await firestore
            .collection('Cart')
            .doc(auth.currentUser!.uid)
            .collection('CartItem')
            .doc(cartItemID)
            .delete()
            .then((value) {
          context.read<ItemOrderProvider>().fetchCartItems();
        });
      }

      await firestore
          .collection('Cart')
          .doc(auth.currentUser!.uid)
          .collection('CartItem')
          .doc(cartItemID)
          .update({'quantity': isAdded ? currentQty + 1 : currentQty - 1}).then(
              (value) {
        context.read<ItemOrderProvider>().fetchCartItems();
      });
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }
}
