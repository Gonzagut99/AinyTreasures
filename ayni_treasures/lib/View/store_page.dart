import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'styles.dart';
import './assets.dart';
import 'components/custom_components.dart';
import 'components/bottom_navbar.dart';
class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: CustomComponents.makeAppbar(titleAppBar: 'Tienda', context: context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            GestureDetector(child: CustomComponents.makeCardTile(title:'Productos alimenticios', imageUrl: 'https://storage.googleapis.com/imagenes-appcertus/pantallas/productosalimentarios_menu.jpg'), onTap: ()=>{CustomComponents.callbackNavSimple(arguments: 'Productos alimenticios', context: context, route: '/category')},),
            CustomComponents.makeCardTile(title: 'Plantas y semillas', imageUrl: 'https://storage.googleapis.com/imagenes-appcertus/pantallas/semillas_menu.jpg'),
            CustomComponents.makeCardTile(title: 'Accesorios', imageUrl: 'https://storage.googleapis.com/imagenes-appcertus/pantallas/accesorios_menu.jpg'),
            CustomComponents.makeCardTile(title: 'Otros', imageUrl: 'https://storage.googleapis.com/imagenes-appcertus/pantallas/otros_menu.jpg', colorText: customBlack),
          ],
          //function: CustomComponents.callbackNavSimple(arguments: 'Productos alimenticios', context: context, route: '/category'),title: 'Productos alimenticios', imageUrl: 'https://storage.googleapis.com/imagenes-appcertus/pantallas/productosalimentarios_menu.jpg')
        ),
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}