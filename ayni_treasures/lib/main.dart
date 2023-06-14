import 'package:ayni_treasures/View/category_page.dart';
import 'package:flutter/material.dart';
import 'package:ayni_treasures/View/press_page.dart';
import 'package:ayni_treasures/View/login_page.dart';
import 'package:ayni_treasures/View/store_page.dart';
import 'package:ayni_treasures/View/welcome_page.dart';
import 'package:ayni_treasures/View/signin_page.dart';
import 'View/styles.dart';
import 'View/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ayni Treasures',
      theme: ThemeData(
        primarySwatch: primarySwatch,
        fontFamily: 'Poppins'
      ),
      //initialRoute: "/",
      //home: const HomePage(),
      home: const WelcomePage(),
      routes: {
        //"/":(BuildContext context) => const WelcomePage(),
        "/login":(BuildContext context) => const LoginPage(),
        "/signin":(BuildContext context) => const SignInPage(),
        "/home":(BuildContext context) => const HomePage(),
        "/store":(BuildContext context) => const StorePage(),
        "/press":(BuildContext context) => const PressPage(),
        "/category":(BuildContext context) => const CategoryPage(),
        //"/school":(BuildContext context) => ,
      },
    );
  }
}



