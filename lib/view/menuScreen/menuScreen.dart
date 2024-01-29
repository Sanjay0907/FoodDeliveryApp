import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:ubereatsresturant/controller/provider/FoodProvider/FoodProvider.dart';
import 'package:ubereatsresturant/model/addFoodModel/addFooModel.dart';
import 'package:ubereatsresturant/utils/colors.dart';
import 'package:ubereatsresturant/utils/textStyles.dart';
import 'package:ubereatsresturant/view/addFoodItem/addFoodItem.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoodProvider>().getFoodData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: black,
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  child: const AddFoodItemScreen(),
                  type: PageTransitionType.rightToLeft,
                ),
              );
            },
            child: FaIcon(
              FontAwesomeIcons.plus,
              color: white,
            ),
          ),
          body: Consumer<FoodProvider>(builder: (context, foodProvider, child) {
            if (foodProvider.items.isEmpty) {
              return Center(
                child: Text(
                  'Add Food Items',
                  style: AppTextStyles.body14Bold.copyWith(color: grey),
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: foodProvider.items.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    FoodModel foodData = foodProvider.items[index];
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
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '₹${foodData.discountedPrice}',
                                    style: AppTextStyles.body14.copyWith(
                                        decoration: TextDecoration.lineThrough,
                                        color: grey),
                                  ),
                                  Text(
                                    '₹${foodData.actualPrice}',
                                    style: AppTextStyles.body16Bold,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
            }
          })),
    );
  }
}
