import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:ubereats/controller/provider/resturantProvider/resturantProvider.dart';
import 'package:ubereats/model/foodModel.dart';
import 'package:ubereats/utils/colors.dart';
import 'package:ubereats/utils/textStyles.dart';
import 'package:ubereats/view/foodDetailsScreen/foodDetailsScreen.dart';

class GroceryScreen extends StatefulWidget {
  const GroceryScreen({super.key});

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  TextEditingController searchFoodController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size(
                100.w,
                12.h,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                child: TextField(
                  controller: searchFoodController,
                  cursorColor: black,
                  style: AppTextStyles.textFieldTextStyle,
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    context
                        .read<ResturantProvider>()
                        .searchFoodItems(value.trim());
                  },
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 2.w),
                    hintText: 'Search Food',
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
              )),
          body: Consumer<ResturantProvider>(
              builder: (context, resturantProvider, child) {
            if (resturantProvider.searchedFood.isEmpty) {
              return Center(
                child: Text(
                  'Search For Food',
                  style: AppTextStyles.body14Bold.copyWith(color: grey),
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: resturantProvider.searchedFood.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    FoodModel foodData = resturantProvider.searchedFood[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: FoodDetailsScreen(foodModel: foodData),
                            type: PageTransitionType.rightToLeft,
                          ),
                        );
                      },
                      child: Container(
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
                                Text(
                                  '₹${foodData.discountedPrice}',
                                  style: AppTextStyles.body16Bold,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }
          })),
    );
  }
}
