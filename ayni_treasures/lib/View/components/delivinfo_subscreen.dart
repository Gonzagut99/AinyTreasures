import 'dart:async';

import 'package:ayni_treasures/View/components/singleton_envVar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../Controller/deliveryinfo_controller.dart';
import '../assets.dart';
import '../styles.dart';
import 'custom_components.dart';
import 'custom_futurebuilder.dart';
import 'form_items.dart';
import '../checkout_page.dart';
import 'math_calculations.dart';

class DelivInfoSubscreen extends StatefulWidget {
  //Proceso de checkout estados
  final Function(int) changeScreen;

  const DelivInfoSubscreen({super.key, required this.changeScreen});

  @override
  State<DelivInfoSubscreen> createState() => _DelivInfoSubscreenState();
}

class _DelivInfoSubscreenState extends State<DelivInfoSubscreen> {
  final TextAlign alignLabel = TextAlign.start;
  //Valores por default
  final delivTypeValues = ['Estándar','Rápido'];
  final delivPriceValues = ['5.0','8.0'];
  //valores de los inputs
  late String delivnamesValue;
  late String provinceValue;
  late String districtValue;
  late String delivaddressValue;
  late String postalcodeValue;
  late String telephoneValue;
  late String deliverytypeValue;
  String deliverypriceValue = appData.totals['delivery'];
  String generalTotal= appData.totals['total'];



