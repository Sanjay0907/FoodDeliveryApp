import 'dart:developer';

import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ubereatsresturant/constant/constant.dart';

class LocationServices {
  static getCurretnLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        getCurretnLocation();
      }
    }
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    log(currentPosition.toString());

    return currentPosition;
  }

  static registerResturantLocationInGeofire() async {
    Position currentLocation = await getCurretnLocation();
    Geofire.initialize('Resturants');
    Geofire.setLocation(
      auth.currentUser!.uid,
      currentLocation.latitude,
      currentLocation.longitude,
    );
  }

  // static getNearbyResturants() async {
  //   Geofire.initialize('Resturants');
  //   Position currentLocation = await getCurretnLocation();
  //   Geofire.queryAtLocation(
  //           currentLocation.latitude, currentLocation.longitude, 10)!
  //       .listen((event) {
  //     if (event != null) {
  //       log(event.toString());
  //       var callback = event['callback'];
  //       switch(callback){
  //         case Geofire.onKeyEntered:
  //         case Geofire.onGeoQueryReady:
  //       }
  //     }
  //   });
  // }
}
