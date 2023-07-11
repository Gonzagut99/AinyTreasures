import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class PayInfoSubscreen extends StatefulWidget {
  final Function(int) changeScreen;
  const PayInfoSubscreen({super.key, required this.changeScreen});

  @override
  State<PayInfoSubscreen> createState() => _PayInfoSubscreenState();
}

class _PayInfoSubscreenState extends State<PayInfoSubscreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}