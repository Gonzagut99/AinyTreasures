import 'package:flutter/foundation.dart';
// Importamos la clase User
import '../Entity/user_entity.dart';
import '../Entity/response_entity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserModel {
  static late dynamic database;
  //late ResponseEntity responseEntity;
  final String _baseURI = 'certus-proyecto-dot-steady-syntax-385612.de.r.appspot.com';
  //List<User>? users;

  // Future<List<User>?> getUsers() async {
  //   List<User>? users;
  //   //final client = http.Client();
  //   var url = Uri.http(_baseURI,'/users');
  //   try {
  //     //final response = await client.get(Uri.parse('$_baseURI/users'));
  //     final response = await http.get(url);
  //     final responseEntity = responseEntityFromJson(response.body);
  //     users = responseEntity.entity;
  //     return users;
  //   } catch (e) {
  //     return null;
  //   } finally{
  //     //client.close();
  //   }
  // }

  Future<dynamic> getUserByEmail(String email, String password) async {
    //User? user;
    //final client = http.Client();
    var url = Uri.https(_baseURI,'login/$email',{'password':password});
    final response = await http.get(url);
    if (response.statusCode == 200) {
      
      final responseEntity = responseEntityFromJson(response.body);
      if (responseEntity.status==1) {
        final responseUser = userFromJson(jsonEncode(responseEntity.entity)) ;
        return responseUser;
      } else {
        return responseEntity.message;
      }
      
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      final responseEntity = responseEntityFromJson(response.body);
      return responseEntity;
      //throw Exception('Fallo en la carga de información');
    }
  }
  Future<User> getUserById(String id) async {
    //User? user;
    //final client = http.Client();
    var url = Uri.https(_baseURI,'user/$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseEntity = responseEntityFromJson(response.body);
      final responseUser = userFromJson(jsonEncode(responseEntity.entity)) ;
      return responseUser;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Fallo en la carga de información');
    }
  }

  Future<Map<String,dynamic>> postNewUser({required String userid,required String username,required String lastname, required String password, required String email, required int age, required String region, required String province, required String district, required String profileimage}) async {
    //User? user;
    //final client = http.Client();
    var url = Uri.https(_baseURI,'/newuser');
    Map<String, dynamic> requestBody = {
      'userid':userid,
      'username': username,
      'lastname':lastname,
      'password':password,
      'email':email,
      'age':age,
      'region':region,
      'province':province,
      'district':district,
      'profileimage': profileimage
    };
    final response = await http.post(url,
      body: jsonEncode(requestBody),
      headers:  {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      final responseBody = responseEntityFromJson(response.body);
      if (responseBody.status==1) {
        return {
          'status':response.statusCode,
          'message':'Registro Exitoso'
        };
      } else {
        return {
          'status':response.statusCode,
          'message':'Registro Fallido: ${responseBody.message}. Intentelo nuevamente.'
        };
      }
    } else {
      return {
        'status':response.statusCode,
        'message':'Registro Fallido'
      };
    }
  }

  static Future<void> makeDbSqlLite() async {
    //final dbPath = join(await getDatabasesPath(), 'user.db');
    //await deleteDatabase(dbPath);
    database = openDatabase(
      join(await getDatabasesPath(), 'user.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE user(userid TEXT PRIMARY KEY, username TEXT, lastname TEXT, email TEXT, age INTEGER, region TEXT, province TEXT, district TEXT, profileimage TEXT)",
        );
      },
      version: 1,
    );
  }

  //Metodos sqllite
  Future<void> insertUser(User user) async {
    // Obtiene una referencia de la base de datos
    final Database db = await database;

    // `conflictAlgorithm` reemplaza cualquier dato anterior.
    await db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

  }

  // Future<List<Dog>> dogs() async {
  //   // Obtiene una referencia de la base de datos
  //   final Database db = await database;

  //   // Consulta la tabla por todos los Dogs.
  //   final List<Map<String, dynamic>> maps = await db.query('dogs');

  //   // Convierte List<Map<String, dynamic> en List<Dog>.
  //   return List.generate(maps.length, (i) {
  //     return Dog(
  //       id: maps[i]['id'],
  //       name: maps[i]['name'],
  //       age: maps[i]['age'],
  //     );
  //   });
  // }

  Future<User> getUserByIdSqlLite({required String? userid}) async {
    // Obtiene una referencia de la base de datos
    final Database db = await database;

    // Busca el usuario de la base de datos
    final List<Map<String, dynamic>> user = await db.query(
      'user',
      // Utiliza la cláusula `where` para encontrar al usuario
      where: "userid = ?",
      // Pasa el id Dog a través de whereArg para prevenir SQL injection
      whereArgs: [userid],
    );
    //Comprueba si existe o no el elemento
    if (user.isNotEmpty) {
      final Map<String, dynamic> oneUser = user[0];
      return User(
          userid: oneUser['userid'],
          username: oneUser['username'],
          lastname: oneUser['lastname'],
          password: 'No guardamos contraseñas',
          email: oneUser['email'],
          age: oneUser['age'],
          region: oneUser['region'],
          province: oneUser['province'],
          district: oneUser['district'],
          profileimage: oneUser['profileimage']
      );
    } else {
      final newUser = await getUserById(userid!);
      insertUser(newUser);
      return getUserByIdSqlLite(userid: newUser.userid);
    }
  }

  // Future<void> deleteDog(int id) async {
  //   // Obtiene una referencia de la base de datos
  //   final db = await database;

  //   // Elimina el Dog de la base de datos
  //   await db.delete(
  //     'dogs',
  //     // Utiliza la cláusula `where` para eliminar un dog específico
  //      where: "id = ?",
  //     // Pasa el id Dog a través de whereArg para prevenir SQL injection
  //     whereArgs: [dog.id],
  //   );
  // }
}



