import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ubereatsresturant/constant/constant.dart';
import 'package:ubereatsresturant/controller/services/APIsNKeys/APIs.dart';
import 'package:ubereatsresturant/controller/services/APIsNKeys/keys.dart';
import 'package:http/http.dart' as http;
import 'package:ubereatsresturant/model/deliveryPartnerModel/driverModel.dart';
import 'package:ubereatsresturant/model/foodOrderModel/foodOrderModel.dart';

class PushNotificationServices {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static Future initializeFirebaseMessaging() async {
    await firebaseMessaging.requestPermission();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(firebaseMessagingForegroundHandler);
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    log(message.toMap().toString());
  }

  static Future<void> firebaseMessagingForegroundHandler(
      RemoteMessage message) async {
    log(message.toMap().toString());
  }

  static Future getToken() async {
    String? token = await firebaseMessaging.getToken();
    log('FCM token : \n$token');
    await firestore
        .collection('Resturant')
        .doc(auth.currentUser!.uid)
        .update({'cloudMessagingToken': token});
  }

  static subscribeToNotification() {
    firebaseMessaging.subscribeToTopic('RESTURANT_PARTNER');
  }

  static initializeFCM() {
    initializeFirebaseMessaging();
    getToken();
    subscribeToNotification();
  }

  static sendPushNotificationToUserAfterFoodOutForDelivery(
      String fcmToken, String foodName) async {
    try {
      final api = Uri.parse(APIs.pushNotificationAPI());
      var body = jsonEncode({
        "to": fcmToken,
        "notification": {
          "body": "$foodName is out for delivery",
          "title": "Out for Delivery"
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

  static sendPushNotificationToNearbyDeliveryPartners(
      DeliveryPartnerModel deliveryPartner,
      FoodOrderModel foodOrderData) async {
    try {
      final api = Uri.parse(APIs.pushNotificationAPI());
      var body = jsonEncode({
        "to": deliveryPartner.cloudMessagingToken,
        "notification": {
          "body": "New Delivery Request",
          "title": "Delivery Request"
        },
        "data": {"foodOrderID": foodOrderData.orderID}
      });
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'key=$fcmServerKey'
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
    } catch (error) {
      log(error.toString());
      throw Exception(error);
    }
  }
}
