

import 'package:ayni_treasures/Entity/user_entity.dart';
import 'package:ayni_treasures/Model/user_model.dart';
import 'package:flutter/rendering.dart';
import '../Entity/product_entity.dart';
import '../Controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'styles.dart';
import 'components/custom_components.dart';
import 'components/bottom_navbar.dart';
import 'components/singleton_envVar.dart';
import 'components/custom_futurebuilder.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  // //late FormArguments argumentsLogin;
  // //Obtenemos la informacion del usuario de SQL lite
  // late final Future<User> currentUser;

  // //Accedo al Singleton para obtener el usuario global
  // Future<void> getCurrentUser() async {
  //   currentUser = UserModel().getUserByIdSqlLite(userid: appData.currentUserId);
  // }

  Future<List<Product>> getListProducts({required uriArgument}) async {
    Future<List<Product>> listProducts = ProductController().getProductsBySubcategory(subcategory: uriArgument);
    return listProducts;
  }
  Future<Product> bringOneProduct(int index, Future<List<Product>> listProducts) async{
    List<Product> list = await listProducts;
    return list[index];
  }


  @override
  void initState() {
    super.initState();
    //getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    //final argumentsLogin = ModalRoute.of(context)?.settings.arguments as FormArguments;
    //final argsUser = ModalRoute.of(context)?.settings.arguments as User;
    final argumentsCategory = ModalRoute.of(context)?.settings.arguments as String;
    late String imageCategory;
    final List<String> subCategories= ['Tubérculos','Hortalizas','Frutas','Frutos secos','Cereales','Menestras' ];
    List<bool> buttonStates = [false, false, false,false, false, false];
    String currentSubcategory = 'Frutas';
    void onButtonPressed(int index) {
      setState(() {
        for (int i = 0; i < buttonStates.length; i++) {
          buttonStates[i] = (i == index); // Establece el estado del botón seleccionado como true y los demás como false
        }
      });
      if (buttonStates[index]==true) {
        setState(() {
        currentSubcategory=subCategories[index];
      });
      }
    }

    void setCategory (argumentsCategory){
      switch (argumentsCategory) {
        case 'Productos alimenticios':
          imageCategory = 'https://storage.googleapis.com/imagenes-appcertus/pantallas/productosalimentarios_menu.jpg';
          break;
        case 'Plantas y semillas':
          imageCategory = 'https://storage.googleapis.com/imagenes-appcertus/pantallas/semillas_menu.jpg';
          break;
        case 'Accesorios':
          imageCategory = 'https://storage.googleapis.com/imagenes-appcertus/pantallas/accesorios_menu.jpg';
          break;
        case 'Otros':
          imageCategory = 'https://storage.googleapis.com/imagenes-appcertus/pantallas/otros_menu.jpg';
          break;
        default:
      }
    }
    setCategory(argumentsCategory);
    return Scaffold(
      backgroundColor: customBackground,
      extendBodyBehindAppBar: false,
      drawer: const Drawer(),
      appBar: CustomComponents.makeAppbar(titleAppBar: 'Tienda',context: context),
      body: Column(
        children: [
          Container(
            //constraints: const BoxConstraints.expand(),
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageCategory),
                fit: BoxFit.cover
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomComponents.makeText(headingType: 'H2', data: argumentsCategory, color: customBackground,textAlign: TextAlign.start)
              ]
            ),
          ),
          Expanded( 
            // decoration: const BoxDecoration(
            //   color: customBackground
            // ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
              children: [
                //Botones categorias
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    //shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: subCategories.length,
                    itemBuilder: (BuildContext context, int index){
                      EdgeInsets margin = const EdgeInsets.only(right: 8.0);
                      // if (index == itemCount - 1) {
                      //   margin = EdgeInsets.zero;
                      // }
                      return InkWell(
                        child: Container(
                          margin: margin,
                          child: ElevatedButton(
                            onPressed: ()=>{onButtonPressed(int.parse(index.toString())),},
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                              backgroundColor: customSecondary,
                              padding: const EdgeInsets.fromLTRB(20,10,20,10),
                              //padding: const EdgeInsets.all(20),
                            ),
                            child: Text(
                              subCategories[index],
                              style:const TextStyle(
                                fontSize: 16.0,
                                color: customBackground,
                                fontWeight: FontWeight.w300,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );                      
                    }                    
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(),
                CustomComponents.categoryTitle(subtitle: currentSubcategory),
                CustomFutureBuilder<List<Product>>(
                  future: ()=>getListProducts(uriArgument: currentSubcategory),
                  builder: (context, listProducts) {
                    return Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverGrid(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Número de columnas en el grid
                              crossAxisSpacing: 12, // Espacio horizontal entre los elementos
                              mainAxisSpacing: 8, // Espacio vertical entre los elementos
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                final item = listProducts?[index];
                                return CustomComponents.makeGeneralCard(imageUrl: item!.mainimage, subtitle: item.fullname, price: 'S/. ${((double.parse(item.price))*10).toStringAsFixed(1)}', height: 180);
                              },
                              childCount: listProducts?.length,
                            ),
                          ),
                        ],
                      ),
                    );
                    // return SizedBox(
                    //   height: 200,
                    //   child: ListView.builder(
                    //     //shrinkWrap: true,
                    //     scrollDirection: Axis.horizontal,
                    //     itemCount: listProducts!.length,
                    //     itemBuilder: (BuildContext context, int index){
                    //       return CustomComponents.makeGeneralCard(imageUrl: listProducts[index].mainimage, subtitle: listProducts[index].fullname, price: 'S/. ${((double.parse(listProducts[index].price))*10).toStringAsFixed(1)}', height: 180);                       
                    //     }                    
                    //   ),
                    // );
                  },
                  loadingWidget: const CircularProgressIndicator(),
                ),
                    
                ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }


}