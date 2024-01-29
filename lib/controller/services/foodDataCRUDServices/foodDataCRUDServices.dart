// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ubereatsresturant/constant/constant.dart';
import 'package:ubereatsresturant/controller/services/toastServices/toastMessageService.dart';
import 'package:ubereatsresturant/model/addFoodModel/addFooModel.dart';

class FoodDataCRUDServices {
  static uploadFoodData(BuildContext context, FoodModel data) async {
    try {
      await firestore
          .collection('Food')
          .doc(data.foodID)
          .set(data.toMap())
          .whenComplete(() {
        Navigator.pop(context);
        ToastService.sendScaffoldAlert(
          msg: 'Food Added Successful',
          toastStatus: 'SUCCESS',
          context: context,
        );
        
      });
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  static fetchFoodData() async {
    List<FoodModel> foodData = [];
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('Food')
          .orderBy('uploadTime', descending: true)
          .where('resturantUID', isEqualTo: auth.currentUser!.uid)
          .get();
      snapshot.docs.forEach((element) {
        foodData.add(FoodModel.fromMap(element.data()));
      });
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
    return foodData;
  }
}
