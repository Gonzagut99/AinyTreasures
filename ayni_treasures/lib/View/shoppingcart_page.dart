import 'package:ayni_treasures/Controller/shoppingcartitem_controller.dart';
import 'package:ayni_treasures/Entity/shoppingcartitem_entity.dart';
import 'package:ayni_treasures/View/styles.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'components/bottom_navbar.dart';
import 'components/custom_components.dart';
import 'components/custom_futurebuilder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'components/math_calculations.dart';
import 'components/singleton_envVar.dart';


class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  //Datos globales y con estado
  final String currentUserId = appData.currentUserId!;
  //Cargamos la informacion una sola vez
  final ShoppingCartItemController _cartItemController = ShoppingCartItemController();
  late Future<List<ShoppingCartItem>> _cartItemsFuture;
  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    if (!_isDataLoaded) {
      _cartItemsFuture = _cartItemController.getShoppingCartItemsByUserId(userId: currentUserId);
      _isDataLoaded = true;
    }
  }

  //controlador del Cuadro de totales
  bool totalsWidgetSelected = true;
  
  String cartItemsQuantity = '0';
  String subtotal="0.0";
  double subtotaldouble=0;
  String discounts="0.0";
  double discountdouble =0;
  String generalTotal="0.0";
  double generalTotalDouble =0;

  // Actualiza los datos del cuadro de totales
  void updateTotals() {
    cartItemsQuantity = appData.cartItems.length.toString();

    subtotaldouble = 0;
    discountdouble = 0;
    generalTotalDouble = 0;

    for (var element in appData.cartItems) {
      subtotaldouble += double.parse(MathCalculations().roundedValueTwoDecimals(double.parse(element.totalprice)));
      discountdouble += double.parse(MathCalculations().getDiscount(totalPrice: MathCalculations().roundedValueTwoDecimals(double.parse(element.totalprice)), discount: MathCalculations().roundedValueTwoDecimals(double.parse(element.discount))));
      //generalTotalDouble += double.parse(MathCalculations().getDiscountedPrice(totalPrice: element.totalprice, discount: element.totalprice));
    }
    generalTotalDouble=subtotaldouble-discountdouble;

    // Llama a setState después de la construcción de la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        subtotal = MathCalculations().roundedValueTwoDecimals(subtotaldouble);
        discounts = MathCalculations().roundedValueTwoDecimals(discountdouble);
        generalTotal = MathCalculations().roundedValueTwoDecimals(generalTotalDouble);
      });
    });
  }

  void removeFromCart(List<ShoppingCartItem> cartItems, int index) {
    //appData.cartItems.removeWhere((element) => element.idcartitem==appData.cartItems[index].idcartitem);
    ShoppingCartItemController()
        .deleteShoppingCartItem(cartItems[index].idcartitem)
        .then(
      (value) {
        if (value == 'Proceso exitoso') {
          const snackBar = SnackBar(
            content: Text('Producto borrado'),
            duration: Duration(seconds: 2), // Duración en segundos
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          const snackBar = SnackBar(
            content: Text('No se pudo borrar'),
            duration: Duration(seconds: 2), // Duración en segundos
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
    );
    setState(() {
      appData.cartItems.removeAt(index);
    });
  }

  String selectedMeasureFormatting ({required String selectedMeasure}){
    if (selectedMeasure == 'kilos') {
      return 'x kg.';
    } else {
      return 'x 50gr.';
    }
  }

  String makePriceString({required String basePrice}){
    return 'S/. $basePrice${MathCalculations().roundedValueTwoDecimalsFormatting(basePrice)}';    
  }

  String adaptPriceAccMeasure({required String originalPrice, required String selectedMeasure}){
    double doubleProductPrice = double.parse(originalPrice);
    if (selectedMeasure == 'kilos') {
      doubleProductPrice*=10;
      final rounded = MathCalculations().roundedValueTwoDecimals(doubleProductPrice);
      return 'S/. $rounded${MathCalculations().roundedValueTwoDecimalsFormatting(doubleProductPrice.toString())} x kg.';
    } else {
      doubleProductPrice/=2;
      final rounded =MathCalculations().roundedValueTwoDecimals(doubleProductPrice);
      return 'S/. $rounded${MathCalculations().roundedValueTwoDecimalsFormatting(doubleProductPrice.toString())} x 50gr.';
    }
  }
  

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: customBackground,
      extendBodyBehindAppBar: false,
      drawer: const Drawer(),
      appBar: CustomComponents.makeSimpleAppbar(
          context: context,
          title: "Jaba de compras",
          color: customPrimary,
          colorLeadingIcon: customBackground),
      body: buildContent(),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }

  Stack buildContent() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16,12,16,0),
          child: ListView(        
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                CustomComponents.makeText(headingType: 'H3', data: 'Mi Jaba', color: customPrimary)
              ],),
              const SizedBox(height: 12,),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.71,
                child: CustomFutureBuilder(
                  //se llama a la lista unica de la peticion get
                  future: () => _cartItemsFuture,
                  builder: (context, listProducts) {
                    //se guarda la lista de manera local y global
                    appData.cartItems=listProducts!;
                    //Se actualizan los datos del cuadro de totales
                    updateTotals(); // Actualiza los totales después de obtener los elementos del carrito
                    //se genera la lista
                    return ListView.builder(
                      itemCount: listProducts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 8),
                          child: buildCartItem(appData.cartItems, index),                      
                          );
                      },
                    );
                  },
                  loadingWidget: const CircularProgressIndicator(
                    color: customPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Floating container resumen
        makeTotalReviewChart()
      ],
    );
  }

  AnimatedPositioned makeTotalReviewChart() {
    return AnimatedPositioned(
        left: 16.0,
        //bottom: totalsWidgetSelected?-146:16,
        bottom: totalsWidgetSelected?16:-154,
        duration: const Duration(milliseconds: 600),
        curve: Curves.fastOutSlowIn,
        child: Container(
          width:  MediaQuery.of(context).size.width*0.50,
          //width: 200,
          height: 188,
          decoration: BoxDecoration(
            color: customWhite,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: customPrimary, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],

          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
            child: Column(
              children: [
                SizedBox(
                  height: 28,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomComponents.makeText(headingType: 'H5', data: 'Resumen', color: customPrimary),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            totalsWidgetSelected= !totalsWidgetSelected;
                          });
                        },
                        icon: !totalsWidgetSelected?
                         const Icon(Icons.arrow_drop_up_rounded,size: 28,color: customPrimary,):
                         const Icon(Icons.arrow_drop_down_rounded,size: 28,color: customPrimary,),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomComponents.makeText(headingType: 'H6', data: 'Productos:', color: customDarkGray),
                    CustomComponents.makeText(headingType: 'PR2', data: cartItemsQuantity, color: customDarkGray),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomComponents.makeText(headingType: 'H6', data: 'Subtotal:', color: customDarkGray),
                    CustomComponents.makeText(headingType: 'PR2', data: 'S/. $subtotal${MathCalculations().roundedValueTwoDecimalsFormatting(subtotal)}', color: customDarkGray),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomComponents.makeText(headingType: 'H6', data: 'Descuentos:', color: customDarkGray),
                    CustomComponents.makeText(headingType: 'PR2', data: '-S/. $discounts${MathCalculations().roundedValueTwoDecimalsFormatting(discounts)}', color: customDarkGray),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomComponents.makeText(headingType: 'H5', data: 'Total:', color: customBlack),
                    CustomComponents.makeText(headingType: 'H5', data: 'S/. $generalTotal${MathCalculations().roundedValueTwoDecimalsFormatting(generalTotal)}', color: customBlack),
                  ],
                ),
                //Boton ir a comprar
                Row(
                  children: [
                    Expanded(
                      child: CustomComponents.makeButton(
                        btnColor: customSecondary,
                        callback: (){
                          for (var carItem in appData.cartItems) {
                            ShoppingCartItemController().updateShoppingCartItem(
                              iduser: carItem.iduser,
                              idproduct: carItem.idproduct,
                              idcartitem: carItem.idcartitem,
                              productname: carItem.productname,
                              productprice: carItem.productprice,
                              mainimage: carItem.mainimage,
                              selectedmeasure: carItem.selectedmeasure,
                              totalquantity: carItem.totalquantity,
                              discount: carItem.discount,
                              totalprice: carItem.totalprice,
                              totalwithdiscount: carItem.totalwithdiscount);
                          }
                          appData.totals['quantity']=appData.cartItems.length;
                          appData.totals['subtotal']=subtotal;
                          appData.totals['discounts']=discounts;
                          appData.totals['total']=generalTotal;
                          CustomComponents.callbackNavSimple(context: context, route: '/checkout');                          
                        },
                        content: 'Comprar',
                      ),
                    )
                  ],
                ),

              ],
            ),
          ),
        ),
      );
  }

  Stack buildCartItem(List<ShoppingCartItem> cartItems, int index) {
    return Stack(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: customPrimary, width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      buildCartItemImage(cartItems, index),
                      const SizedBox(width: 8,),
                      buildNameQuantityCol(cartItems, index),
                      const SizedBox(width: 8,),
                      buildTotalsInfCartItem(cartItems, index),
            
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        //Boton de eliminar cartItem
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: customDarkGray, width: 1.0),//Personaliza el color según sea necesario
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.close,
                  color:customDarkGray, size: 18,), // Personaliza el icono según sea necesario
              onPressed: () {
                removeFromCart(cartItems,index);
              },
            ),
            
          ),
        ),
      ],
    );
  }

  SizedBox buildNameQuantityCol(List<ShoppingCartItem> cartItems, int index) {
    return SizedBox(
      width: 120,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomComponents.makeText(
              headingType: 'P1',
              data: cartItems[index].productname,
              color: customPrimary),
          CustomComponents.makeText(
              headingType: 'P2',
              data:'(${adaptPriceAccMeasure(originalPrice: cartItems[index].productprice, selectedMeasure: cartItems[index].selectedmeasure)})',
              color: customPrimary),
          const SizedBox(
            height: 4,
          ),
          Container(
            height: 36,
            decoration: BoxDecoration(
                border: Border.all(color: customDarkGray, width: 1.0),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    int quantityint = int.parse(cartItems[index].totalquantity);
                    if (quantityint==1) {
                      return;
                    } else {
                      quantityint--;
                      double doubTotalPrice = quantityint*double.parse(MathCalculations().calcActualProductPrice(selectedMeasure: cartItems[index].selectedmeasure, productPrice: cartItems[index].productprice));
                      double doubTotalPricewithDiscount;
                      double doubdiscount;
                      setState(() {
                        cartItems[index].totalquantity=quantityint.toString();
                        cartItems[index].totalprice=MathCalculations().roundedValueTwoDecimals(doubTotalPrice);
                        doubdiscount=double.parse(MathCalculations().getDiscount(totalPrice:  cartItems[index].totalprice, discount:  cartItems[index].discount));
                        doubTotalPricewithDiscount = doubTotalPrice-doubdiscount;
                        cartItems[index].totalwithdiscount=MathCalculations().roundedValueTwoDecimals(doubTotalPricewithDiscount);
                      });
                    }
                    
                  },
                  icon: const Icon(Icons.remove,size: 18,color: customPrimary,),
                  padding: const EdgeInsets.all(4),
                ),
                CustomComponents.makeText(
                    headingType: 'PR2',
                    data: cartItems[index].totalquantity,
                    color: customBlack),
                IconButton(
                  onPressed: () {
                    int quantityint = int.parse(cartItems[index].totalquantity);
                    quantityint++;
                    double doubTotalPrice = quantityint*double.parse(MathCalculations().calcActualProductPrice(selectedMeasure: cartItems[index].selectedmeasure, productPrice: cartItems[index].productprice));
                    double doubTotalPricewithDiscount;
                    double doubdiscount;
                    setState(() {
                      cartItems[index].totalquantity=quantityint.toString();
                      cartItems[index].totalprice=MathCalculations().roundedValueTwoDecimals(doubTotalPrice);
                      doubdiscount=double.parse(MathCalculations().getDiscount(totalPrice:  cartItems[index].totalprice, discount:  cartItems[index].discount));
                      doubTotalPricewithDiscount = doubTotalPrice-doubdiscount;
                      cartItems[index].totalwithdiscount=MathCalculations().roundedValueTwoDecimals(doubTotalPricewithDiscount);
                    });
                  },
                  icon: const Icon(Icons.add,size: 18,color: customPrimary,),
                  padding: const EdgeInsets.all(4),
                ),
              ],
            ),
          ),
          //cantidad en kilos y gramos
          Container(
            //alignment: Alignment.center,
            child: CustomComponents.makeText(
                headingType: 'P3',
                data: MathCalculations().calcActualQuantity(
                    selectedMeasure: cartItems[index].selectedmeasure,
                    portionQuantity: cartItems[index].totalquantity),
                color: customPrimary),
          )
        ],
      ),
    );
  }

  Column buildTotalsInfCartItem(List<ShoppingCartItem> cartItems, int index) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomComponents.makeText(
            headingType: 'H5', data: 'Totales', color: customDarkGray),
        const SizedBox(
          height: 4,
        ),
        //subtotal
        CustomComponents.makeText(
            headingType: 'PR2',
            data: makePriceString(
              basePrice: cartItems[index].totalprice),
            color: customDarkGray),
        //descuento
        CustomComponents.makeText(
            headingType: 'PR2',
            data:'-${makePriceString(
                  basePrice: MathCalculations().getDiscount(totalPrice: cartItems[index].totalprice, discount: cartItems[index].discount))}',
            color: customDarkGray),
        const SizedBox(
          height: 6,
        ),
        //total
        CustomComponents.makeText(
            headingType: 'H5',
            data: makePriceString(
                basePrice: cartItems[index].totalwithdiscount),
            color: customBlack),
        const SizedBox(
          height: 6,
        ),
      ],
    );
  }

  Container buildCartItemImage(List<ShoppingCartItem> cartItems, int index) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: customDarkGray,
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
            //colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.8),BlendMode.dstATop),
            image: NetworkImage(cartItems[index].mainimage),
            fit: BoxFit.cover),
      ),
    );
  }
  
  
}