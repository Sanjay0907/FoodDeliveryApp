// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:ubereatsdriver/constants/constant.dart';
import 'package:ubereatsdriver/controller/provider/rideProvider/rideProvider.dart';
import 'package:ubereatsdriver/controller/services/geoFireServices/geofireServices.dart';
import 'package:ubereatsdriver/controller/services/locationServices/locationServices.dart';
import 'package:ubereatsdriver/controller/services/orderServices/orderServices.dart';
import 'package:ubereatsdriver/model/driverModel/driverModel.dart';
import 'package:ubereatsdriver/model/foodOrderModel/foodOrderModel.dart';
import 'package:ubereatsdriver/utils/colors.dart';
import 'package:ubereatsdriver/utils/textStyles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> googleMapController = Completer();
  GoogleMapController? mapController;
  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(37.4, -122),
    zoom: 14,
  );
  static DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref().child('Driver/${auth.currentUser!.uid}');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          Container(
              // height: 10.h,
              width: 100.w,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              child: StreamBuilder(
                  stream: databaseReference.onValue,
                  builder: (context, event) {
                    if (event.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: black,
                        ),
                      );
                    }
                    if (event.data != null) {
                      DeliveryPartnerModel driverData =
                          DeliveryPartnerModel.fromMap(
                              jsonDecode(jsonEncode(event.data!.snapshot.value))
                                  as Map<String, dynamic>);

                      if (driverData.activeDeliveryRequestID == null) {
                        if (driverData.driverStatus == 'ONLINE') {
                          return SwipeButton(
                            thumbPadding: EdgeInsets.all(1.w),
                            thumb: Icon(Icons.chevron_right, color: white),
                            inactiveThumbColor: black,
                            activeThumbColor: black,
                            inactiveTrackColor: greyShade3,
                            activeTrackColor: greyShade3,
                            elevationThumb: 2,
                            elevationTrack: 2,
                            onSwipe: () {
                              GeofireServices.goOffline();
                            },
                            child: Text(
                              'Done for Today',
                              style: AppTextStyles.body14Bold,
                            ),
                          );
                        } else {
                          return SwipeButton(
                            thumbPadding: EdgeInsets.all(1.w),
                            thumb: Icon(Icons.chevron_right, color: white),
                            inactiveThumbColor: black,
                            activeThumbColor: black,
                            inactiveTrackColor: greyShade3,
                            activeTrackColor: greyShade3,
                            elevationThumb: 2,
                            elevationTrack: 2,
                            onSwipe: () {
                              GeofireServices.goOnline();
                              GeofireServices.updateLocationRealtime(context);
                            },
                            child: Text(
                              'Go Online',
                              style: AppTextStyles.body14Bold,
                            ),
                          );
                        }
                      } else {
                        return StreamBuilder(
                            stream: FirebaseDatabase.instance
                                .ref()
                                .child(
                                    'Orders/${driverData.activeDeliveryRequestID}')
                                .onValue,
                            builder: (context, event) {
                              if (event.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: black,
                                  ),
                                );
                              } else {
                                FoodOrderModel foodOrderData =
                                    FoodOrderModel.fromMap(jsonDecode(
                                            jsonEncode(
                                                event.data!.snapshot.value))
                                        as Map<String, dynamic>);
                                if (foodOrderData.orderStatus ==
                                    OrderServices.orderStatus(0)) {
                                  return SwipeButton(
                                    thumbPadding: EdgeInsets.all(1.w),
                                    thumb:
                                        Icon(Icons.chevron_right, color: white),
                                    inactiveThumbColor: black,
                                    activeThumbColor: black,
                                    inactiveTrackColor: greyShade3,
                                    activeTrackColor: greyShade3,
                                    elevationThumb: 2,
                                    elevationTrack: 2,
                                    onSwipe: () async {
                                      await realTimeDatabaseRef
                                          .child(
                                              'Orders/${driverData.activeDeliveryRequestID}/orderStatus')
                                          .set(OrderServices.orderStatus(1));
                                      FoodOrderModel foodData =
                                          await OrderServices.fetchOrderDetails(
                                              driverData
                                                  .activeDeliveryRequestID!);
                                      context
                                          .read<RideProvider>()
                                          .updateOrderData(foodData);
                                    },
                                    child: Text(
                                      'Food Picked',
                                      style: AppTextStyles.body14Bold,
                                    ),
                                  );
                                } else {
                                  return SwipeButton(
                                    thumbPadding: EdgeInsets.all(1.w),
                                    thumb:
                                        Icon(Icons.chevron_right, color: white),
                                    inactiveThumbColor: black,
                                    activeThumbColor: black,
                                    inactiveTrackColor: greyShade3,
                                    activeTrackColor: greyShade3,
                                    elevationThumb: 2,
                                    elevationTrack: 2,
                                    onSwipe: () async {
                                      await realTimeDatabaseRef
                                          .child(
                                              'Orders/${driverData.activeDeliveryRequestID}/orderStatus')
                                          .set(OrderServices.orderStatus(2));
                                      await OrderServices.addOrderDataToHistory(
                                        foodOrderData,
                                        context,
                                      );
                                      await realTimeDatabaseRef
                                          .child(
                                              'Driver/${auth.currentUser!.uid}/activeDeliveryRequestID')
                                          .remove();
                                      OrderServices.removeOrder(
                                          foodOrderData.orderID!);
                                      context
                                          .read<RideProvider>()
                                          .nullifyRideDatas();
                                    },
                                    child: Text(
                                      'Food Delivered',
                                      style: AppTextStyles.body14Bold,
                                    ),
                                  );
                                }
                              }
                            });
                      }
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        color: black,
                      ),
                    );
                  })),
          StreamBuilder(
              stream: databaseReference.onValue,
              builder: (context, event) {
                if (event.data != null) {
                  DeliveryPartnerModel driverData =
                      DeliveryPartnerModel.fromMap(
                          jsonDecode(jsonEncode(event.data!.snapshot.value))
                              as Map<String, dynamic>);
                  if (driverData.activeDeliveryRequestID != null) {
                    return StreamBuilder(
                        stream: FirebaseDatabase.instance
                            .ref()
                            .child(
                                'Orders/${driverData.activeDeliveryRequestID}')
                            .onValue,
                        builder: (context, foodOrderEvent) {
                          if (foodOrderEvent.data != null) {
                            FoodOrderModel foodOrderData =
                                FoodOrderModel.fromMap(jsonDecode(jsonEncode(
                                        foodOrderEvent.data!.snapshot.value))
                                    as Map<String, dynamic>);
                            return Builder(builder: (context) {
                              if (foodOrderData.orderStatus ==
                                  OrderServices.orderStatus(0)) {
                                return Expanded(child: Consumer<RideProvider>(
                                    builder: (context, rideProvider, child) {
                                  return GoogleMap(
                                    initialCameraPosition:
                                        initialCameraPosition,
                                    mapType: MapType.normal,
                                    myLocationButtonEnabled: true,
                                    myLocationEnabled: true,
                                    zoomControlsEnabled: true,
                                    polylines: rideProvider
                                        .polylineSetTowardsResturant,
                                    markers: rideProvider.deliveryMarker,
                                    zoomGesturesEnabled: true,
                                    onMapCreated:
                                        (GoogleMapController controller) async {
                                      googleMapController.complete(controller);
                                      mapController = controller;
                                      Position crrPositon =
                                          await LocationServices
                                              .getCurretnLocation();
                                      LatLng crrLatLng = LatLng(
                                        crrPositon.latitude,
                                        crrPositon.longitude,
                                      );
                                      CameraPosition cameraPosition =
                                          CameraPosition(
                                        target: crrLatLng,
                                        zoom: 14,
                                      );
                                      mapController!.animateCamera(
                                          CameraUpdate.newCameraPosition(
                                              cameraPosition));
                                    },
                                  );
                                }));
                              } else {
                                return Expanded(child: Consumer<RideProvider>(
                                    builder: (context, rideProvider, child) {
                                  return GoogleMap(
                                    initialCameraPosition:
                                        initialCameraPosition,
                                    mapType: MapType.normal,
                                    myLocationButtonEnabled: true,
                                    myLocationEnabled: true,
                                    zoomControlsEnabled: true,
                                    polylines:
                                        rideProvider.polylineSetTowardsDelivery,
                                    markers: rideProvider.deliveryMarker,
                                    zoomGesturesEnabled: true,
                                    onMapCreated:
                                        (GoogleMapController controller) async {
                                      googleMapController.complete(controller);
                                      mapController = controller;
                                      Position crrPositon =
                                          await LocationServices
                                              .getCurretnLocation();
                                      LatLng crrLatLng = LatLng(
                                        crrPositon.latitude,
                                        crrPositon.longitude,
                                      );
                                      CameraPosition cameraPosition =
                                          CameraPosition(
                                        target: crrLatLng,
                                        zoom: 14,
                                      );
                                      mapController!.animateCamera(
                                          CameraUpdate.newCameraPosition(
                                              cameraPosition));
                                    },
                                  );
                                }));
                              }
                            });
                          } else {
                            return Center(
                              child: CircularProgressIndicator(color: black),
                            );
                          }
                        });
                  } else {
                    return Expanded(
                      child: GoogleMap(
                        initialCameraPosition: initialCameraPosition,
                        mapType: MapType.normal,
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        zoomControlsEnabled: true,
                        zoomGesturesEnabled: true,
                        onMapCreated: (GoogleMapController controller) async {
                          googleMapController.complete(controller);
                          mapController = controller;
                          Position crrPositon =
                              await LocationServices.getCurretnLocation();
                          LatLng crrLatLng = LatLng(
                            crrPositon.latitude,
                            crrPositon.longitude,
                          );
                          CameraPosition cameraPosition = CameraPosition(
                            target: crrLatLng,
                            zoom: 14,
                          );
                          mapController!.animateCamera(
                              CameraUpdate.newCameraPosition(cameraPosition));
                        },
                      ),
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: black,
                    ),
                  );
                }
              })
        ],
      )),
    );
  }
}
