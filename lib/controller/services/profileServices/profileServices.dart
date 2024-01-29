import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ubereatsdriver/constants/constant.dart';
import 'package:ubereatsdriver/model/driverModel/driverModel.dart';
import 'package:ubereatsdriver/view/singInLogicScreen/signInLogicScreen.dart';
import 'package:ubereatsdriver/widgets/toastService.dart';

class ProfileServices {
  static registerDriver(DeliveryPartnerModel driverData, BuildContext context) {
    realTimeDatabaseRef
        .child('Driver/${auth.currentUser!.uid}')
        .set(driverData.toMap())
        .then((value) {
      ToastService.sendScaffoldAlert(
        msg: 'Registered Successful',
        toastStatus: 'SUCCESS',
        context: context,
      );
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
              child: const SignInLogicScreen(),
              type: PageTransitionType.rightToLeft),
          (route) => false);
    }).onError((error, stackTrace) {
      ToastService.sendScaffoldAlert(
        msg: 'Opps! Error getting Registered',
        toastStatus: 'ERROR',
        context: context,
      );
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
              child: const SignInLogicScreen(),
              type: PageTransitionType.rightToLeft),
          (route) => false);
    });
  }

  static Future<bool> checkForRegistration() async {
    try {
      final snapshot = await realTimeDatabaseRef
          .child('Driver/${auth.currentUser!.uid}')
          .get();
      if (snapshot.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  static getDeliveryPartnerProfileData() async {
    try {
      final snapshot = await realTimeDatabaseRef.child('Driver/${auth.currentUser!.uid}').get();
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
