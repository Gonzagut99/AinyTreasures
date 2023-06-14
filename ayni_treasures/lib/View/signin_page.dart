import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import '../Entity/user_entity.dart';
import 'styles.dart';
import './assets.dart';
import 'components/custom_components.dart';
import 'components/form_items.dart';
import '../Controller/user_controller.dart';
import '../View/components/custom_futurebuilder.dart';
import 'components/singleton_envVar.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextAlign alignLabel = TextAlign.start;
  late String nameValue;
  late String lastNameValue;
  late String passwordValue;
  late String emailValue;
  late int ageValue;
  late String regionValue;
  late String provinceValue;
  late String districtValue;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //function navigator
    void callbackNav ({required BuildContext context,required String route}){
      Navigator.pop(context); 
      Navigator.of(context).pushNamed(route);
    }
    //Establecer usuario actual
    Future<void> setCurrentUser() async {
      final Future<User> userFound = UserController().login(email: emailValue, password: passwordValue);
      User user = await userFound;
      setState(() {
        appData.currentUserId = user.userid;
      });
    }
    //Registra y Construye el dialogo de inicio de sesión exitoso
    void submitForm({required BuildContext context,required String route}){
      if(formKey.currentState!.validate()){
        formKey.currentState!.save();
        //Se establece el usuario actual
        setCurrentUser();

        showDialog(context: context, builder: (BuildContext context){
          return CustomFutureBuilder<Map<String,dynamic>>(
            future: ()=>UserController().register(username: nameValue, lastname: lastNameValue, password: passwordValue, email: emailValue, age: ageValue, region: regionValue, province: provinceValue, district: districtValue),
            builder: (context, newuser) {
              final simpleDialog = CustomComponents.makeSimpleDialog(context: context, title: '${newuser?['message']}!',content: 'Gracias por confiar en nosotros');
              if (newuser?['status']==200) {
                Future<User> userFound = UserController().login(email: emailValue, password: passwordValue);
                userFound.then((value) {
                  Timer(const Duration(seconds: 5),()=>{
                    userFound.then((value) => Navigator.of(context).pushNamed(route))
                  });
                  return simpleDialog;

                });
                
              }             
              return simpleDialog;
            },
            loadingWidget: const CircularProgressIndicator(),
          );
        }); 
      }
    }
    return Scaffold(
      body:  Container(
        constraints: const BoxConstraints.expand(),
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical:2),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,8,0,8),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [CustomComponents.makeText(headingType: 'H3', data: 'Ayni Treasures', color: customSecondary)],
                        ),
                        const SizedBox(height: 24,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:const EdgeInsets.symmetric(horizontal: 16),
                              child: FittedBox(
                                //constraints: const BoxConstraints.expand(),                               
                                child: SizedBox(
                                  width: 350,
                                  child: Form(
                                    key: formKey,
                                    child: Column(                              
                                      children: <Widget> [
                                        FormItems.makeInputItem(
                                          label: 'Nombre',
                                          inputType: TextInputType.name,
                                          cbOnSaved:(String value){nameValue=value;}, 
                                          cbValidator: (String value){
                                            if (value.length>10||value.isEmpty){
                                              return 'No ha ingresado ningun valor o el nombre es invalido';
                                            }
                                          },labelAlign: alignLabel
                                        ),
                                        FormItems.makeInputItem(
                                          label: 'Apellido',
                                          inputType: TextInputType.name,
                                          cbOnSaved:(String value){lastNameValue=value;}, 
                                          cbValidator: (String value){
                                            if (value.length>35||value.isEmpty){
                                              return 'No ha ingresado ningun valor o los apellidos no son válidos.';
                                            }
                                          },labelAlign: alignLabel 
                                        ),
                                        FormItems.makeInputItem(
                                          label: 'Contraseña',
                                          inputType: TextInputType.visiblePassword,
                                          cbOnSaved:(String value){passwordValue=value;}, 
                                          cbValidator: (String value){
                                            if (value.length<6||value.length>10||value.isEmpty){
                                              return 'No ha ingresado ningun valor o la contraseña no puede contener menos 6 digitos, ni exceder 10 dígitos';
                                            }
                                          },labelAlign: alignLabel 
                                        ),
                                        FormItems.makeInputItem(
                                          label: 'Correo Electrónico',
                                          inputType: TextInputType.emailAddress,
                                          cbOnSaved:(String value){emailValue=value;}, 
                                          cbValidator: (String value){
                                            if (!value.contains('@')||value.isEmpty){
                                              return 'No ha ingresado ningun valor o el correo es invalido';
                                            }
                                          },labelAlign: alignLabel
                                        ),
                                        Row(
                                          children: [
                                            FormItems.makeInputItem(
                                              width: 120,
                                              label: 'Edad',
                                              inputType: TextInputType.number,
                                              cbOnSaved:(String value){ageValue=int.parse(value);}, 
                                              cbValidator: (String value){
                                              if (int.parse(value)>100||int.parse(value)==0){
                                                return 'No ha ingresado ningun valor o la edad no es válida.';
                                              }
                                              },labelAlign: alignLabel
                                            ),
                                            const SizedBox(width: 16),
                                            FormItems.makeInputItem(
                                              width: 212,
                                              label: 'Departamento',
                                              inputType: TextInputType.text,
                                              cbOnSaved:(String value){regionValue=value;}, 
                                              cbValidator: (String value){
                                                if (value.length>15||value.isEmpty){
                                                  return 'No ha ingresado ningun valor o el departamento es invalido';
                                                }
                                              },labelAlign: alignLabel
                                            ),
                                          ],
                                          
                                        ),
                                        Row(
                                          children: [
                                            FormItems.makeInputItem(
                                              width: 166,
                                              label: 'Provincia',
                                              inputType: TextInputType.text,
                                              cbOnSaved:(String value){provinceValue=value;}, 
                                              cbValidator: (String value){
                                                if (value.length>15||value.isEmpty){
                                                  return 'No ha ingresado ningun valor o la provincia es invalido';
                                                }
                                              },labelAlign: alignLabel
                                            ),
                                            const SizedBox(width: 16),
                                            FormItems.makeInputItem(
                                              width: 166,
                                              label: 'Distrito',
                                              inputType: TextInputType.text,
                                              cbOnSaved:(String value){districtValue=value;}, 
                                              cbValidator: (String value){
                                                if (value.length>15||value.isEmpty){
                                                  return 'No ha ingresado ningun valor o el distrito es invalido';
                                                }
                                              },labelAlign: alignLabel
                                            ),
                                          ],
                                        ),
                                        // Row(
                                        //   children: [
                                        //     FormItems.makeInputItem(
                                        //       //width: 60,
                                        //       label: 'Edad',
                                        //       inputType: TextInputType.number,
                                        //       cbOnSaved:(String value){ageValue=value;}, 
                                        //       cbValidator: (String value){
                                        //         if (value.length>2||value.isEmpty){
                                        //           return 'No ha ingresado ningun valor o la edad no es válida.';
                                        //         }
                                        //       },labelAlign: alignLabel
                                        //     ),
                                            // const SizedBox(width: 16),
                                            // FormItems.makeInputItem(
                                            //   width: 60,
                                            //   label: 'Departamento',
                                            //   inputType: TextInputType.text,
                                            //   cbOnSaved:(String value){regionValue=value;}, 
                                            //   cbValidator: (String value){
                                            //     if (value.length>15||value.isEmpty){
                                            //       return 'No ha ingresado ningun valor o el departamento es invalido';
                                            //     }
                                            //   },labelAlign: alignLabel
                                            // ),
                                        //   ],
                                        // ),
                                        // Row(
                                        //   children: [
                                        //     FormItems.makeInputItem(
                                        //       label: 'Provincia',
                                        //       inputType: TextInputType.text,
                                        //       cbOnSaved:(String value){provinceValue=value;}, 
                                        //       cbValidator: (String value){
                                        //         if (value.length>15||value.isEmpty){
                                        //           return 'No ha ingresado ningun valor o la provincia es invalido';
                                        //         }
                                        //       },labelAlign: alignLabel
                                        //     ),
                                        //     const SizedBox(width: 16),
                                        //     FormItems.makeInputItem(
                                        //       label: 'Distrito',
                                        //       inputType: TextInputType.text,
                                        //       cbOnSaved:(String value){districtValue=value;}, 
                                        //       cbValidator: (String value){
                                        //         if (value.length>15||value.isEmpty){
                                        //           return 'No ha ingresado ningun valor o el distrito es invalido';
                                        //         }
                                        //       },labelAlign: alignLabel
                                        //     ),
                                        //   ],
                                        // ),
                                        
                                        

                                        SizedBox(
                                          width: 200,
                                          child: CustomComponents.makeButton(btnColor: customSecondary, callback: ()=>{submitForm(context: context,route: '/home',)}, content: 'Registrarse'),
                                        )
                                      ],
                                    )
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                const SizedBox(height: 18),
                                const Divider(),
                                CustomComponents.makeText(headingType: 'P2', data: '¿Eres nuevo?', color: customDarkGray),
                                const SizedBox(height: 20),
                                CustomComponents.makeButton(btnColor: customWhite, callback: ()=>{callbackNav(context: context,route: '/home',)}, content: 'Registrate Aquí')
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  ]
                ),
           ),
      ),
    ); 
  }
}

class FormArgumentsSignIn {
  String email;
  String password;
  FormArgumentsSignIn({required this.email,required this.password});
}