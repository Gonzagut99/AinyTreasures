
import 'package:ayni_treasures/View/app_welcome.dart';
import 'package:ayni_treasures/View/category_page.dart';
import 'package:ayni_treasures/View/firebase_api.dart';
import 'package:ayni_treasures/View/profile_page.dart';
//firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//Screens
import 'package:ayni_treasures/View/press_page.dart';
import 'package:ayni_treasures/View/login_page.dart';
import 'package:ayni_treasures/View/store_page.dart';
import 'package:ayni_treasures/View/welcome_page.dart';
import 'package:ayni_treasures/View/signin_page.dart';
import 'View/checkout_page.dart';
import 'View/productdetail_page.dart';
import 'View/shoppingcart_page.dart';
import 'View/styles.dart';
import 'View/home_page.dart';

void main() async{
  //firebasecore para push notifications
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseApi().initNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ayni Treasures',
      theme: ThemeData(
        primarySwatch: primarySwatch,
        fontFamily: 'Poppins',
        dividerColor: customDarkGray
      ),
      //initialRoute: "/",
      //home: const HomePage(),
      home: const AppWelcome(),
      routes: {
        //"/":(BuildContext context) => const WelcomePage(),
        "/login":(BuildContext context) => const LoginPage(),
        "/signin":(BuildContext context) => const SignInPage(),
        "/home":(BuildContext context) => const HomePage(),
        "/store":(BuildContext context) => const StorePage(),
        "/press":(BuildContext context) => const PressPage(),
        "/category":(BuildContext context) => const CategoryPage(),
        "/profile":(BuildContext context) => const ProfilePage(),
        "/productDetail":(BuildContext context) => const ProductDetailPage(),
        "/cart":(BuildContext context) => const ShoppingCartPage(),
        "/checkout":(BuildContext context) => const CheckoutPage(),
        //"/school":(BuildContext context) => ,
      },
    );
  }
}



