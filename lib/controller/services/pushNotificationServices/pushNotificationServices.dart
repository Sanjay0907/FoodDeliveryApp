import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ubereatsdriver/constants/constant.dart';
import 'package:ubereatsdriver/controller/services/pushNotificationServices/pushNotificationDialogue.dart';
import 'package:ubereatsdriver/model/foodOrderModel/foodOrderModel.dart';

class PushNotificationServices {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static Future initializeFirebaseMessaging(BuildContext context) async {
    await firebaseMessaging.requestPermission();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((
      RemoteMessage message,
    ) {
      if (message.notification != null) {
        // log(message.toMap().toString());
        // log('The message Data is ');
        // log(message.data.toString());

        firebaseMessagingForegroundHandler(message, context);
      }
    });
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {}

  static Future<void> firebaseMessagingForegroundHandler(
      RemoteMessage message, BuildContext context) async {
    // log(message.data.toString());
    try {
      log('The message Data is ');
      log(message.data.toString());
      log(message.data['foodOrderID']);
      PushNotificationDialogue.deliveryRequestDialogue(message.data['foodOrderID'], context);
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getToken() async {
    String? token = await firebaseMessaging.getToken();
    log('FCM token : \n$token');
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .ref()
        .child('Driver/${auth.currentUser!.uid}/cloudMessagingToken');
    databaseReference.set(token);
  }

  static subscribeToNotification() {
    firebaseMessaging.subscribeToTopic('DELIVERY_PARTNER');
  }

  static initializeFCM(BuildContext context) {
    initializeFirebaseMessaging(context);
    getToken();
    subscribeToNotification();
  }
}
