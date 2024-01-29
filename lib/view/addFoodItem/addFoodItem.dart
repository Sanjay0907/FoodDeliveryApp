// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:ubereatsresturant/constant/constant.dart';
import 'package:ubereatsresturant/controller/provider/FoodProvider/FoodProvider.dart';
import 'package:ubereatsresturant/controller/services/foodDataCRUDServices/foodDataCRUDServices.dart';
import 'package:ubereatsresturant/model/addFoodModel/addFooModel.dart';
import 'package:ubereatsresturant/utils/colors.dart';
import 'package:ubereatsresturant/utils/textStyles.dart';
import 'package:ubereatsresturant/widgets/commonElevatedButton.dart';
import 'package:ubereatsresturant/widgets/textfieldWidget.dart';

class AddFoodItemScreen extends StatefulWidget {
  const AddFoodItemScreen({super.key});

  @override
  State<AddFoodItemScreen> createState() => _AddFoodItemScreenState();
}

class _AddFoodItemScreenState extends State<AddFoodItemScreen> {
  TextEditingController foodNameController = TextEditingController();
  TextEditingController foodDescriptionController = TextEditingController();
  TextEditingController discountedPriceController = TextEditingController();
  TextEditingController actualPriceController = TextEditingController();
  bool foodIsPureVegetarian = true;
  bool pressedAddFoodItemButton = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: FaIcon(
              FontAwesomeIcons.arrowLeftLong,
              color: black,
            )),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        children: [
          SizedBox(
            height: 2.h,
          ),
          Consumer<FoodProvider>(builder: (context, addFoodProvider, child) {
            return InkWell(
              onTap: () async {
                await addFoodProvider.pickFoodImageFromGallery(context);
              },
              child: Container(
                  height: 20.h,
                  width: 94.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.sp),
                    color: greyShade3,
                  ),
                  child: Builder(builder: (context) {
                    if (addFoodProvider.foodImage != null) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        child: Image(
                          image: FileImage(addFoodProvider.foodImage!),
                          fit: BoxFit.contain,
                        ),
                      );
                    } else {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 5.h,
                            width: 5.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: black,
                              ),
                            ),
                            child: FaIcon(
                              FontAwesomeIcons.plus,
                              size: 3.h,
                              color: black,
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Text(
                            'Add',
                            style: AppTextStyles.body14,
                          )
                        ],
                      );
                    }
                  })),
            );
          }),
          SizedBox(
            height: 4.h,
          ),
          CommonTextfield(
            controller: foodNameController,
            title: 'Name',
            hintText: 'Food Name',
            keyboardType: TextInputType.name,
          ),
          SizedBox(
            height: 2.h,
          ),
          CommonTextfield(
            controller: foodDescriptionController,
            title: 'Description',
            hintText: 'Food Description',
            keyboardType: TextInputType.name,
          ),
          SizedBox(
            height: 2.h,
          ),
          CommonTextfield(
            controller: actualPriceController,
            title: 'Actual Price',
            hintText: 'Actual Food Price',
            keyboardType: TextInputType.number,
          ),
          SizedBox(
            height: 2.h,
          ),
          CommonTextfield(
            controller: discountedPriceController,
            title: 'Discounted Price',
            hintText: 'Discounted Food Price',
            keyboardType: TextInputType.number,
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            'Food is Vegeterian',
            style: AppTextStyles.body16Bold,
          ),
          SizedBox(
            height: 0.8.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    foodIsPureVegetarian = true;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 3.h,
                      width: 3.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: foodIsPureVegetarian
                            ? Colors.green.shade100
                            : transparent,
                        borderRadius: BorderRadius.circular(
                          3.sp,
                        ),
                        border: Border.all(
                          color: foodIsPureVegetarian ? black : grey,
                        ),
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.check,
                        size: 2.h,
                        color: foodIsPureVegetarian ? black : transparent,
                      ),
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    Text(
                      'Vegeterian',
                      style: AppTextStyles.body14,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    foodIsPureVegetarian = false;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 3.h,
                      width: 3.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: !foodIsPureVegetarian
                            ? Colors.red.shade100
                            : transparent,
                        borderRadius: BorderRadius.circular(
                          3.sp,
                        ),
                        border: Border.all(
                          color: !foodIsPureVegetarian ? black : grey,
                        ),
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.check,
                        size: 2.h,
                        color: !foodIsPureVegetarian ? black : transparent,
                      ),
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    Text(
                      'Non-Vegeterian',
                      style: AppTextStyles.body14,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 4.h,
          ),
          CommonElevatedButton(
            onPressed: () async {
              setState(() {
                pressedAddFoodItemButton = true;
              });
              await context
                  .read<FoodProvider>()
                  .uploadImageAndGetImageURL(context);
              String foodID = uuid.v1().toString();
              FoodModel data = FoodModel(
                name: foodNameController.text.trim(),
                foodID: foodID,
                uploadTime: DateTime.now(),
                resturantUID: auth.currentUser!.uid,
                description: foodDescriptionController.text.trim(),
                foodImageURL: context.read<FoodProvider>().foodImageURL!,
                isVegetrain: foodIsPureVegetarian,
                actualPrice: actualPriceController.text.trim(),
                discountedPrice: discountedPriceController.text.trim(),
              );
              await FoodDataCRUDServices.uploadFoodData(context, data);
              await context.read<FoodProvider>().getFoodData();
            },
            child: pressedAddFoodItemButton
                ? CircularProgressIndicator(
                    color: white,
                  )
                : Text(
                    'Add Food',
                    style: AppTextStyles.body16Bold.copyWith(color: white),
                  ),
          )
        ],
      ),
    ));
  }
}
