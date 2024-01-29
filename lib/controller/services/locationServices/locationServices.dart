import 'dart:developer';
import 'package:geolocator/geolocator.dart';

class LocationServices{
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

}