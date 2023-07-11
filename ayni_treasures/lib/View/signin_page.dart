import 'dart:async';
//para File
import 'dart:io';

import 'package:ayni_treasures/View/components/imageprofile_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
//Imagepicker
import 'package:image_picker/image_picker.dart';

//Widgets y MVC
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

  //imagen de perfil
  String profileimageURL = '';
  File? profileImageFile;
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
      final Future<dynamic> userFound = UserController().login(email: emailValue, password: passwordValue);
      User user = await userFound;
      setState(() {
          appData.currentUserId = user.userid;
      });
    }

    //Obtener imagen del telefono
    Future pickImage({required ImageSource imageSourse}) async {
      try {
        //Guardamos la imagen de manera temporal y global
        final XFile? imagefile = await ImagePicker().pickImage(source: imageSourse);
        if (imagefile == null) return;
        
        final imageTemporary = File(imagefile.path);

        //creamos un nombre unico para la foto para la refrencia de firebase
        String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();

        //Consegumos la referencia para guardarlo en un directorio root en firebase storage
        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImages = referenceRoot.child('userprofileimgs');

        //Creamos una referencia para la imagen que va a ser almacenada en el directorio root de firbase storage
        Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

        try {
          late String temporaryUrl;
          //Guardamos la imagen en la referencia creada
          final uploadTask = referenceImageToUpload.putFile(imageTemporary);
          await uploadTask.whenComplete(() async{temporaryUrl= await referenceImageToUpload.getDownloadURL();});
          //print('Subiendo imagen');

          //Si se logra guardar la imagenes, nos descargamos su URL
          //print('Descargando imagen de firebase');

          setState(() {            
            profileImageFile = imageTemporary;            
            profileimageURL = temporaryUrl;      
          });       

        } catch (e) {
          print('Fallo en la descarga de la url de la imagen: $e');
        }
        
      } on PlatformException catch (e) {
        //PlatformException se lanza cuando el usuario ha denegado el acceso a la galeria o a la camara
        print('Fallo en cargar la imagen: $e');
      }
    }
    //Registra y Construye el dialogo de inicio de sesión exitoso
    void submitForm({required BuildContext context,required String route}){
      if(formKey.currentState!.validate() && profileimageURL.startsWith('https://')){
        formKey.currentState!.save();
        //Se establece el usuario actual
        //setCurrentUser();

        showDialog(context: context, builder: (BuildContext context){
          return CustomFutureBuilder<Map<String,dynamic>>(
            future: ()=>UserController().register(username: nameValue, lastname: lastNameValue, password: passwordValue, email: emailValue, age: ageValue, region: regionValue, province: provinceValue, district: districtValue, profileimage: profileimageURL),
            builder: (context, newuser) {
              final simpleDialog = CustomComponents.makeSimpleDialog(context: context, title: '${newuser?['message']}!',content: 'Gracias por confiar en nosotros');
              if (newuser?['message']=='Registro Exitoso') {
                //Future<User> userFound = UserController().login(email: emailValue, password: passwordValue);
                setCurrentUser().then((value) {
                  Timer(const Duration(seconds: 3),()=>{
                    Navigator.of(context).pushNamed(route)
                  });
                  return simpleDialog;

                });
                
              }else{
                Timer(const Duration(seconds: 5),()=>{
                    Navigator.of(context).pushNamed('/signin')
                  });
                return simpleDialog;
              }            
              return simpleDialog;
            },
            loadingWidget: const CircularProgressIndicator(),
          );
        }, barrierDismissible: false); 
      }else{
        AlertDialog(
          title: CustomComponents.makeText(headingType: 'H4', data: 'Aviso', color: customPrimary,textAlign: TextAlign.center),
          content: CustomComponents.makeText(headingType: 'P2', data: 'Debe escoger una imagen para continuar', color: customBlack),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'Ok'),
             child: CustomComponents.makeText(headingType: 'H5', data: 'Ok', color: customSecondary),
            )
          ],
        );
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
                          children: [CustomComponents.makeText(headingType: 'H3', data: 'Jabbi', color: customSecondary)],
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
                                        //Foto de perfil
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 32,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    //width: double.infinity,
                                                    child: CustomComponents.makeText(headingType: 'H6', data: 'Foto de perfil (Cargue una imágen): ', color: customPrimary, textAlign: TextAlign.start )),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 130,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  profileimageURL != ""
                                                    ?ImageProfileWidget(
                                                      imagePath: profileimageURL, 
                                                      //Por detra el widget muestra el menu popup
                                                      onClicked: (source)=>pickImage(imageSourse:source),
                                                    ): ImageProfileWidget(
                                                      imagePath: 'assets/images/genericuser_asset.jpg', 
                                                      //Por detra el widget muestra el menu popup
                                                      onClicked: (source)=>pickImage(imageSourse:source),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
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
                                          //Se guardan los datos encriptados
                                          cbOnSaved:(String value){passwordValue= UserController().encryptInfo(data: value) ;}, 
                                          cbValidator: (String value){
                                            if (value.length<6||value.length>10||value.isEmpty){
                                              return 'Mìnimo 6 digitos';
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