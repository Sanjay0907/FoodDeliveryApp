import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:ubereatsdriver/constants/constant.dart';
import 'package:ubereatsdriver/model/foodOrderModel/foodOrderModel.dart';
import 'package:ubereatsdriver/utils/colors.dart';
import 'package:ubereatsdriver/utils/textStyles.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
                      .orderByChild('deliveryGuyUID')
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
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
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
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: 'Resturant: ',
                                                  style: AppTextStyles.body14),
                                              TextSpan(
                                                text: currentFoodData
                                                    .resturantDetails
                                                    .restaurantName,
                                                style: AppTextStyles.body14,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        Text(
                                          DateFormat('d MMM, h:mm a').format(
                                            currentFoodData.orderDeliveredAt!,
                                          ),
                                          style: AppTextStyles.small10.copyWith(
                                            color: grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '₹ ${currentFoodData.deliveryCharges}',
                                    style: AppTextStyles.body16Bold,
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