  //Mascaras de formateo de inputs
  MaskTextInputFormatter maskFormatterPostalCode = MaskTextInputFormatter(
    mask: '#####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  //Mascaras de formateo de inputs
  MaskTextInputFormatter maskFormatterTelNumber = MaskTextInputFormatter(
    mask: '### ### ###',
    filter: {"#": RegExp(r'[0-9]')},
  );

  //cardtile radiotiles tipo de envio
  int selectedDeliveryRadioTile = 1;

  final formKey = GlobalKey<FormState>();

  //Registra y Construye el dialogo de carga de informacion de envio exitoso
  void submitDelivInfoForm({required BuildContext context, required String route}) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      //se envia el dato final del total
      appData.totals['total']=generalTotal;
      //Mostrar cuadro de dialogo
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomFutureBuilder<Map<String, dynamic>>(
              future: () => DeliveryInfoController().postNewDeliveryInfoEntity(
                  delivnames: delivnamesValue,
                  province: provinceValue,
                  district: districtValue,
                  delivaddress: delivaddressValue,
                  postalcode: postalcodeValue,
                  telephone: telephoneValue,
                  deliverytype: deliverytypeValue,
                  deliveryprice: deliverypriceValue,
                  iduser: appData.currentUserId!),
              builder: (context, newDelivInfo) {
                final simpleDialog =
                    CustomComponents.makeSimpleDialogWithButtons(
                        context: context,
                        title: '${newDelivInfo?['message']}!',
                        content: 'Gracias por confiar en nosotros',
                        callbackFn: () {
                          setState(() {
                            Navigator.of(context).pop();
                            widget.changeScreen(1);
                          });
                        },
                        mainBtnContent: 'Continuar');
                  final simpleDialogExeptions =
                    CustomComponents.makeSimpleDialogWithCloseButton(
                        context: context,
                        title: '${newDelivInfo?['message']}!',
                        content: 'Intente nuevamente',

                    );
                if (newDelivInfo?['message'] == 'Posteo Exitoso') {
                    return simpleDialog;
                } else {
                  return simpleDialogExeptions;
                }                
              },
              loadingWidget: const CircularProgressIndicator(),
            );
          },
          barrierDismissible: false);
    } else {
      AlertDialog(
        title: CustomComponents.makeText(
            headingType: 'H4',
            data: 'Aviso',
            color: customPrimary,
            textAlign: TextAlign.center),
        content: CustomComponents.makeText(
            headingType: 'P2',
            data: 'Tus datos deben ser correctos',
            color: customBlack),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Ok'),
            child: CustomComponents.makeText(
                headingType: 'H5', data: 'Ok', color: customSecondary),
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //Determinamos el precio del delivery por default
    appData.totals['delivery']=delivPriceValues[selectedDeliveryRadioTile-1];
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
              child: buildForm(context)),
            const SizedBox(
              height: 12,
            ),
          ]),
        ),
      ),
    );
  }

  Row buildForm(BuildContext context) {
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
                  Form(key: formKey, child: buildInputs(context)),
            ),
          ),
        ),
      ],
    );
  }

  Column buildInputs(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:CrossAxisAlignment.start,
      children: <Widget>[
        FormItems.makeInputItem(
            label: 'Nombres y apellidos',
            inputType: TextInputType.name,
            cbOnSaved: (String value) {
              delivnamesValue = value;
            },
            cbValidator: (String value) {
              if (value.length > 60 || value.isEmpty) {
                return 'No se puede escribir más';
              }
            },
            labelAlign: alignLabel),
        Row(
          children: [
            FormItems.makeInputItem(
                width: 166,
                label: 'Provincia',
                inputType: TextInputType.text,
                cbOnSaved: (String value) {
                  provinceValue = value;
                },
                cbValidator: (String value) {
                  if (value.length > 30 || value.isEmpty) {
                    return 'No ha ingresado ningun valor o la provincia es invalido';
                  }
                },
                labelAlign: alignLabel),
            const SizedBox(width: 16),
            FormItems.makeInputItem(
                width: 166,
                label: 'Distrito',
                inputType: TextInputType.text,
                cbOnSaved: (String value) {
                  districtValue = value;
                },
                cbValidator: (String value) {
                  if (value.length > 30 || value.isEmpty) {
                    return 'No ha ingresado ningun valor o el distrito es invalido';
                  }
                },
                labelAlign: alignLabel),
          ],
        ),
        FormItems.makeInputItem(
            label: 'Dirección de envío',
            inputType: TextInputType.name,
            cbOnSaved: (String value) {
              delivaddressValue = value;
            },
            cbValidator: (String value) {
              if (value.length > 80 || value.isEmpty) {
                return 'Dirección muy larga';
              }
            },
            labelAlign: alignLabel),
        Row(
          children: [
            FormItems.makeInputItem(
                width: 150,
                label: 'Codigo postal',
                inputType: TextInputType.number,
                cbOnSaved: (String value) {
                  postalcodeValue = value;
                },
                cbValidator: (String value) {
                  if (value.length > 5 || value.isEmpty) {
                    return 'Cinco numeros minimo';
                  }
                },
                labelAlign: alignLabel,
                inputFormatters: [maskFormatterPostalCode],
                hintText: '00000',               
                ),
            const SizedBox(width: 16),
            FormItems.makeInputItem(
              inputFormatters: [maskFormatterTelNumber],
                width: 182,
                label: 'Número telefónico',
                inputType: TextInputType.phone,
                cbOnSaved: (String value) {
                  telephoneValue = value;
                },
                cbValidator: (String value) {
                  if (value.length > 11 || value.isEmpty) {
                    return 'Máximo 9 números';
                  }
                },
                labelAlign: alignLabel,
                hintText: '000-000-000'
                ),
          ],
        ),
        CustomComponents.makeText(headingType: 'H6', data: 'Tipo de envío', color: customPrimary),
        const SizedBox(height: 8,),
        buildDeliveryCardTile(indexCardTile: 1, delivType: 'Envío Estándar', delivTime: '1-2 días', delivPrice: 'S/. 5.00'),
        const SizedBox(height: 4,),
        buildDeliveryCardTile(indexCardTile: 2, delivType: 'Envío Rápido', delivTime: '8-12 horas', delivPrice: 'S/. 8.00'),
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
                  submitDelivInfoForm(
                      context: context,
                      route: '/home',
                    );
                },
                content: 'Guardar y Continuar',
              ),
            )
          ],
        ),
      ],
    );
  }

  Opacity buildDeliveryCardTile({required int indexCardTile, required String delivType, required String delivTime, required String delivPrice}) {
    int indexCT = indexCardTile;
    return Opacity(
      opacity: selectedDeliveryRadioTile==indexCT?1.0:0.4,
      child: GestureDetector(
          onTap: (){
            setState(() {
              //Actualiza el valor de deliveryType y los totales
              selectedDeliveryRadioTile=indexCT;
              deliverytypeValue=delivTypeValues[selectedDeliveryRadioTile-1];
              deliverypriceValue=delivPriceValues[selectedDeliveryRadioTile-1];
              appData.totals['delivery']=deliverypriceValue;
              generalTotal=appData.totals['total'];
              generalTotal=MathCalculations().roundedValueTwoDecimals(double.parse(generalTotal)+ double.parse(deliverypriceValue));
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: customPrimary, width: 1.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(standardDeliveryIcon),
                            const SizedBox(width: 8,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 CustomComponents.makeText(headingType: 'H5', data: delivType, color: customPrimary),                               
                                 CustomComponents.makeText(headingType: 'PR2', data: delivTime, color: customBlack)
                              ],                           
                            )
                          ],
                        ),                      
                        Align(
                          alignment: Alignment.bottomRight,
                          child: CustomComponents.makeText(headingType: 'H4', data: delivPrice, color: customBlack),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
    );
  }
  Container makeTotalReviewChart() {
    final quantity = appData.totals['quantity'];
    final subtotal = appData.totals['subtotal'];
    final discounts = appData.totals['discounts'];

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
                CustomComponents.makeText(headingType: 'PR2', data: '+S/. $deliverypriceValue${MathCalculations().roundedValueTwoDecimalsFormatting(deliverypriceValue)}', color: customDarkGray),
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
            

          ],
        ),
      ),
    );
  }
}