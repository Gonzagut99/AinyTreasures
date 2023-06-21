import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'futurebased_splash.dart';

class AppWelcome extends StatefulWidget {
  const AppWelcome({super.key});

  @override
  State<AppWelcome> createState() => _AppWelcomeState();
}

class _AppWelcomeState extends State<AppWelcome> {
  @override
  Widget build(BuildContext context) {
    return FutureBasedSplash().build(context);
  }
}