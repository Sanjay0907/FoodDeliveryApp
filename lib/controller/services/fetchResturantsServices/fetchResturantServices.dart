import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:ubereats/constant/constant.dart';
import 'package:ubereats/controller/provider/resturantProvider/resturantProvider.dart';
import 'package:ubereats/controller/services/locationServices/locationServices.dart';
import 'package:ubereats/controller/services/userDataCRUDServices/userDataCRUDServices.dart';
import 'package:ubereats/model/foodModel.dart';
import 'package:ubereats/model/restaurantModel.dart';
import 'package:ubereats/model/resturantIDnLocationModel.dart';
import 'package:ubereats/model/userAddressModel.dart';

class ResturantServices {
  static getNearbyResturants(BuildContext context) async {
    Geofire.initialize('Resturants');
    UserAddressModel userActiveAddress =
        await UserDataCRUDServices.fetchActiveAddress();
    log(userActiveAddress.toMap().toString());
    Geofire.queryAtLocation(
      userActiveAddress.latitude,
      userActiveAddress.longitude,
      20,
    )!
        .listen((event) {
      log(event.toString());
      log((event == null).toString());
      if (event != null) {
        log('Event is not Null');
        var callback = event['callBack'];
        switch (callback) {
          case Geofire.onKeyEntered:
            log('Key Entered');
            ResturantIDnLocationModel model = ResturantIDnLocationModel(
              id: event['key'],
              latitude: event['latitude'],
              longitude: event['longitude'],
            );
            log('Resturant Data is');
            log(model.toJson().toString());
            log('\n\n\n');
            context.read<ResturantProvider>().addResturants(model.id);
            context.read<ResturantProvider>().addFoods(model.id);

            break;
          case Geofire.onGeoQueryReady:
            log('Query Ready');

            break;
        }
      }
    });
  }

  static removeGeofireListeners() async {
    bool? response = await Geofire.stopListener();
    log(response.toString());
  }

  static fetchResturantData(String resturantID) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection('Resturant').doc(resturantID).get();

      RestaurantModel data = RestaurantModel.fromMap(snapshot.data()!);
      return data;
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  static fetchFoodData(String resturantID) async {
    List<FoodModel> foodData = [];
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('Food')
          .orderBy('uploadTime', descending: true)
          .where('resturantUID', isEqualTo: resturantID)
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
