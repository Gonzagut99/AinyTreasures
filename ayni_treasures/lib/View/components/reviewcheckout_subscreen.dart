import 'package:ayni_treasures/Controller/deliveryinfo_controller.dart';
import 'package:ayni_treasures/Controller/paymentinfo_controller.dart';
import 'package:ayni_treasures/View/components/singleton_envVar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'custom_futurebuilder.dart';

import '../styles.dart';
import 'custom_components.dart';
import 'math_calculations.dart';

class ReviewCheckoutSubscreen extends StatefulWidget {
  final Function(int) changeScreen;
  const ReviewCheckoutSubscreen({super.key, required this.changeScreen});

  @override
  State<ReviewCheckoutSubscreen> createState() => _ReviewCheckoutSubscreenState();
}

class _ReviewCheckoutSubscreenState extends State<ReviewCheckoutSubscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        //height: MediaQuery.of(context).size.height*0.60,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: ListView(children: [
            const SizedBox(
              height: 12,
            ),
            //row
            Flexible(
              child: buildContent(context)),
            const SizedBox(
              height: 12,
            ),
          ]),
        ),
      ),
    );
  }
  
  Row buildContent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FittedBox(
            //constraints: const BoxConstraints.expand(),
            child: SizedBox(
              width: 350,
              //height: 700,
              child:
                //formularios
                buildTiles(context),
            ),
          ),
        ),
      ],
    );
  }

  Column buildTiles(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:CrossAxisAlignment.start,
      children: <Widget>[        
        CustomComponents.makeText(headingType: 'H4', data: 'Enviar a', color: customPrimary),
        const SizedBox(height: 8,),
        buildDeliveryData(),
        const SizedBox(height: 12,),
        CustomComponents.makeText(headingType: 'H4', data: 'Tipo de Envío', color: customPrimary),
        const SizedBox(height: 8,),
        buildTypeDelivery(),
        const SizedBox(height: 12,),
        CustomComponents.makeText(headingType: 'H4', data: 'Payment', color: customPrimary),
        const SizedBox(height: 8,),
        buildPaymentData(),
        const SizedBox(height: 12,),
        //Totales
        makeTotalReviewChart(),
        const SizedBox(height: 12,),
        //Boton ir a comprar
        Row(
          children: [
            Expanded(
              child: CustomComponents.makeButton(
                btnColor: customSecondary,
                callback: () {
                  CustomComponents.callbackNav(context:context , route: '/home');
                  // submitOrder(
                  //     context: context,
                  //     route: '/home',
                  //   );
                },
                content: 'Comprar',
              ),
            )
          ],
        ),
      ],
    );
  }

  Container buildDeliveryData() {
    return Container(
      width:  MediaQuery.of(context).size.width,
      //width: 200,
      height: 144,
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
      child:CustomFutureBuilder(
        future: ()=>DeliveryInfoController().getDeliveryInfoByUserId(userId: appData.currentUserId!), 
        builder: (context, deliveryInfo){
          final onlyInfo=deliveryInfo![0];
          return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
        child: Column(
                children: [
                  SizedBox(
                    height: 28,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomComponents.makeText(
                            headingType: 'H5',
                            data: 'Datos de envío',
                            color: customPrimary),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomComponents.makeText(
                          headingType: 'H6',
                          data: 'Nombres:',
                          color: customDarkGray),
                      CustomComponents.makeText(
                          headingType: 'PR2',
                          data: onlyInfo.delivnames,
                          color: customDarkGray),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomComponents.makeText(
                          headingType: 'H6',
                          data: 'Dirección:',
                          color: customDarkGray),
                      SizedBox(
                        width: 180,
                        child: CustomComponents.makeText(
                            headingType: 'PR2',
                            data: '${onlyInfo.delivaddress}, ${onlyInfo.district}, ${onlyInfo.province}',
                            color: customDarkGray,
                            textAlign: TextAlign.end),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomComponents.makeText(
                          headingType: 'H6',
                          data: 'Código postal',
                          color: customDarkGray),
                      CustomComponents.makeText(
                          headingType: 'PR2', data: onlyInfo.postalcode, color: customDarkGray),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomComponents.makeText(
                          headingType: 'H6',
                          data: 'Número de teléfono:',
                          color: customDarkGray),
                      CustomComponents.makeText(
                          headingType: 'PR2', data: onlyInfo.telephone, color: customDarkGray),
                    ],
                  ),
                ],
              ),
            );
        }
        ), 
    );
  }

  Container buildTypeDelivery() {
    return Container(
      width:  MediaQuery.of(context).size.width,
      //width: 200,
      height: 70,
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
      child:CustomFutureBuilder(
        future: ()=>DeliveryInfoController().getDeliveryInfoByUserId(userId: appData.currentUserId!), 
        builder: (context, delivInfo){
          final onlyInfo=delivInfo![0];
          return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Column(
                  children: [
                    SizedBox(
                      height: 28,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomComponents.makeText(
                              headingType: 'H5',
                              data: 'Envío ${onlyInfo.deliverytype}',
                              color: customPrimary),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomComponents.makeText(
                            headingType: 'H6',
                            data: 'Llega en:',
                            color: customDarkGray),
                        CustomComponents.makeText(
                            headingType: 'PR2',
                            data: onlyInfo.deliverytype=='Estándar'?'1-2 días':'8-12 horas',
                            color: customDarkGray),
                      ],
                    ),
                  ],
                ),
              );
        }
        ) 
    );
  }

  Container buildPaymentData() {
    return Container(
      width:  MediaQuery.of(context).size.width,
      //width: 200,
      height: 86,
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
      child: CustomFutureBuilder(
        future: ()=>PaymentInfoController().getPaymentInfoByUserId(userId: appData.currentUserId!), 
        builder: (context,payInfo){
          final onlyInfo = payInfo![0];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
            child: Column(
              children: [
                SizedBox(
                  height: 28,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomComponents.makeText(headingType: 'H5', data: 'Tarjeta Débito', color: customPrimary),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomComponents.makeText(headingType: 'H6', data: 'Nro. de tarjeta:', color: customDarkGray),
                    CustomComponents.makeText(headingType: 'PR2', 
                    data: 'XXXX-XXXX-XXXX-${onlyInfo.cardnumber.split('-').last}', 
                    color: customDarkGray),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomComponents.makeText(headingType: 'H6', data: 'Fecha de expiración:', color: customDarkGray),
                    CustomComponents.makeText(headingType: 'PR2', data: onlyInfo.expdate, color: customDarkGray),
                  ],
                ),
              ],
            ),
          );
        }) 
    );
  }

  Container makeTotalReviewChart() {
    final quantity = appData.totals['quantity'];
    final subtotal = appData.totals['subtotal'];
    final discounts = appData.totals['discounts'];
    final delivery = appData.totals['delivery'];
    final totalGeneral = appData.totals['total'];

    return Container(
      width:  MediaQuery.of(context).size.width,
      //width: 200,
      height: 160,
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
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomComponents.makeText(headingType: 'H6', data: 'Productos:', color: customDarkGray),
                CustomComponents.makeText(headingType: 'PR2', data: quantity.toString(), color: customDarkGray),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomComponents.makeText(headingType: 'H6', data: 'Envío:', color: customDarkGray),
                CustomComponents.makeText(headingType: 'PR2', data: '+S/. $delivery${MathCalculations().roundedValueTwoDecimalsFormatting(delivery)}', color: customDarkGray),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomComponents.makeText(headingType: 'H5', data: 'Total:', color: customBlack),
                CustomComponents.makeText(headingType: 'H5', data: 'S/. $totalGeneral${MathCalculations().roundedValueTwoDecimalsFormatting(totalGeneral)}', color: customBlack),
              ],
            ),
            

          ],
        ),
      ),
    );
  }
}