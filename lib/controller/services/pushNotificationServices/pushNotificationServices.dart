import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ubereats/constant/constant.dart';
import 'package:ubereats/controller/services/APIsNKeys/APIs.dart';
import 'package:http/http.dart' as http;
import 'package:ubereats/controller/services/APIsNKeys/keys.dart';
import 'package:ubereats/model/deliveryPartnerModel/driverModel.dart';
import 'package:ubereats/model/foodOrderModel/foodOrderModel.dart';

class PushNotificationServices {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static Future initializeFirebaseMessaging() async {
    await firebaseMessaging.requestPermission();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(firebaseMessagingForegroundHandler);
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {}

  static Future<void> firebaseMessagingForegroundHandler(
      RemoteMessage message) async {
    log(message.toMap().toString());
  }

  static Future getToken() async {
    String? token = await firebaseMessaging.getToken();
    log('FCM token : \n$token');
    await firestore
        .collection('User')
        .doc(auth.currentUser!.uid)
        .update({'cloudMessagingToken': token});
  }

  static subscribeToNotification() {
    firebaseMessaging.subscribeToTopic('USER');
  }

  static initializeFCM() {
    initializeFirebaseMessaging();
    getToken();
    subscribeToNotification();
  }

  static sendPushNotificationToNearbyDeliveryPartners(
      DeliveryPartnerModel deliveryPartner, String foodName) async {
    try {
      final api = Uri.parse(APIs.pushNotificationAPI());
      var body = jsonEncode({
        "to": deliveryPartner.cloudMessagingToken,
        "notification": {
          "body": "New Delivery Request",
          "title": "Delivery Request"
        },
        // "data": {"foodName": "Noodles"}
      });
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'key=$fcmServerKey'
      };
      var response =
          await http.post(api, headers: headers, body: body).then((value) {
        log('Successfully Send the Push Notification');
      }).timeout(const Duration(seconds: 60), onTimeout: () {
        log('Connection Timed out');
        throw TimeoutException('Connection Timed out');
      }).onError((error, stackTrace) {
        log(error.toString());
        throw Exception(error);
      });
    } catch (error) {
      log(error.toString());
      throw Exception(error);
    }
  }

  static sendPushNotificationToResturant(FoodOrderModel foodOrderData) async {
    try {
      final api = Uri.parse(APIs.pushNotificationAPI());
      log('Resturant CMT = ${foodOrderData.resturantDetails.cloudMessagingToken}');
      var body = jsonEncode({
        "to": foodOrderData.resturantDetails.cloudMessagingToken,
        "notification": {
          "body": "New order for ${foodOrderData.foodDetails.name}",
          "title": "Order for ${foodOrderData.foodDetails.name}"
        },
        // "data": foodOrderData.toMap()
      });
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'key=$fcmServerKey',
      };
      var response =
          await http.post(api, headers: headers, body: body).then((value) {
        log(value.statusCode.toString());
        log(value.body.toString());
        log('Successfully Send the Push Notification');
      }).timeout(const Duration(seconds: 60), onTimeout: () {
        log('Connection Timed out');
        throw TimeoutException('Connection Timed out');
      }).onError((error, stackTrace) {
        log(error.toString());
        throw Exception(error);
      });
      log(response.toString());
    } catch (error) {
      log(error.toString());
      throw Exception(error);
    }
  }
}
