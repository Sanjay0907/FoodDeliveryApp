import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:ubereatsresturant/constant/constant.dart';
import 'package:ubereatsresturant/controller/services/orderServices/orderServices.dart';
import 'package:ubereatsresturant/model/foodOrderModel/foodOrderModel.dart';
import 'package:ubereatsresturant/utils/colors.dart';
import 'package:ubereatsresturant/utils/textStyles.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  bool today = true;
  bool month = false;
  bool year = false;
  int currentTimestamp = DateTime.now().millisecondsSinceEpoch;

  // void checkTimestampIsToday(int timestamp) {
  //   DateTime now = DateTime.now();
  //   DateTime dateFromTimeStamp = DateTime.fromMillisecondsSinceEpoch(timestamp);
  //   if (dateFromTimeStamp.year == now.year) {
  //     if (dateFromTimeStamp.month == now.month) {
  //       if (dateFromTimeStamp.day == now.day) {}
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size(100.w, 10.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order Stats',
                      style: AppTextStyles.body18Bold,
                    ),
                    Builder(builder: (context) {
                      if (today) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              today = false;
                              month = true;

                              year = false;
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.7.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    3.sp,
                                  ),
                                  border: Border.all(color: black87)),
                              child: Text(
                                'Today',
                                style: AppTextStyles.body14,
                              )),
                        );
                      } else if (month) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              today = false;
                              month = false;

                              year = true;
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.7.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    3.sp,
                                  ),
                                  border: Border.all(color: black87)),
                              child: Text(
                                'Month',
                                style: AppTextStyles.body14,
                              )),
                        );
                      } else {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              today = true;
                              month = false;

                              year = false;
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.7.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    3.sp,
                                  ),
                                  border: Border.all(color: black87)),
                              child: Text(
                                'Year',
                                style: AppTextStyles.body14,
                              )),
                        );
                      }
                    })
                  ],
                ),
              )),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            children: [
              StreamBuilder(
                  stream: realTimeDatabaseRef
                      .child('OrderHistory')
                      .orderByChild('resturantUID')
                      .equalTo(auth.currentUser!.uid)
                      .onValue,
                  builder: (context, event) {
                    if (event.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    }
                    if (event.data == null) {
                      return Center(
                        child: Text(
                          'No Previous Orders',
                          style: AppTextStyles.body16,
                        ),
                      );
                    }
                    if (event.data != null) {
                      Map<dynamic, dynamic> values =
                          event.data!.snapshot.value as Map<dynamic, dynamic>;

                      List<FoodOrderModel> todayOrderDataList = [];
                      List<FoodOrderModel> monthOrderDataList = [];
                      List<FoodOrderModel> yearOrderDataList = [];
                      values.forEach((key, value) {
                        FoodOrderModel foodData = FoodOrderModel.fromMap(
                            jsonDecode(jsonEncode(value))
                                as Map<String, dynamic>);
                        DateTime now = DateTime.now();
                        DateTime dateFromTimeStamp =
                            DateTime.fromMillisecondsSinceEpoch(foodData
                                .orderDeliveredAt!.millisecondsSinceEpoch);
                        if (dateFromTimeStamp.year == now.year) {
                          yearOrderDataList.add(foodData);

                          if (dateFromTimeStamp.month == now.month) {
                            monthOrderDataList.add(foodData);
                            if (dateFromTimeStamp.day == now.day) {
                              todayOrderDataList.add(foodData);
                            }
                          }
                        }
                      });

                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: today
                              ? todayOrderDataList.length
                              : month
                                  ? monthOrderDataList.length
                                  : yearOrderDataList.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                          itemBuilder: (context, index) {
                            FoodOrderModel currentFoodData = today
                                ? todayOrderDataList[index]
                                : month
                                    ? monthOrderDataList[index]
                                    : yearOrderDataList[index];

                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 1.5.h),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 1.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  5.sp,
                                ),
                                border: Border.all(
                                  color: black87,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 20.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.sp),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            currentFoodData
                                                .foodDetails.foodImageURL,
                                          ),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Text(
                                    currentFoodData.foodDetails.name,
                                    style: AppTextStyles.body14Bold,
                                  ),
                                  SizedBox(
                                    height: 0.5.h,
                                  ),
                                  Text(
                                    currentFoodData.foodDetails.description,
                                    style: AppTextStyles.small12.copyWith(
                                      color: grey,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.5.h,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${(((int.parse(currentFoodData.foodDetails.actualPrice) - int.parse(currentFoodData.foodDetails.discountedPrice)) / int.parse(currentFoodData.foodDetails.actualPrice)) * 100).round().toString()} %',
                                            style: AppTextStyles.body14Bold,
                                          ),
                                          SizedBox(
                                            width: 2.w,
                                          ),
                                          FaIcon(
                                            FontAwesomeIcons.tag,
                                            color: success,
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            '₹${currentFoodData.foodDetails.actualPrice}',
                                            style:
                                                AppTextStyles.body14.copyWith(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: grey,
                                            ),
                                          ),
                                          Text(
                                            '₹${currentFoodData.foodDetails.discountedPrice}',
                                            style: AppTextStyles.body16Bold,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Quantity: \t\t',
                                          style: AppTextStyles.body14,
                                        ),
                                        TextSpan(
                                          text:
                                              '${currentFoodData.foodDetails.quantity}',
                                          style: AppTextStyles.body14,
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Total: \t\t',
                                          style: AppTextStyles.body14,
                                        ),
                                        TextSpan(
                                          text:
                                              '${currentFoodData.foodDetails.quantity! * int.parse(currentFoodData.foodDetails.discountedPrice)}',
                                          style: AppTextStyles.body14Bold,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // SwipeButton(
                                  //   thumbPadding: EdgeInsets.all(1.w),
                                  //   thumb: Icon(Icons.chevron_right, color: white),
                                  //   inactiveThumbColor: black,
                                  //   activeThumbColor: black,
                                  //   inactiveTrackColor:
                                  //       foodData.requestedForDelivery == null
                                  //           ? greyShade3
                                  //           : Colors.green.shade200,
                                  //   activeTrackColor:
                                  //       foodData.requestedForDelivery == null
                                  //           ? greyShade3
                                  //           : Colors.green.shade200,
                                  //   elevationThumb: 2,
                                  //   elevationTrack: 2,
                                  //   onSwipe: () {
                                  //     context
                                  //         .read<DeliveryPartnerProvider>()
                                  //         .sendDeliveryRequestToNearbyDeliveryPartner(
                                  //             foodData);
                                  //     realTimeDatabaseRef
                                  //         .child(
                                  //             'Orders/${foodData.orderID}/requestedForDelivery')
                                  //         .set(true);
                                  //   },
                                  //   child: Text(
                                  //     'Request for Delivery',
                                  //     style: AppTextStyles.body14Bold,
                                  //   ),
                                  // ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                ],
                              ),
                            );
                          });
                    }
                    return const SizedBox();
                  }),
              // FirebaseAnimatedList(
              //   shrinkWrap: true,
              //   physics: const NeverScrollableScrollPhysics(),
              //   padding: EdgeInsets.symmetric(vertical: 2.h),
              //   query: realTimeDatabaseRef
              //       .child('OrderHistory')
              //       .orderByChild('resturantUID')
              //       .equalTo(auth.currentUser!.uid),
              //   itemBuilder: (context, snapshot, animation, index) {
              //     FoodOrderModel foodData = FoodOrderModel.fromMap(
              //         jsonDecode(jsonEncode(snapshot.value))
              //             as Map<String, dynamic>);

              //   },
              // ),
            ],
          )),
    );
  }
}
