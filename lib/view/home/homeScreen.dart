import 'dart:convert';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:ubereatsresturant/constant/constant.dart';
import 'package:ubereatsresturant/controller/provider/deliveryPartnerProvider/deliveryPartnerProvider.dart';
import 'package:ubereatsresturant/controller/services/orderServices/orderServices.dart';
import 'package:ubereatsresturant/model/foodOrderModel/foodOrderModel.dart';
import 'package:ubereatsresturant/utils/colors.dart';
import 'package:ubereatsresturant/utils/textStyles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List categories = [
    [
      'assets/images/categories/convenience.png',
      'Convenience',
    ],
    [
      'assets/images/categories/alcohol.png',
      'Alcohol',
    ],
    [
      'assets/images/categories/petSupplies.png',
      'Pet Supplies',
    ],
    [
      'assets/images/categories/icecream.png',
      'Ice cream',
    ],
  ];

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
            Text(
              'Current Location',
              style: AppTextStyles.body16Bold,
            ),
            SizedBox(
              height: 2.h,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        5.sp,
                      ),
                      color: greyShade3,
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'American',
                          style: AppTextStyles.small12Bold,
                        ),
                        const Image(
                            image: AssetImage(
                                'assets/images/categories/american.png'))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        5.sp,
                      ),
                      color: greyShade3,
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Grocery',
                          style: AppTextStyles.small12Bold,
                        ),
                        const Image(
                            image: AssetImage(
                                'assets/images/categories/grocery.png'))
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 1.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: categories
                  .map((e) => Column(
                        children: [
                          Container(
                            height: 22.w,
                            width: 22.w,
                            decoration: BoxDecoration(
                              color: greyShade3,
                              borderRadius: BorderRadius.circular(
                                5.sp,
                              ),
                            ),
                            child: Image(image: AssetImage(e[0])),
                          ),
                          SizedBox(
                            height: 0.5.h,
                          ),
                          Text(
                            e[1],
                            style: AppTextStyles.small12Bold,
                          )
                        ],
                      ))
                  .toList(),
            ),
            SizedBox(
              height: 2.h,
            ),
            Divider(
              thickness: 1.h,
              color: greyShade3,
            ),
            SizedBox(
              height: 2.h,
            ),
            FirebaseAnimatedList(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 2.h),
              query: realTimeDatabaseRef
                  .child('Orders')
                  .orderByChild('resturantUID')
                  .equalTo(auth.currentUser!.uid),
              itemBuilder: (context, snapshot, animation, index) {
                FoodOrderModel foodData = FoodOrderModel.fromMap(
                    jsonDecode(jsonEncode(snapshot.value))
                        as Map<String, dynamic>);

                return Builder(builder: (context) {
                  if (foodData.orderStatus == OrderServices.orderStatus(0)) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 1.5.h),
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
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
                                    foodData.foodDetails.foodImageURL,
                                  ),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Text(
                            foodData.foodDetails.name,
                            style: AppTextStyles.body14Bold,
                          ),
                          SizedBox(
                            height: 0.5.h,
                          ),
                          Text(
                            foodData.foodDetails.description,
                            style: AppTextStyles.small12.copyWith(
                              color: grey,
                            ),
                          ),
                          SizedBox(
                            height: 1.5.h,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${(((int.parse(foodData.foodDetails.actualPrice) - int.parse(foodData.foodDetails.discountedPrice)) / int.parse(foodData.foodDetails.actualPrice)) * 100).round().toString()} %',
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
                                    '₹${foodData.foodDetails.actualPrice}',
                                    style: AppTextStyles.body14.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      color: grey,
                                    ),
                                  ),
                                  Text(
                                    '₹${foodData.foodDetails.discountedPrice}',
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
                                  text: '${foodData.foodDetails.quantity}',
                                  style: AppTextStyles.body14Bold,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          SwipeButton(
                            thumbPadding: EdgeInsets.all(1.w),
                            thumb: Icon(Icons.chevron_right, color: white),
                            inactiveThumbColor: black,
                            activeThumbColor: black,
                            inactiveTrackColor:
                                foodData.requestedForDelivery == null
                                    ? greyShade3
                                    : Colors.green.shade200,
                            activeTrackColor:
                                foodData.requestedForDelivery == null
                                    ? greyShade3
                                    : Colors.green.shade200,
                            elevationThumb: 2,
                            elevationTrack: 2,
                            onSwipe: () {
                              context
                                  .read<DeliveryPartnerProvider>()
                                  .sendDeliveryRequestToNearbyDeliveryPartner(
                                      foodData);
                              realTimeDatabaseRef
                                  .child(
                                      'Orders/${foodData.orderID}/requestedForDelivery')
                                  .set(true);
                            },
                            child: Text(
                              'Request for Delivery',
                              style: AppTextStyles.body14Bold,
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
