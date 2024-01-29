import 'package:flutter/widgets.dart';
import 'package:ubereatsresturant/controller/services/deliveryPartnerServices/deliveryPartnerServices.dart';
import 'package:ubereatsresturant/controller/services/pushNotificationServices/pushNotificationServices.dart';
import 'package:ubereatsresturant/model/deliveryPartnerModel/deliveryPartnerLocationModel.dart';
import 'package:ubereatsresturant/model/deliveryPartnerModel/driverModel.dart';
import 'package:ubereatsresturant/model/foodOrderModel/foodOrderModel.dart';

class DeliveryPartnerProvider extends ChangeNotifier {
  List<DeliveryPartnerLocationModel> deliveryPartnerLocations = [];

  addDeliveryPartner(DeliveryPartnerLocationModel data) {
    deliveryPartnerLocations.add(data);
    notifyListeners();
  }

  removeDeliveryPartner(String deliveryPartnerID) {
    int index = deliveryPartnerLocations
        .indexWhere((element) => element.id == deliveryPartnerID);
    deliveryPartnerLocations.removeAt(index);
    notifyListeners();
  }

  sendDeliveryRequestToNearbyDeliveryPartner(FoodOrderModel foodData) async {
    for (var deliveryPartnerLocationData in deliveryPartnerLocations) {
      DeliveryPartnerModel deliveryPartnerData =
          await DeliveryPartnerServices.getDeliveryPartnerProfileData(
              deliveryPartnerLocationData.id);
      PushNotificationServices.sendPushNotificationToNearbyDeliveryPartners(
        deliveryPartnerData,foodData
      );
    }
  }
}
