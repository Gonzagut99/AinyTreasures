import 'dart:async';

import 'package:ayni_treasures/Model/user_model.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'styles.dart';
import './assets.dart';
import 'components/custom_components.dart';
import 'components/form_items.dart';
import '../Entity/user_entity.dart';
import '../Controller/user_controller.dart';
import 'components/custom_futurebuilder.dart';
import 'components/singleton_envVar.dart';

class LoginPage extends StatefulWidget {
  
  const LoginPage({super.key});
  
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Variable formulario
  late String emailValue;
  late String passwordValue;
  final formKey = GlobalKey<FormState>();

  //Variables informacion del backend
  late Future<User> futureUser;
  @override
  void initState() {
    super.initState();
    //futureUser = UserController().login();
  }

  @override
  Widget build(BuildContext context) {
    //function navigator
    void callbackNav ({required BuildContext context,required String route}){
      Navigator.pop(context); 
      Navigator.of(context).pushNamed(route);
    }
    //Establecer usuario actual
    Future<void> setCurrentUser() async {
      final Future<dynamic> userFound = UserController().login(email: emailValue, password: passwordValue);
      User user = await userFound;
      setState(() {
        appData.currentUserId = user.userid;
      });
    }
    //ENVIAR SOLICITUD DE ACCESO A LA CUENTA
    void submitForm({required BuildContext context,required String route}){
      if(formKey.currentState!.validate()){
        //Valores del login son guardados en sus variables vinculadas
        formKey.currentState!.save();
        UserController().login(email: emailValue, password: passwordValue).then((dynamic user){
          if (user is User) {
            setCurrentUser();
            //Se accede a las variables para llamar a la base de datos
            showDialog(context: context, builder: (BuildContext context){
              return CustomFutureBuilder<dynamic>(
                future: ()=>UserController().login(email: emailValue, password: passwordValue),
                builder: (context, user) {
                  //Se guarda la id del usuario de manera              
                  return CustomComponents.makeSimpleDialog(context: context, title: 'Bienvenido ${user?.username} ${user?.lastname}!',content: 'Has iniciado sesión exitosamente. Espere un momento.');
                },
                loadingWidget: const CircularProgressIndicator(),
              ); 
            }, barrierDismissible: false);
            //Se envia a la pagina de inicio despues de 3 segundos
            Timer(const Duration(seconds: 5),()=>{
              Navigator.of(context).pushNamed(route)
            });
            // Timer(const Duration(seconds: 5),()=>{
            //   userFound.then((value) => Navigator.of(context).pushNamed(route,arguments:value) )
            // });
          } else {
            showDialog(context: context, builder: (BuildContext context){
              return CustomFutureBuilder<dynamic>(
                future: ()=>UserController().login(email: emailValue, password: passwordValue),
                builder: (context, message) {
                  //Se guarda la id del usuario de manera              
                  return CustomComponents.makeSimpleDialog(context: context, title: '¡Lo sentimos!',content: 'Mensaje: $message. Vuelva a intentar llenar el formulario.');
                },
                loadingWidget: const CircularProgressIndicator(),
              ); 
            });
          }

        });

        
        
      }
    }
    return Scaffold(
      body:  Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://viajes.nationalgeographic.com.es/medio/2018/02/27/ibr-2218482__550x807.jpg"),
            fit: BoxFit.cover
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
           child: Padding(
             padding: const EdgeInsets.all(24.0),
               child: Card(
                elevation: 24,
                color: customWhite.withOpacity(1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListView(
                  children: [
                    Padding(
                    padding: const EdgeInsets.fromLTRB(0,20,0,20),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [CustomComponents.makeText(headingType: 'H3', data: 'Jabbi', color: customSecondary)],
                        ),
                        const SizedBox(height: 24,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 300,
                              child: Form(
                                key: formKey,
                                child: Column(                              
                                  children: <Widget> [
                                    FormItems.makeInputItem(
                                      label: 'Correo Electrónico',
                                      inputType: TextInputType.emailAddress,
                                      cbOnSaved:(String value){emailValue=value;}, 
                                      cbValidator: (String value){
                                        if (!value.contains('@')||value.isEmpty){
                                          return 'No ha ingresado ningun valor o el correo es invalido';
                                        }
                                      } 
                                    ),
                                    FormItems.makeInputItem(
                                      label: 'Contraseña',
                                      inputType: TextInputType.visiblePassword,
                                      cbOnSaved:(String value){passwordValue=value;}, 
                                      cbValidator: (String value){
                                        if (value.length<6||value.length>10||value.isEmpty){
                                          return 'No ha ingresado ningun valor o la contraseña no puede exceder 6 digitos';
                                        }
                                      } 
                                    ),

                                    SizedBox(
                                      width: 200,
                                      child: CustomComponents.makeButton(btnColor: customSecondary, callback: ()=>{submitForm(context: context,route: '/home',)}, content: 'Iniciar Sesión'),
                                    )
                                  ],
                                )
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
                                CustomComponents.makeButton(btnColor: customWhite, callback: ()=>{callbackNav(context: context,route: '/signin',)}, content: 'Registrate Aquí')
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
         )
      )
    ); 
  }
}

class FormArguments {
  String email;
  String password;
  FormArguments({required this.email,required this.password});
}