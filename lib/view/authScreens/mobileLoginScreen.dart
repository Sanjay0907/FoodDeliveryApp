import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:ubereatsdriver/controller/provider/authProvider/mobileAuthProvider.dart';
import 'package:ubereatsdriver/controller/services/authServices/mobileAuthServices.dart';
import 'package:ubereatsdriver/utils/colors.dart';
import 'package:ubereatsdriver/utils/textStyles.dart';

class MobileLoginScreen extends StatefulWidget {
  const MobileLoginScreen({super.key});

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  String selectedCountry = '+91';
  TextEditingController mobileController = TextEditingController();
  bool receiveOTPButtonPressed = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        receiveOTPButtonPressed = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        children: [
          SizedBox(
            height: 3.h,
          ),
          Text(
            'Enter your mobile number',
            style: AppTextStyles.body16,
          ),
          SizedBox(
            height: 3.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    showPhoneCode:
                        true, // optional. Shows phone code before the country name.
                    onSelect: (Country country) {
                      setState(() {
                        selectedCountry = '+${country.phoneCode}';
                      });
                      print('Select country: ${country.displayName}');
                    },
                  );
                },
                child: Container(
                  height: 6.h,
                  width: 25.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        4.sp,
                      ),
                      border: Border.all(color: grey)
                      // color: greyShade3,
                      ),
                  child: Text(
                    selectedCountry,
                    style: AppTextStyles.body14,
                  ),
                ),
              ),
              SizedBox(
                width: 65.w,
                child: TextField(
                  controller: mobileController,
                  cursorColor: black,
                  style: AppTextStyles.textFieldTextStyle,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 2.w),
                    hintText: 'Mobile number',
                    hintStyle: AppTextStyles.textFieldHintTextStyle,
                    // filled: true,
                    // fillColor: greyShade3,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: black,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: grey,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: grey,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 3.h,
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  receiveOTPButtonPressed = true;
                });
                context.read<MobileAuthProvider>().updateMobileNumber(
                    '$selectedCountry${mobileController.text.trim()}');
                MobileAuthServices.receiveOTP(
                    context: context,
                    mobileNo:
                        '$selectedCountry${mobileController.text.trim()}');
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: black, minimumSize: Size(90.w, 6.h)),
              child: receiveOTPButtonPressed
                  ? CircularProgressIndicator(
                      color: white,
                    )
                  : Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Next',
                            style: AppTextStyles.body16.copyWith(color: white),
                          ),
                        ),
                        Positioned(
                          right: 2.w,
                          child: Icon(
                            Icons.arrow_forward,
                            color: white,
                            size: 4.h,
                          ),
                        )
                      ],
                    )),
          SizedBox(
            height: 3.w,
          ),
          Text(
            'By proceeding, you consent to get calls, Whatsapp or SMS messages, including by automated means, from uber and its affiliates to the number provided.',
            style: AppTextStyles.small12.copyWith(
              color: grey,
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: grey,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Text(
                  'or',
                  style: AppTextStyles.small12.copyWith(
                    color: grey,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: grey,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 2.h,
          ),
          ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: white,
                  minimumSize: Size(90.w, 6.h),
                  elevation: 2),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Continue with google',
                      style: AppTextStyles.body16,
                    ),
                  ),
                  Positioned(
                    left: 2.w,
                    child: FaIcon(
                      FontAwesomeIcons.google,
                      color: black,
                      size: 3.h,
                    ),
                  )
                ],
              ))
        ],
      )),
    );
  }
}
