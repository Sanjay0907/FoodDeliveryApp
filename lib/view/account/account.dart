import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:ubereats/controller/provider/profileProvider/profileProvider.dart';
import 'package:ubereats/model/userModel.dart';
import 'package:ubereats/utils/colors.dart';
import 'package:ubereats/utils/textStyles.dart';
import 'package:ubereats/view/addressScreen/addressScreen.dart';
import 'package:ubereats/view/orderHistory/orderHistory.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  List account = [
    [FontAwesomeIcons.shop, 'Orders'],
    [FontAwesomeIcons.locationPin, 'Address'],
    [FontAwesomeIcons.heart, 'Your favourites'],
    [FontAwesomeIcons.star, 'Restaurant Rewards'],
    [FontAwesomeIcons.wallet, 'Wallet'],
    [FontAwesomeIcons.gift, 'Send a gift'],
    [FontAwesomeIcons.suitcase, 'Buisness preferences'],
    [FontAwesomeIcons.person, 'Help'],
    [FontAwesomeIcons.tag, 'Promotion'],
    [FontAwesomeIcons.ticket, 'Uber Pass'],
    [FontAwesomeIcons.suitcase, 'Deliver with uber'],
    [FontAwesomeIcons.gear, 'Settings'],
    [FontAwesomeIcons.powerOff, 'Sign Out'],
  ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().fetchUserData();
    });
  }

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
          Consumer<ProfileProvider>(builder: (context, profileProvider, child) {
            if (profileProvider.userData == null) {
              return Row(
                children: [
                  CircleAvatar(
                    radius: 3.h,
                    backgroundColor: black,
                    child: CircleAvatar(
                      radius: 3.h - 2,
                      backgroundColor: white,
                      child: FaIcon(
                        FontAwesomeIcons.user,
                        size: 3.h,
                        color: grey,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    'Hello User',
                    style: AppTextStyles.body16,
                  ),
                ],
              );
            } else {
              UserModel userData = profileProvider.userData!;
              return Row(
                children: [
                  CircleAvatar(
                    radius: 3.h,
                    backgroundColor: black,
                    child: CircleAvatar(
                      radius: 3.h - 2,
                      backgroundColor: white,
                      backgroundImage: NetworkImage(userData.profilePicURL),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    userData.name,
                    style: AppTextStyles.body16,
                  ),
                ],
              );
            }
          }),
          SizedBox(
            height: 4.h,
          ),
          ListView.builder(
              itemCount: account.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    if(index == 0){
                       Navigator.push(
                        context,
                        PageTransition(
                          child: const OrderHistoryScreen(),
                          type: PageTransitionType.rightToLeft,
                        ),
                      );
                    }
                    if (index == 1) {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: const AddressScreen(),
                          type: PageTransitionType.rightToLeft,
                        ),
                      );
                    }
                  },
                  leading: FaIcon(
                    account[index][0],
                    size: 2.h,
                    color: black,
                  ),
                  title: Text(
                    account[index][1],
                    style: AppTextStyles.body14,
                  ),
                );
              })
        ],
      )),
    );
  }
}
