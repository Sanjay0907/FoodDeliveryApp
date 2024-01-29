import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:ubereats/controller/services/foodOrderServices/foodOrderServices.dart';
import 'package:ubereats/model/foodOrderModel/foodOrderModel.dart';
import 'package:ubereats/utils/colors.dart';
import 'package:ubereats/utils/textStyles.dart';
import 'package:ubereats/widgets/commonElevatedButton.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen(
      {super.key, required this.foodData, required this.cartOrderID});
  final FoodOrderModel foodData;
  final String cartOrderID;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: FaIcon(
              FontAwesomeIcons.arrowLeftLong,
              color: black,
            )),
        title: Text(
          'Checkout',
          style: AppTextStyles.body16Bold,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 1.5.h),
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(
            //     5.sp,
            //   ),
            //   border: Border.all(
            //     color: black87,
            //   ),
            // ),
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
                          widget.foodData.foodDetails.foodImageURL,
                        ),
                        fit: BoxFit.cover),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  widget.foodData.foodDetails.name,
                  style: AppTextStyles.body14Bold,
                ),
                SizedBox(
                  height: 0.5.h,
                ),
                Text(
                  widget.foodData.foodDetails.description,
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
                          '${(((int.parse(widget.foodData.foodDetails.actualPrice) - int.parse(widget.foodData.foodDetails.discountedPrice)) / int.parse(widget.foodData.foodDetails.actualPrice)) * 100).round().toString()} %',
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
                      '₹${widget.foodData.foodDetails.actualPrice}',
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Item Price: \t\t',
                            style: AppTextStyles.body14,
                          ),
                          TextSpan(
                            text:
                                '${int.parse(widget.foodData.foodDetails.discountedPrice)}',
                            style: AppTextStyles.body14Bold,
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Quantity: \t\t',
                            style: AppTextStyles.body14,
                          ),
                          TextSpan(
                            text: '${widget.foodData.foodDetails.quantity}',
                            style: AppTextStyles.body14Bold,
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Delivery Charges: \t\t',
                            style: AppTextStyles.body14,
                          ),
                          TextSpan(
                            text: '${widget.foodData.deliveryCharges}',
                            style: AppTextStyles.body14Bold,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
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
                                '₹ ${widget.foodData.deliveryCharges + (int.parse(widget.foodData.foodDetails.discountedPrice) * widget.foodData.foodDetails.quantity!)}',
                            style: AppTextStyles.body14Bold,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                CommonElevatedButton(
                  onPressed: () async {
                    FoodOrderServices.placeFoodOrderRequest(
                        widget.foodData, widget.cartOrderID, context);
                  },
                  color: black,
                  child: Text(
                    'Checkout',
                    style: AppTextStyles.body14Bold.copyWith(color: white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}
