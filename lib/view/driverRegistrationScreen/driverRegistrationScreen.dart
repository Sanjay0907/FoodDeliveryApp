// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:ubereatsdriver/constants/constant.dart';
import 'package:ubereatsdriver/controller/provider/profileProvider/profileProvider.dart';
import 'package:ubereatsdriver/controller/services/profileServices/profileServices.dart';
import 'package:ubereatsdriver/model/driverModel/driverModel.dart';
import 'package:ubereatsdriver/utils/colors.dart';
import 'package:ubereatsdriver/utils/textStyles.dart';
import 'package:ubereatsdriver/widgets/commonElevatedButton.dart';
import 'package:ubereatsdriver/widgets/commonTextField.dart';

class DriverRegistrationScreen extends StatefulWidget {
  const DriverRegistrationScreen({super.key});

  @override
  State<DriverRegistrationScreen> createState() =>
      _DriverRegistrationScreenState();
}

class _DriverRegistrationScreenState extends State<DriverRegistrationScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController vehicleRegistraitonNumberController =
      TextEditingController();
  TextEditingController drivingLicenseNumber = TextEditingController();
  bool registerButtonPressed = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          children: [
            SizedBox(
              height: 2.h,
            ),
            Consumer<ProfileProvider>(
                builder: (context, profileProvider, child) {
              return InkWell(
                onTap: () async {
                  await context
                      .read<ProfileProvider>()
                      .pickImageFromGallery(context);
                },
                child: CircleAvatar(
                  radius: 5.h,
                  backgroundColor: black,
                  child: CircleAvatar(
                      backgroundColor: white,
                      radius: 5.h - 2,
                      backgroundImage: profileProvider.profileImage != null
                          ? FileImage(profileProvider.profileImage!)
                          : null,
                      child: profileProvider.profileImage == null
                          ? FaIcon(
                              FontAwesomeIcons.user,
                              size: 4.h,
                              color: black,
                            )
                          : null),
                ),
              );
            }),
            SizedBox(
              height: 4.h,
            ),
            CommonTextfield(
              controller: nameController,
              title: 'Name',
              hintText: 'name',
              keyboardType: TextInputType.name,
            ),
            SizedBox(
              height: 2.h,
            ),
            CommonTextfield(
              controller: vehicleRegistraitonNumberController,
              title: 'Vehicle Registration Number',
              hintText: 'Registration number',
              keyboardType: TextInputType.name,
            ),
            SizedBox(
              height: 2.h,
            ),
            CommonTextfield(
              controller: drivingLicenseNumber,
              title: 'Driving License Number',
              hintText: 'License number',
              keyboardType: TextInputType.name,
            ),
            SizedBox(
              height: 35.h,
            ),
            CommonElevatedButton(
                onPressed: () async {
                  setState(() {
                    registerButtonPressed = true;
                  });
                  await context
                      .read<ProfileProvider>()
                      .uploadImageAndGetImageURL(context);
                  DeliveryPartnerModel driverData = DeliveryPartnerModel(
                    name: nameController.text.trim(),
                    profilePicUrl:
                        context.read<ProfileProvider>().profileImageURL,
                    mobileNumber: auth.currentUser!.phoneNumber,
                    driverID: auth.currentUser!.uid,
                    vehicleRegistrationNumber:
                        vehicleRegistraitonNumberController.text.trim(),
                    drivingLicenseNumber: drivingLicenseNumber.text.trim(),
                    registeredDateTime: DateTime.now(),
                  );
                  ProfileServices.registerDriver(driverData, context);
                },
                color: black,
                child: registerButtonPressed
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
