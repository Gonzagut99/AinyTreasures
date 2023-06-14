import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'styles.dart';
import './assets.dart';
import 'components/custom_components.dart';
import '../Controller/user_controller.dart';
import '../Entity/user_entity.dart';
import '../Model/user_model.dart';
import 'components/custom_futurebuilder.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  //Variables informacion del backend
  late Future<User> futureUser;
  @override
  void initState() {
    super.initState();
    UserModel.makeDbSqlLite();
    //futureUser = UserController().login();
  }

  @override
  Widget build(BuildContext context) {
    //function navigator
    void callbackNav ({required BuildContext context,required String route}){
      Navigator.pop(context); 
      Navigator.of(context).pushNamed(route);
    }
    return Scaffold(
      body:  Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://storage.googleapis.com/imagenes-appcertus/pantallas/imagen_bienvenida.jpg"),
            fit: BoxFit.cover
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
           child: Padding(
             padding: const EdgeInsets.all(24.0),
               child: Card(
                elevation: 24,
                color: customWhite.withOpacity(0.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0,20,0,20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [CustomComponents.makeText(headingType: 'H3', data: 'Jabbi', color: customSecondary)],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                         Column(
                           children: [
                             SvgPicture.asset('assets/images/exploringCountry.svg'),
                             const SizedBox(height: 20),
                             SizedBox(
                               width: 200,
                               child: CustomComponents.makeText(headingType: 'P2', data: '"Un viaje por los sabores y colores del Perú"', color: customPrimary,textAlign: TextAlign.center),
                             ),
                             const SizedBox(height: 20),
                             SizedBox(
                               width: 200,
                               child: CustomComponents.makeText(headingType: 'P3', data: 'Ofrecemos una experiencia intuitiva, informativa y personalizada para poder vivir de la manera más saludable.', color: customBlack, textAlign: TextAlign.center),
                             ),
                            const SizedBox(height: 20),
                             SizedBox(
                               width: 80,
                               child: CustomFutureBuilder<User>(
                                  future: ()=>UserController().login(email: 'gonzaloa_treasures@gmail.com', password: '1234567'),
                                  builder: (context, user) {
                                    return CustomComponents.makeText(headingType: 'P3', data: 'Usuario: ${user?.username}', color: customBlack, textAlign: TextAlign.center);
                                  },
                                  loadingWidget: const CircularProgressIndicator(),
                                ),
                             ) 
                           ],
                         )
                         
                        ],
                      ),
                      SizedBox(
                        width: 200,
                        child: CustomComponents.makeButton(btnColor: customSecondary, callback: ()=>{callbackNav(context: context,route: '/login')}, content: 'Iniciar Sesión')
                      )
                     
                    ],
                  ),
                ),
             ),
           ),
         )
      )
    );
     
  }
}