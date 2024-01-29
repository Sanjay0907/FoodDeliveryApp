import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:ubereats/controller/services/APIsNKeys/APIs.dart';
import 'package:ubereats/model/directionModel/directionModel.dart';

class DirectionServices {
  static Future getDirectionDetails(
      LatLng pickupLocation, LatLng dropLocation, BuildContext context) async {
    final api = Uri.parse(APIs.directionAPI(pickupLocation, dropLocation));
    try {
      var response = await http
          .get(api, headers: {'Content-Type': 'application/json'}).timeout(
              const Duration(seconds: 60), onTimeout: () {
        throw TimeoutException('Connection Timed Out');
      }).onError((error, stackTrace) {
        log(error.toString());
        throw Exception(error);
      });
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        log(decodedResponse.toString());
        DirectionModel directionModel = DirectionModel(
          distanceInKM: decodedResponse['routes'][0]['legs'][0]['distance']
              ['text'],
          distanceInMeter: decodedResponse['routes'][0]['legs'][0]['distance']
              ['value'],
          durationInHour: decodedResponse['routes'][0]['legs'][0]['duration']
              ['text'],
          duration: decodedResponse['routes'][0]['legs'][0]['duration']
              ['value'],
          polylinePoints: decodedResponse['routes'][0]['overview_polyline']
              ['points'],
        );
        log(directionModel.toMap().toString());
        return directionModel;
      }
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }
}
