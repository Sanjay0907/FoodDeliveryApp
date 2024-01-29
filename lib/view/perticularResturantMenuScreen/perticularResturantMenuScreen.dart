import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:ubereats/controller/provider/resturantProvider/resturantProvider.dart';
import 'package:ubereats/model/foodModel.dart';
import 'package:ubereats/utils/colors.dart';
import 'package:ubereats/utils/textStyles.dart';
import 'package:ubereats/view/foodDetailsScreen/foodDetailsScreen.dart';

class PerticularResturantMenuScreen extends StatefulWidget {
  const PerticularResturantMenuScreen(
      {super.key, required this.resturatnUID, required this.resturantName});
  final String resturatnUID;
  final String resturantName;

  @override
  State<PerticularResturantMenuScreen> createState() =>
      _PerticularResturantMenuScreenState();
}

class _PerticularResturantMenuScreenState
    extends State<PerticularResturantMenuScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ResturantProvider>().emptyResturantMenu();
      context.read<ResturantProvider>().getResturantMenu(widget.resturatnUID);
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
        title: Text(
          widget.resturantName,
          style: AppTextStyles.body16Bold,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Consumer<ResturantProvider>(
          builder: (context, resturatnProvider, child) {
        if (resturatnProvider.resturantMenu.isEmpty) {
          return Center(
            child: Text(
              'Fetching Food Items',
              style: AppTextStyles.body14Bold.copyWith(color: grey),
            ),
          );
        } else {
          return ListView.builder(
              itemCount: resturatnProvider.resturantMenu.length,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                FoodModel foodData = resturatnProvider.resturantMenu[index];
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
                            Column(
                              children: [
                                Text(
                                  '₹${foodData.actualPrice}',
                                  style: AppTextStyles.body14.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: grey,
                                  ),
                                ),
                                Text(
                                  '₹${foodData.discountedPrice}',
                                  style: AppTextStyles.body16Bold,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
        }
      }),
    ));
  }
}
