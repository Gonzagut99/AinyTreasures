import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ReviewCheckoutSubscreen extends StatefulWidget {
  final Function(int) changeScreen;
  const ReviewCheckoutSubscreen({super.key, required this.changeScreen});

  @override
  State<ReviewCheckoutSubscreen> createState() => _ReviewCheckoutSubscreenState();
}

class _ReviewCheckoutSubscreenState extends State<ReviewCheckoutSubscreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}