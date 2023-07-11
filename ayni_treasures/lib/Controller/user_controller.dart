// Importamos los paquetes necesarios
import 'package:flutter/material.dart';
import '../View/components/custom_components.dart';
import '../Model/user_model.dart'; 
// Importamos la clase User
import '../Entity/user_entity.dart';
import '../Model/user_model.dart';
import 'package:nanoid/nanoid.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import '../View/components/singleton_envVar.dart';

// Creamos la capa Controlador
class UserController {
  // Método para obtener la lista de libros
  //List<User> get UserList => _UserList;
  Future<dynamic> login({required String email, required String password}) async{
    //Variables informacion del backend
    late Future<dynamic> futureUser;
    futureUser = UserModel().getUserByEmail(email,password);
    //UserModel().insertUser(await futureUser);
    return futureUser;
  }

  Future<Map<String,dynamic>> register({required String username,required String lastname, required String password, required String email, required int age, required String region, required String province, required String district,required String profileimage 
  }) async{
    var userid = nanoid(10);
    final newUser = UserModel().postNewUser(userid: userid, username: username, lastname: lastname, password: password, email: email, age: age, region: region, province: province, district: district, profileimage: profileimage);
    return newUser;
  }

  
  String encryptInfo({required String data}){
    final dataForEncryption = data;
    final key = encrypt.Key.fromUtf8(appData.encryptKkey);
    final iv = encrypt.IV.fromLength(16);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypter.encrypt(dataForEncryption, iv: iv);
    return encrypted.base64;
  }
}