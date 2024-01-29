import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:ubereatsresturant/controller/provider/FoodProvider/FoodProvider.dart';
import 'package:ubereatsresturant/controller/provider/authProvider/mobileAuthProvider.dart';
import 'package:ubereatsresturant/controller/provider/deliveryPartnerProvider/deliveryPartnerProvider.dart';
import 'package:ubereatsresturant/controller/provider/resturantRegisterProvider/resturantRegisterProvider.dart';
import 'package:ubereatsresturant/firebase_options.dart';
import 'package:ubereatsresturant/view/singInLogicScreen/signInLogicScreen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const UberEats());
}

class UberEats extends StatelessWidget {
  const UberEats({super.key});
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, _, __) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<MobileAuthProvider>(
            create: (_) => MobileAuthProvider(),
          ),
          ChangeNotifierProvider<ResturantProvider>(
            create: (_) => ResturantProvider(),
          ),
          ChangeNotifierProvider<FoodProvider>(
            create: (_) => FoodProvider(),
          ),
          ChangeNotifierProvider<DeliveryPartnerProvider>(
            create: (_) => DeliveryPartnerProvider(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(),
          home: const SignInLogicScreen(),
        ),
      );
    });
  }
}
