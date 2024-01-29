import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ubereats/controller/services/APIsNKeys/keys.dart';

class APIs {
  static pushNotificationAPI() => 'https://fcm.googleapis.com/fcm/send';

 static directionAPI(LatLng start, LatLng end) =>
      'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&mode=driving&key=$mapCredential';
}
