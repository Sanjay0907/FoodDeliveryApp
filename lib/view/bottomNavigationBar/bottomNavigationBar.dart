import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:ubereatsdriver/controller/provider/profileProvider/profileProvider.dart';
import 'package:ubereatsdriver/controller/provider/rideProvider/rideProvider.dart';
import 'package:ubereatsdriver/controller/services/pushNotificationServices/pushNotificationServices.dart';
import 'package:ubereatsdriver/utils/colors.dart';
import 'package:ubereatsdriver/view/HistoryScreen/historyScreen.dart';
import 'package:ubereatsdriver/view/account/account.dart';
import 'package:ubereatsdriver/view/homeScreen/homeScreen.dart';

class BottomNavigationBarUberEats extends StatefulWidget {
  const BottomNavigationBarUberEats({super.key});

  @override
  State<BottomNavigationBarUberEats> createState() =>
      _BottomNavigationBarUberEatsState();
}

class _BottomNavigationBarUberEatsState
    extends State<BottomNavigationBarUberEats> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      PushNotificationServices.initializeFCM(context);
      context.read<ProfileProvider>().getDeliveryGuyProfile();
      context.read<RideProvider>().createIcons(context);
    });
  }

  PersistentTabController controller = PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [const HomeScreen(), const HistoryScreen(), const AccountScreen()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const FaIcon(FontAwesomeIcons.house),
        title: "Home",
        activeColorPrimary: black,
        inactiveColorPrimary: grey,
      ),
      PersistentBottomNavBarItem(
        icon: const FaIcon(FontAwesomeIcons.list),
        title: "History",
        activeColorPrimary: black,
        inactiveColorPrimary: grey,
      ),
      PersistentBottomNavBarItem(
        icon: const FaIcon(FontAwesomeIcons.person),
        title: "Account",
        activeColorPrimary: black,
        inactiveColorPrimary: grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style6,
    );
  }
}
