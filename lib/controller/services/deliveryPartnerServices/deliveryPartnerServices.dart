import 'dart:convert';
import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:provider/provider.dart';
import 'package:ubereatsresturant/constant/constant.dart';
import 'package:ubereatsresturant/controller/provider/deliveryPartnerProvider/deliveryPartnerProvider.dart';
import 'package:ubereatsresturant/controller/services/resturantCRUDServices/resturantCrudServices.dart';
import 'package:ubereatsresturant/model/deliveryPartnerModel/deliveryPartnerLocationModel.dart';
import 'package:ubereatsresturant/model/deliveryPartnerModel/driverModel.dart';
import 'package:ubereatsresturant/model/restaurantModel.dart';

class DeliveryPartnerServices {
  static getNearbyDeliveryPartners(BuildContext context) async {
    Geofire.initialize('OnlineDrivers');
    RestaurantModel userActiveAddress =
        await ResturantCRUDServices.fetchResturantData();
    log(userActiveAddress.toMap().toString());
    Geofire.queryAtLocation(
      userActiveAddress.address!.latitude!,
      userActiveAddress.address!.longitude!,
      20,
    )!
        .listen((event) async {
      log(event.toString());
      log((event == null).toString());
      if (event != null) {
        log('Event is not Null');
        var callback = event['callBack'];
        switch (callback) {
          case Geofire.onKeyEntered:
            log('Key Entered');
            DeliveryPartnerLocationModel model = DeliveryPartnerLocationModel(
              id: event['key'],
              latitude: event['latitude'],
              longitude: event['longitude'],
            );
            log('Delivery Partner Data is ${model.toJson().toString()}');
            log('\n\n\n');
            context.read<DeliveryPartnerProvider>().addDeliveryPartner(model);

            break;

          case Geofire.onKeyExited:
            DeliveryPartnerLocationModel model = DeliveryPartnerLocationModel(
              id: event['key'],
              latitude: event['latitude'],
              longitude: event['longitude'],
            );
            context
                .read<DeliveryPartnerProvider>()
                .removeDeliveryPartner(model.id);
            break;

          case Geofire.onKeyMoved:
            break;

          case Geofire.onGeoQueryReady:
            log('Query Ready');

            break;
        }
      }
    });
  }

  static getDeliveryPartnerProfileData(String driverID) async {
    try {
      final snapshot =
          await realTimeDatabaseRef.child('Driver/$driverID').get();
      log(snapshot.value.toString());
      if (snapshot.exists) {
        DeliveryPartnerModel deliveryPartnerData = DeliveryPartnerModel.fromMap(
            jsonDecode(jsonEncode(snapshot.value)) as Map<String, dynamic>);
        log(deliveryPartnerData.toMap().toString());

        return deliveryPartnerData;
      }
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }
}
