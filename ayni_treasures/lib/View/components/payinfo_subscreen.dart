import 'package:ayni_treasures/View/components/singleton_envVar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../Controller/paymentinfo_controller.dart';
import '../assets.dart';
import '../styles.dart';
import 'custom_components.dart';
import 'custom_futurebuilder.dart';
import 'form_items.dart';

class PayInfoSubscreen extends StatefulWidget {
  final Function(int) changeScreen;
  const PayInfoSubscreen({super.key, required this.changeScreen});

  @override
  State<PayInfoSubscreen> createState() => _PayInfoSubscreenState();
}

class _PayInfoSubscreenState extends State<PayInfoSubscreen> {
  //Alinear los labels de los inputs
  final TextAlign alignLabel = TextAlign.start;
//Valores por default
  final payMethodValues = ['credito','debito'];

  //valores de los inputs
  late String paymethodValue;
  late String cardnumberValue;
  late String expdateValue;
  late String securitycodeValue;

  //cardtile redio de metodo de pago
  int selectedPayMethodRadioTile = 1;

  //Mascaras de formateo de inputs
  MaskTextInputFormatter maskFormatterCardNumber = MaskTextInputFormatter(
    mask: '####-####-####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );
  MaskTextInputFormatter maskFormatterExpDate = MaskTextInputFormatter(
    mask: '##/##',
    filter: {"#": RegExp(r'[0-9]')},
  );
  MaskTextInputFormatter maskFormatterSecCode = MaskTextInputFormatter(
    mask: '###',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final formKey = GlobalKey<FormState>();

  //Registra y Construye el dialogo de carga de informacion de envio exitoso
  void submitDelivInfoForm({required BuildContext context, required String route}) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      //Mostrar cuadro de dialogo
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomFutureBuilder<Map<String, dynamic>>(
              future: () => PaymentInfoController().postPaymentInfo(
                  iduser: appData.currentUserId!,
                  paymethod: paymethodValue,
                  cardnumber: cardnumberValue,
                  expdate: expdateValue,
                  securitycode: securitycodeValue),
              builder: (context, newPayInfo) {
                final simpleDialog =
                    CustomComponents.makeSimpleDialogWithButtons(
                        context: context,
                        title: '${newPayInfo?['message']}!',
                        content: 'Gracias por confiar en nosotros',
                        callbackFn: () {
                          setState(() {
                            Navigator.of(context).pop();
                            widget.changeScreen(2);
                          });
                        },
                        mainBtnContent: 'Continuar');
                  final simpleDialogExeptions =
                    CustomComponents.makeSimpleDialogWithCloseButton(
                        context: context,
                        title: '${newPayInfo?['message']}!',
                        content: 'Intente nuevamente',

                    );
                if (newPayInfo?['message'] == 'Posteo Exitoso') {
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
    //Inicializamos el valor del valor de metodo de pago
    paymethodValue=payMethodValues[selectedPayMethodRadioTile-1];
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
        //Paymethod buttons        
        CustomComponents.makeText(headingType: 'H6', data: 'Método de pago', color: customPrimary),
        const SizedBox(height: 8,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildPayMethodRadio(payMethod: 'Tarjeta de crédito',indexCardTile: 1),
            buildPayMethodRadio(payMethod: 'Tarjeta de débito', indexCardTile: 2),
          ],
        ),
        const SizedBox(height: 12),
        FormItems.makeInputItem(
            inputFormatters: [maskFormatterCardNumber],
            label: 'Número de tarjeta',
            inputType: TextInputType.number,
            cbOnSaved: (String value) {
              cardnumberValue = value;
            },
            cbValidator: (String value) {
              if (value.length > 19 || value.isEmpty) {
                return 'Debe contener 16 digitos';
              }
            },
            labelAlign: alignLabel,
            hintText: "0000-0000-0000-0000"
            ),
        Row(
          children: [
            FormItems.makeInputItem(
              inputFormatters: [maskFormatterExpDate],
                width: 166,
                label: 'Expiración',
                inputType: TextInputType.number,
                cbOnSaved: (String value) {
                  expdateValue = value;
                },
                cbValidator: (String value) {
                  if (value.length > 5 || value.isEmpty) {
                    return 'No ha ingresado ningun valor o la provincia es invalido';
                  }
                },
                labelAlign: alignLabel,
                hintText: '00/00'
                ),
            const SizedBox(width: 16),
            FormItems.makeInputItem(
              inputFormatters: [maskFormatterSecCode],
                width: 166,
                label: 'Codigo de seguridad',
                inputType: TextInputType.number,
                cbOnSaved: (String value) {
                  securitycodeValue = value;
                },
                cbValidator: (String value) {
                  if (value.length > 3 || value.isEmpty) {
                    return 'No ha ingresado ningun valor o el distrito es invalido';
                  }
                },
                labelAlign: alignLabel,
                hintText: '000'),
          ],
        ),
        
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

   Opacity buildPayMethodRadio({required String payMethod, required int indexCardTile}) {
    int indexCT = indexCardTile;
     return Opacity(
      opacity: selectedPayMethodRadioTile==indexCT?1.0:0.4,
       child: GestureDetector(
        onTap: (){
          setState(() {
            selectedPayMethodRadioTile=indexCT;
            paymethodValue=payMethodValues[selectedPayMethodRadioTile-1];
          });
        },
         child: SizedBox(
          width: MediaQuery.of(context).size.height*0.2,
          //width: 150,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(simpleCardIcon),
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: 70,
                    child: CustomComponents.makeText(
                      headingType: 'H6', data: payMethod, color: customPrimary),
                  ),
                ],
              ),
            ),
          ),
           ),
       ),
     );
   }

}