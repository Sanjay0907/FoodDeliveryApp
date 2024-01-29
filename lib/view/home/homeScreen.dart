import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:ubereats/controller/provider/resturantProvider/resturantProvider.dart';
import 'package:ubereats/model/restaurantModel.dart';
import 'package:ubereats/utils/colors.dart';
import 'package:ubereats/utils/textStyles.dart';
import 'package:ubereats/view/perticularResturantMenuScreen/perticularResturantMenuScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List categories = [
    ['assets/images/categories/convenience.png', 'Convenience'],
    ['assets/images/categories/alcohol.png', 'Alcohol'],
    ['assets/images/categories/petSupplies.png', 'Pet Supplies'],
    ['assets/images/categories/icecream.png', 'Ice cream'],
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: ListView(
        physics: const BouncingScrollPhysics(),
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
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
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
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
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


          Consumer<ResturantProvider>(
              builder: (context, resturantProvider, child) {
            if (resturantProvider.resturants.isEmpty) {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 18.h,
                      width: 94.w,
                      margin: EdgeInsets.symmetric(
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          5.sp,
                        ),
                        color: greyShade3,
                      ),
                    );
                  });
            } else {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: resturantProvider.resturants.length,
                  itemBuilder: (context, index) {
                    CarouselController controller = CarouselController();
                    RestaurantModel resturant =
                        resturantProvider.resturants[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: PerticularResturantMenuScreen(
                              resturatnUID: resturant.restaurantUID!,
                              resturantName: resturant.restaurantName!,
                            ),
                            type: PageTransitionType.rightToLeft,
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 2.h),
                        margin: EdgeInsets.symmetric(
                          vertical: 1.5.h,
                        ),
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
                              height: 23.h,
                              width: 94.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    5.sp,
                                  ),
                                  border: Border.all(color: greyShade3)),
                              child: CarouselSlider(
                                carouselController: controller,
                                options: CarouselOptions(
                                  height: 23.h,
                                  autoPlay: true,
                                  viewportFraction: 1,
                                ),
                                items: resturant.bannerImages!
                                    .map(
                                      (image) => Container(
                                        width: 94.w,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(image),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Text(
                              resturant.restaurantName!,
                              style: AppTextStyles.body16Bold,
                            )
                          ],
                        ),
                      ),
                    );
                  });
            }
          }),
        ],
      )),
    );
  }
}
