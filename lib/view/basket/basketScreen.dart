// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:ubereats/constant/constant.dart';
import 'package:ubereats/controller/provider/itemOrderProvider/itemOrderProvider.dart';
import 'package:ubereats/controller/provider/profileProvider/profileProvider.dart';
import 'package:ubereats/controller/services/directionServices/directionServices.dart';
import 'package:ubereats/controller/services/fetchResturantsServices/fetchResturantServices.dart';
import 'package:ubereats/controller/services/foodOrderServices/foodOrderServices.dart';
import 'package:ubereats/model/directionModel/directionModel.dart';
import 'package:ubereats/model/foodModel.dart';
import 'package:ubereats/model/foodOrderModel/foodOrderModel.dart';
import 'package:ubereats/model/restaurantModel.dart';
import 'package:ubereats/model/userAddressModel.dart';
import 'package:ubereats/utils/colors.dart';
import 'package:ubereats/utils/textStyles.dart';
import 'package:ubereats/view/checkoutScreen/checkoutScreen.dart';
import 'package:ubereats/widgets/commonElevatedButton.dart';

class BasketScreen extends StatefulWidget {
  const BasketScreen({super.key});

  @override
  State<BasketScreen> createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<ItemOrderProvider>().fetchCartItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Cart Items',
              style: AppTextStyles.body18Bold,
            ),
            backgroundColor: white,
          ),
          body: Consumer<ItemOrderProvider>(
              builder: (context, itemOrderProvider, child) {
            if (itemOrderProvider.cartItems.isEmpty) {
              return Center(
                child: Text(
                  'Add Items to Cart',
                  style: AppTextStyles.body14Bold,
                ),
              );
            } else {
              return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                  itemCount: itemOrderProvider.cartItems.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    FoodModel foodData = itemOrderProvider.cartItems[index];
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
                                    foodData.foodImageURL,
                                  ),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Text(
                            foodData.name,
                            style: AppTextStyles.body14Bold,
                          ),
                          SizedBox(
                            height: 0.5.h,
                          ),
                          Text(
                            foodData.description,
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
                                    '${(((int.parse(foodData.actualPrice) - int.parse(foodData.discountedPrice)) / int.parse(foodData.actualPrice)) * 100).round().toString()} %',
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
                              Text(
                                '₹${foodData.actualPrice}',
                                style: AppTextStyles.body14.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // if (quantity > 0) {
                                      //   setState(() {
                                      //     quantity -= 1;
                                      //   });
                                      // }
                                      FoodOrderServices.updateQuantity(
                                        foodData.orderID!,
                                        foodData.quantity!,
                                        context,
                                        false,
                                      );
                                    },
                                    child: Container(
                                      height: 3.h,
                                      width: 3.h,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          3.sp,
                                        ),
                                        border: Border.all(
                                          color: black87,
                                        ),
                                      ),
                                      child: FaIcon(
                                        FontAwesomeIcons.minus,
                                        size: 2.h,
                                        color: black,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '\t\t ${foodData.quantity} \t\t',
                                    style: AppTextStyles.body14Bold,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      FoodOrderServices.updateQuantity(
                                        foodData.orderID!,
                                        foodData.quantity!,
                                        context,
                                        true,
                                      );

                                      // setState(() {
                                      //   quantity += 1;
                                      // });
                                    },
                                    child: Container(
                                      height: 3.h,
                                      width: 3.h,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          3.sp,
                                        ),
                                        border: Border.all(
                                          color: black87,
                                        ),
                                      ),
                                      child: FaIcon(
                                        FontAwesomeIcons.plus,
                                        size: 2.h,
                                        color: black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '₹${int.parse(foodData.discountedPrice) * foodData.quantity!}',
                                style: AppTextStyles.body16Bold,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          CommonElevatedButton(
                            onPressed: () async {
                              RestaurantModel resturantData =
                                  await ResturantServices.fetchResturantData(
                                      foodData.resturantUID);
                              String orderID = uuid.v1();
                              UserAddressModel userAddress = context
                                  .read<ProfileProvider>()
                                  .activeAddress!;
                              LatLng pickupLocation = LatLng(
                                  resturantData.address!.latitude!,
                                  resturantData.address!.longitude!);
                              LatLng dropLocation = LatLng(
                                userAddress.latitude,
                                userAddress.longitude,
                              );
                              DirectionModel directionData =
                                  await DirectionServices.getDirectionDetails(
                                pickupLocation,
                                dropLocation,
                                context,
                              );
                              int deliveryCharge = int.parse((double.parse(
                                          (directionData.distanceInMeter / 1000)
                                              .toString()) *
                                      10)
                                  .round()
                                  .toString());

                              FoodOrderModel foodOrderData = FoodOrderModel(
                                deliveryCharges: deliveryCharge,
                                resturantUID: resturantData.restaurantUID!,
                                userUID: auth.currentUser!.uid,
                                foodDetails: foodData,
                                resturantDetails: resturantData,
                                userAddress: context
                                    .read<ProfileProvider>()
                                    .activeAddress,
                                userData:
                                    context.read<ProfileProvider>().userData,
                                orderID: orderID,
                                orderStatus: FoodOrderServices.orderStatus(0),
                                orderPlacedAt: DateTime.now(),
                                // orderDeliveredAt: orderDeliveredAt,
                              );
                              Navigator.push(
                                context,
                                PageTransition(
                                  child:
                                      CheckoutScreen(foodData: foodOrderData, cartOrderID: foodData.orderID!,),
                                  type: PageTransitionType.rightToLeft,
                                ),
                              );
                              // FoodOrderServices.placeFoodOrderRequest(
                              //     foodOrderData, context);
                            },
                            color: black,
                            child: Text(
                              'Order now',
                              style: AppTextStyles.body14Bold
                                  .copyWith(color: white),
                            ),
                          )
                        ],
                      ),
                    );
                  });
            }
          })),
    );
  }
}
