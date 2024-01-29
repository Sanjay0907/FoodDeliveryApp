// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:ubereats/constant/constant.dart';
import 'package:ubereats/controller/provider/profileProvider/profileProvider.dart';
import 'package:ubereats/controller/services/userDataCRUDServices/userDataCRUDServices.dart';
import 'package:ubereats/model/userAddressModel.dart';
import 'package:ubereats/utils/colors.dart';
import 'package:ubereats/utils/textStyles.dart';
import 'package:ubereats/view/addAddressScreen/addAddressScreen.dart';
import 'package:ubereats/widgets/commonElevatedButton.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().fetchUserAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: FaIcon(
              FontAwesomeIcons.arrowLeftLong,
              color: black,
            ),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          children: [
            SizedBox(
              height: 2.h,
            ),
            Consumer<ProfileProvider>(
                builder: (context, profileProvider, child) {
              if (profileProvider.addresses.isEmpty) {
                return Center(
                  child: Text(
                    'Fetching your address',
                    style: AppTextStyles.body14Bold.copyWith(color: grey),
                  ),
                );
              } else {
                List<UserAddressModel> addresses = profileProvider.addresses;
                return ListView.builder(
                    itemCount: addresses.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      UserAddressModel address = addresses[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 1.5.h),
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            5.sp,
                          ),
                          color: greyShade3,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  address.addressTitle,
                                  style: AppTextStyles.heading20Bold,
                                ),
                                CircleAvatar(
                                  radius: 1.h,
                                  backgroundColor:
                                      address.isActive ? success : transparent,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 0.8.h,
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'Room no:\t\t',
                                      style: AppTextStyles.body14Bold),
                                  TextSpan(
                                    text: address.roomNo,
                                    style: AppTextStyles.body14,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 0.8.h,
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'Apartment:\t\t',
                                      style: AppTextStyles.body14Bold),
                                  TextSpan(
                                    text: address.apartment,
                                    style: AppTextStyles.body14,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Builder(builder: (context) {
                              if (address.isActive) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.w, vertical: 1.h),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            5.sp,
                                          ),
                                          color: greyShade1),
                                      child: Text(
                                        'Edit',
                                        style: AppTextStyles.body14,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.w, vertical: 1.h),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            5.sp,
                                          ),
                                          color: greyShade1),
                                      child: Text(
                                        'Delete',
                                        style: AppTextStyles.body14,
                                      ),
                                    )
                                  ],
                                );
                              } else {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        await UserDataCRUDServices
                                            .setAddressAsActive(
                                                address, context);
                                        context
                                            .read<ProfileProvider>()
                                            .fetchUserAddresses();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.w, vertical: 1.h),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              5.sp,
                                            ),
                                            color: greyShade1),
                                        child: Text(
                                          'Set As Active',
                                          style: AppTextStyles.body14,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.w, vertical: 1.h),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            5.sp,
                                          ),
                                          color: greyShade1),
                                      child: Text(
                                        'Edit',
                                        style: AppTextStyles.body14,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.w, vertical: 1.h),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            5.sp,
                                          ),
                                          color: greyShade1),
                                      child: Text(
                                        'Delete',
                                        style: AppTextStyles.body14,
                                      ),
                                    )
                                  ],
                                );
                              }
                            }),
                          ],
                        ),
                      );
                    });
              }
            }),
            SizedBox(
              height: 4.h,
            ),
            CommonElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: const AddAddressScreen(),
                      type: PageTransitionType.rightToLeft,
                    ),
                  );
                },
                color: black,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.plus,
                      color: white,
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    Text(
                      'Add Address',
                      style: AppTextStyles.body14.copyWith(color: white),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
