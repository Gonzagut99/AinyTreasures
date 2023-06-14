import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'styles.dart';
import './assets.dart';
import 'components/custom_components.dart';
import 'components/bottom_navbar.dart';
class PressPage extends StatefulWidget {
  const PressPage({super.key});

  @override
  State<PressPage> createState() => _PressPageState();
}

class _PressPageState extends State<PressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: CustomComponents.makeAppbar(titleAppBar: 'Prensa', context: context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomComponents.makeInfoCard(title: 'Conoce todo el Perú', description: 'Con nuestro nuevo catalogo de lugares turísticos podrás vivir experiencias inolvidables', height: 100, backgroundColor: customTernary),
            const SizedBox(height: 12),
            const Divider(),
            CustomComponents.categoryTitle(subtitle: 'Descubre'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(child: CustomComponents.makeGeneralCard(imageUrl: 'https://detrujillo.com/wp-content/uploads/2013/10/Huanchaco_Totora5.jpg', height: 160, title: 'Costa',width: 172)),
                FittedBox(child: CustomComponents.makeGeneralCard(imageUrl: 'https://animalesdelperu.com/wp-content/uploads/2017/09/Vicuna.jpg.webp', height: 160, title: 'Sierra',width: 172)),                
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(child: CustomComponents.makeGeneralCard(imageUrl: 'https://elperuano.pe/fotografia/thumbnail/2021/11/07/000138274M.jpg', height: 160, title: 'Selva',width: 172)),
                FittedBox(child: CustomComponents.makeGeneralCard(imageUrl: 'https://portal.andina.pe/EDPfotografia3/Thumbnail/2022/09/01/000895081W.jpg', height: 160, title: 'Recomendados',width: 172)),                
              ]
              
            )
          ],
        ),
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}