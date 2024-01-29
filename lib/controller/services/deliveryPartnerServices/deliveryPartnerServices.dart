import 'dart:convert';
import 'dart:developer';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:ubereats/constant/constant.dart';
import 'package:ubereats/controller/services/pushNotificationServices/pushNotificationServices.dart';
import 'package:ubereats/controller/services/userDataCRUDServices/userDataCRUDServices.dart';
import 'package:ubereats/model/deliveryPartnerModel/deliveryPartnerLocationModel.dart';
import 'package:ubereats/model/deliveryPartnerModel/driverModel.dart';
import 'package:ubereats/model/userAddressModel.dart';

class DeliveryPartnerServices {
  static getNearbyDeliveryPartners() async {
    Geofire.initialize('OnlineDrivers');
    UserAddressModel userActiveAddress =
        await UserDataCRUDServices.fetchActiveAddress();
    log(userActiveAddress.toMap().toString());
    Geofire.queryAtLocation(
      userActiveAddress.latitude,
      userActiveAddress.longitude,
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
            // log();
            log('\n\n\n');
            DeliveryPartnerModel deliveryPartnerData =
                await getDeliveryPartnerProfileData(model.id);
            log(deliveryPartnerData.toMap().toString());
            await PushNotificationServices
                .sendPushNotificationToNearbyDeliveryPartners(
                    deliveryPartnerData, 'Chicken 65');

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
