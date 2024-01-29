// ignore_for_file: use_build_context_synchronously, prefer_collection_literals

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ubereatsdriver/controller/services/directionServices/directionServices.dart';
import 'package:ubereatsdriver/controller/services/locationServices/locationServices.dart';
import 'package:ubereatsdriver/controller/services/orderServices/orderServices.dart';
import 'package:ubereatsdriver/model/directionModel/directionModel.dart';
import 'package:ubereatsdriver/model/foodOrderModel/foodOrderModel.dart';
import 'package:ubereatsdriver/utils/colors.dart';

class RideProvider extends ChangeNotifier {
  Position? currentPosition;
  // ! Google Maps Variable
  LatLng? deliveryGuyLocation;
  LatLng? deliveryLocation;
  Set<Marker> deliveryMarker = Set<Marker>();
  FoodOrderModel? orderData;

  // Marker
  BitmapDescriptor? destinationIcon;
  BitmapDescriptor? crrLocationIcon;
  bool inDelivery = false;
  List<LatLng> polylineCoordinatesListTowardsDelivery = [];
  List<LatLng> polylineCoordinatesListTowardsResturant = [];

  // Map Polyline Towards Delivery Location
  Set<Polyline> polylineSetTowardsDelivery = {};
  //  Map Polyline Towards Resturant
  Set<Polyline> polylineSetTowardsResturant = {};
  Polyline? polylineTowardsDelivery;
  Polyline? polylineTowardsResturant;
  LatLng? resturantLoaction;

  updateOrderData(FoodOrderModel data) {
    orderData = data;
    notifyListeners();
  }

  updateInDeliveryStatus(bool newStatus) {
    inDelivery = newStatus;
    notifyListeners();
  }

  updateCurrentPositon(Position crrPosition) {
    currentPosition = crrPosition;
    notifyListeners();
  }

  updateDeliveryLatLngs(LatLng deliveryGuy, LatLng resturant, LatLng delivery) {
    deliveryGuyLocation = deliveryGuy;
    resturantLoaction = resturant;
    deliveryLocation = delivery;
    notifyListeners();
  }

  decodePolyline(String encodedPolyline) {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> data = polylinePoints.decodePolyline(encodedPolyline);
    List<LatLng> polylineCoordinatesList = [];

    if (data.isNotEmpty) {
      for (var latLngPoints in data) {
        polylineCoordinatesList.add(
          LatLng(
            latLngPoints.latitude,
            latLngPoints.longitude,
          ),
        );
      }
    }
    Polyline poliline = Polyline(
      polylineId: const PolylineId('poliline'),
      color: black,
      points: polylineCoordinatesList,
      jointType: JointType.round,
      width: 3,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
    );
    return poliline;
  }

  fetchCrrLocationToResturantPoliline(BuildContext context) async {
    polylineSetTowardsResturant.clear();
    DirectionModel directionModel = await DirectionServices.getDirectionDetails(
      deliveryGuyLocation!,
      resturantLoaction!,
      context,
    );

    Polyline polyline = decodePolyline(directionModel.polylinePoints);
    polylineSetTowardsResturant.add(polyline);
    notifyListeners();
    log(polyline.toString());
  }

  fetchResturantToDeliveryPoliline(BuildContext context) async {
    polylineSetTowardsDelivery.clear();
    DirectionModel directionModel = await DirectionServices.getDirectionDetails(
      resturantLoaction!,
      deliveryLocation!,
      context,
    );
    Polyline polyline = decodePolyline(directionModel.polylinePoints);
    polylineSetTowardsDelivery.add(polyline);
    notifyListeners();
    log(polyline.toString());
  }

  createIcons(BuildContext context) {
    // CurrentLocationIcon
    ImageConfiguration imageConfigurationcrrLocation =
        createLocalImageConfiguration(context, size: const Size(2, 2));
    BitmapDescriptor.fromAssetImage(
            imageConfigurationcrrLocation, 'assets/images/ride/crrLocation.png')
        .then((icon) {
      crrLocationIcon = icon;
      notifyListeners();
    });
//  DestinationIcon
    ImageConfiguration imageConfigurationdestinationLocation =
        createLocalImageConfiguration(context, size: const Size(2, 2));
    BitmapDescriptor.fromAssetImage(imageConfigurationdestinationLocation,
            'assets/images/ride/destination.png')
        .then((icon) {
      destinationIcon = icon;
      notifyListeners();
    });
    log('Icons Created');
  }

  updateMarker(BuildContext context) async {
    deliveryMarker = Set<Marker>();
    Position crrPositon = await LocationServices.getCurretnLocation();
    FoodOrderModel itemOrderData = orderData!;
    LatLng resturantLocation = LatLng(
        itemOrderData.resturantDetails.address!.latitude!,
        itemOrderData.resturantDetails.address!.longitude!);
    LatLng deliveryLocation = LatLng(itemOrderData.userAddress!.latitude,
        itemOrderData.userAddress!.longitude);
    Marker currentLocationMarker = Marker(
      markerId: const MarkerId('CurrentDeliveryGuyLocation'),
      position: LatLng(crrPositon.latitude, crrPositon.longitude),
      icon: crrLocationIcon!,
    );
    log((itemOrderData.orderStatus == OrderServices.orderStatus(0)).toString());
    Marker destinationMarker = Marker(
      markerId: const MarkerId('DestinationLocation'),
      position: itemOrderData.orderStatus == OrderServices.orderStatus(0)
          ? resturantLocation
          : deliveryLocation,
      icon: destinationIcon!,
    );
    deliveryMarker.add(currentLocationMarker);
    deliveryMarker.add(destinationMarker);
    log(deliveryMarker.length.toString());
    notifyListeners();
    log('Markers Updated');
    if (inDelivery) {
      await Future.delayed(const Duration(seconds: 5), () async {
        await updateMarker(context);
      });
    }
  }

  nullifyRideDatas() {
    inDelivery = false;
    polylineCoordinatesListTowardsDelivery = [];
    polylineCoordinatesListTowardsResturant = [];
    deliveryMarker = Set<Marker>();
    polylineSetTowardsDelivery = {};
    polylineSetTowardsResturant = {};
    polylineTowardsDelivery = null;
    polylineTowardsResturant = null;
    resturantLoaction = null;
    deliveryLocation = null;
    orderData = null;
    notifyListeners();
  }
}
