import 'dart:async';
//para File
import 'dart:io';

import 'package:ayni_treasures/Controller/deliveryinfo_controller.dart';
import 'package:ayni_treasures/View/components/imageprofile_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
//Imagepicker
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

//Widgets y MVC
import '../Entity/deliveryinfo_entity.dart';
import '../Entity/paymentinfo_entity.dart';
import '../Entity/ordersale_entity.dart';
import '../Entity/shoppingcartitem_entity.dart';
import 'components/bottom_navbar.dart';
import 'components/delivinfo_subscreen.dart';
import 'components/payinfo_subscreen.dart';
import 'components/reviewcheckout_subscreen.dart';
import 'styles.dart';
import './assets.dart';
import 'components/custom_components.dart';
import 'components/form_items.dart';
import '../Controller/user_controller.dart';
import '../View/components/custom_futurebuilder.dart';
import 'components/singleton_envVar.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  //Proceso de checkout estados
  bool isActiveDelivInfo = true;
  bool isActiveCardInfo = false;
  bool isActiveReview = false;

  final String idUser = appData.currentUserId!;

  int currentScreenIndex = 0;

  //Cambia la pantalla en la que se encuentra
  void changeScreen(int index) {
    setState(() {
      currentScreenIndex = index;
    });
  }

  List<bool> loadedSubScreens = [
    true, // SubScreen1 is initially loaded
    false, // SubScreen2 is initially not loaded
    false, // SubScreen3 is initially not loaded
  ];

  void loadSubScreen(int index) {
    setState(() {
      loadedSubScreens[index] = true;
    });
  }
  
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomComponents.makeSimpleAppbar(context: context,title: 'Comprar', color: customPrimary,colorLeadingIcon: customBackground),
      body: Container(
        //height:MediaQuery.of(context).size.height*0.4,
        //width:MediaQuery.of(context).size.width,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildCheckoutProcessBar(),
            const SizedBox(
              height: 12,
            ),
            //row
            Column(
              //mainAxisSize: MainAxisSize.max,
              children: [
                if (currentScreenIndex == 0)
                  SizedBox(
                    height:  MediaQuery.of(context).size.height*0.65,
                    child: DelivInfoSubscreen(changeScreen: changeScreen)),
                if (currentScreenIndex == 1)
                  PayInfoSubscreen(changeScreen: changeScreen),
                if (currentScreenIndex == 2)
                  ReviewCheckoutSubscreen(changeScreen: changeScreen),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }

  Row buildCheckoutProcessBar() {
    return Row(
      children: [
        Container(
          height: 80,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
          decoration: const BoxDecoration(color: customLightGray),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              checkoutProcessIcons(isActive: isActiveDelivInfo, iconActive: deliveryBoxIconActive, iconInactive: deliveryBoxIcon, label: 'Envío'),
              checkoutProcessIcons(isActive: isActiveCardInfo, iconActive: cardPaymentIconActive, iconInactive: cardPaymentIcon, label: 'Pago'),
              checkoutProcessIcons(isActive: isActiveReview, iconActive: reviewCheckoutIconActive, iconInactive: reviewCheckoutIcon, label: 'Confirmar')
            ],
          ),
        )
      ],
    );
  }

  GestureDetector checkoutProcessIcons({required bool isActive, required String iconActive, required String iconInactive, required String label}) {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            isActive?iconActive:iconInactive,
          ),
          const SizedBox(height: 4,),
          CustomComponents.makeText(headingType: 'H6', data: label, color: isActive?customSecondary:customDarkGray)
        ],
      ),
    );
  }

  
}
