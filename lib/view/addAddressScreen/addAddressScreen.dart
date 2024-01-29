// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:ubereats/constant/constant.dart';
import 'package:ubereats/controller/provider/profileProvider/profileProvider.dart';
import 'package:ubereats/controller/services/locationServices/locationServices.dart';
import 'package:ubereats/controller/services/userDataCRUDServices/userDataCRUDServices.dart';
import 'package:ubereats/model/userAddressModel.dart';
import 'package:ubereats/utils/colors.dart';
import 'package:ubereats/utils/textStyles.dart';
import 'package:ubereats/widgets/commonElevatedButton.dart';
import 'package:ubereats/widgets/commonTextField.dart';
import 'package:ubereats/widgets/toastService.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  TextEditingController houseNoController = TextEditingController();
  TextEditingController apartmentController = TextEditingController();
  TextEditingController savaeAddressAsController = TextEditingController();
  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(37.4, -122),
    zoom: 14,
  );
  Completer<GoogleMapController> googleMapController = Completer();
  GoogleMapController? mapController;
  bool registerButoonPressed = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: white,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: FaIcon(
              FontAwesomeIcons.arrowLeftLong,
              color: black,
            ),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 3.w,
            vertical: 2.h,
          ),
          children: [
            Text(
              'Add Address',
              style: AppTextStyles.heading22Bold,
            ),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              height: 40.h,
              width: 100.w,
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
            ),
            SizedBox(
              height: 2.h,
            ),
            CommonTextfield(
              controller: houseNoController,
              title: 'House no.',
              hintText: 'House/ Flat/ Block no.',
              keyboardType: TextInputType.name,
            ),
            SizedBox(
              height: 2.h,
            ),
            CommonTextfield(
              controller: apartmentController,
              title: 'Apartment',
              hintText: 'Apartment/ Road/ Area (Optional)',
              keyboardType: TextInputType.name,
            ),
            SizedBox(
              height: 2.h,
            ),
            CommonTextfield(
              controller: savaeAddressAsController,
              title: 'Save Address as',
              hintText: 'Work/ Home / Family',
              keyboardType: TextInputType.name,
            ),
            SizedBox(
              height: 4.h,
            ),
            CommonElevatedButton(
                onPressed: () async {
                  setState(() {
                    registerButoonPressed = true;
                  });

                  Position location =
                      await LocationServices.getCurretnLocation();
                      String addressID = uuid.v1().toString();
                  UserAddressModel addressData = UserAddressModel(
                    addressID: addressID,
                    userID: auth.currentUser!.uid,
                    latitude: location.latitude,
                    longitude: location.longitude,
                    roomNo: houseNoController.text.trim(),
                    apartment: apartmentController.text.trim(),
                    addressTitle: savaeAddressAsController.text.trim(),
                    uploadTime: DateTime.now(),
                    isActive: false,
                  );
                  await UserDataCRUDServices.addAddress(addressData, context);
                  Navigator.pop(context);
                  context.read<ProfileProvider>().fetchUserAddresses();
                  ToastService.sendScaffoldAlert(
                    msg: 'Address Added Successful',
                    toastStatus: 'SUCCESS',
                    context: context,
                  );
                },
                color: black,
                child: registerButoonPressed
                    ? CircularProgressIndicator(
                        color: white,
                      )
                    : Text(
                        'Register',
                        style: AppTextStyles.body16Bold.copyWith(color: white),
                      ))
          ],
        ),
      ),
    );
  }
}
