import 'package:ayni_treasures/View/home_page.dart';
import 'package:ayni_treasures/View/styles.dart';
import 'package:ayni_treasures/View/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import '../../../main.dart';
import 'app_welcome.dart';
class FutureBasedSplash extends State<AppWelcome>{
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,          // Load Splash screen for 10 seconds.
      navigateAfterSeconds: const WelcomePage(),       // Navigate to HomeScreen after defined duration.
      image: Image.asset('assets/icons/logo_jabi.png'),   // Load this image in the splash screen
      photoSize: 200, 
      loaderColor: Colors.white,
      styleTextUnderTheLoader : const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
      loadingText: const Text('Cargando...', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: customBackground)),
      backgroundColor: customSecondary,
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return SplashScreen(
  //     navigateAfterFuture: loadFromFuture(),  // Which screen to show after loading
  //     image: Image.asset('assets/icons/logo_jabi.png'),   // Show this image during loading
  //     photoSize: 200,
  //     loaderColor: Colors.white,
  //     styleTextUnderTheLoader : const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
  //     loadingText: const Text('Cargando...'),
  //     backgroundColor: customSecondary,
  //   );
  // }
}