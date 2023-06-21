import 'package:ayni_treasures/Entity/user_entity.dart';
import 'package:ayni_treasures/Model/user_model.dart';
import 'package:flutter/rendering.dart';
import '../Entity/product_entity.dart';
import '../Controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'styles.dart';
import './assets.dart';
import 'components/custom_components.dart';
import 'components/bottom_navbar.dart';
import 'components/singleton_envVar.dart';
import 'components/custom_futurebuilder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //late FormArguments argumentsLogin;
  //Obtenemos la informacion del usuario de SQL lite
  late final Future<User> currentUser;
  late final Future<List<Product>> listOnsaleProducts;
  late final Future<List<Product>> listNewArrivalsProducts;

  //Accedo al Singleton para obtener el usuario global
  Future<void> getCurrentUser() async {
    currentUser = UserModel().getUserByIdSqlLite(userid: appData.currentUserId);
  }

  //Funciones para traer los productos
  // Future<void> getListOnsaleProducts() async {
  //   listOnsaleProducts = ProductController().getProductsBySubcategory(subcategory: 'Frutas');
  // }
  // Future<void> getListNewArrivalsProducts() async {
  //   listNewArrivalsProducts = ProductController().getProductsBySubcategory(subcategory: 'Hortalizas');
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
    getCurrentUser();
    //getListOnsaleProducts();
    //getListNewArrivalsProducts();
  }

  @override
  Widget build(BuildContext context) {
    //final argumentsLogin = ModalRoute.of(context)?.settings.arguments as FormArguments;
    //final argsUser = ModalRoute.of(context)?.settings.arguments as User;
  
    return Scaffold(
      drawer: const Drawer(),
      appBar: CustomComponents.makeAppbar(titleAppBar: '',context: context),
      body: Container( 
        decoration: const BoxDecoration(
          color: customBackground
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomFutureBuilder<User>(
                    future: ()=>currentUser,
                    builder: (context, currentUser) {
                      //Se guarda la id del usuario de manera              
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [                      
                          SizedBox(
                            width: 190,
                            child: CustomComponents.makeText(headingType: 'H4', data: 'Hola, ${currentUser?.username}! (${currentUser?.district})', color: customPrimary),
                          ),
                          CustomComponents.makeText(headingType: 'P2', data: """En nuestra tienda encontrarás \nlo que necesitas para\nalimentarte sanamente.""", color: customPrimary)
                        ],
                      );
                    },
                    loadingWidget: const CircularProgressIndicator(),
                  ),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [                      
                  //     SizedBox(
                  //       width: 190,
                  //       child: CustomComponents.makeText(headingType: 'H4', data: 'Hola, ${currentUser.username}! (${currentUser.district})', color: customPrimary),
                  //     ),
                  //     CustomComponents.makeText(headingType: 'P2', data: """Aprende una nueva \npalabra aquí.""", color: customPrimary)
                  //   ],
                  // ),
                  SvgPicture.asset('assets/images/studyingBook.svg')
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              CustomComponents.categoryTitle(subtitle: 'Ofertas'),
              CustomFutureBuilder<List<Product>>(
                future: ()=>getListProducts(uriArgument: "Frutas"),
                builder: (context, listProducts) {
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      //shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: listProducts!.length,
                      itemBuilder: (BuildContext context, int index){
                        return CustomComponents.makeGeneralCard(imageUrl: listProducts[index].mainimage, subtitle: listProducts[index].fullname, price: 'S/. ${((double.parse(listProducts[index].price))*10).toStringAsFixed(1)}', height: 180);
                        // return CustomFutureBuilder<Product>(
                        //   future: ()=>bringOneProduct(index, listProducts),
                        //   builder: (context, user) {
                        //     return CustomComponents.makeText(headingType: 'P3', data: 'Usuario: ${user?.username}', color: customBlack, textAlign: TextAlign.center);
                        //   },
                        //   loadingWidget: const CircularProgressIndicator(),
                        //  );                          
                      }                    
                    ),
                  );
                },
                loadingWidget: const CircularProgressIndicator(),
              ),
              const SizedBox(height: 12),
              const Divider(),
              CustomComponents.categoryTitle(subtitle: 'Novedades'),
                CustomFutureBuilder<List<Product>>(
                future: ()=>getListProducts(uriArgument: "Tubérculos"),
                builder: (context, listProducts) {
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      //shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: listProducts!.length,
                      itemBuilder: (BuildContext context, int index){
                        return CustomComponents.makeGeneralCard(imageUrl: listProducts[index].mainimage, subtitle: listProducts[index].fullname, price: 'S/. ${((double.parse(listProducts[index].price))*10).toStringAsFixed(1)}', height: 180);                       
                      }                    
                    ),
                  );
                },
                loadingWidget: const CircularProgressIndicator(),
              ),
              
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }


}