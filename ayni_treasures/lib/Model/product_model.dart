import 'package:flutter/foundation.dart';
// Importamos la clase User
//import '../Entity/user_entity.dart';
import '../Entity/product_entity.dart';
import '../Entity/response_entity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ProductModel {
  static late dynamic database;
  //late ResponseEntity responseEntity;
  final String _baseURI = 'certus-proyecto-dot-steady-syntax-385612.de.r.appspot.com';

  Future<List<Product>> getProductsBySubcategory(String subcategory) async {
    //User? user;
    //final client = http.Client();
    var url = Uri.https(_baseURI,'products/$subcategory');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseEntity = responseEntityFromJson(response.body);
      final responseProducts = listProductFromJson(jsonEncode(responseEntity.entity)) ;
      return responseProducts;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Fallo en la carga de información');
    }
  }
  
  Future<Product> getProductById(String id) async {
    //User? user;
    //final client = http.Client();
    var url = Uri.https(_baseURI,'product/$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseEntity = responseEntityFromJson(response.body);
      final responseProduct = productFromJson(jsonEncode(responseEntity.entity)) ;
      return responseProduct;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Fallo en la carga de información');
    }
  }

  Future<Map<String,dynamic>> postNewProduct({required String idproduct,
    required String fullname,
    required String price,
    required String description,
    required String category,
    required String subcategory,
    required int stock,
    required String mainimage,
    required String addimage1,
    required String addimage2,
    required String origin,
    required String carbs,
    required String proteins,
    required String kcal,
    required String fats,
    required String etimology,
    required String infosource,
    required String linksource,
    required bool onsale,
    required bool newarrival,
    required String descount,}) async {
    //User? user;
    //final client = http.Client();
    var url = Uri.https(_baseURI,'/newuser');
    Map<String, dynamic> requestBody = {
      "idproduct": idproduct,
        "fullname": fullname,
        "price": price,
        "description": description,
        "category": category,
        "subcategory": subcategory,
        "stock": stock,
        "mainimage": mainimage,
        "addimage1": addimage1,
        "addimage2": addimage2,
        "origin": origin,
        "carbs": carbs,
        "proteins": proteins,
        "kcal": kcal,
        "fats": fats,
        "etimology": etimology,
        "infosource": infosource,
        "linksource": linksource,
        "onsale": onsale,
        "newarrival": newarrival,
        "descount": descount,
    };
    final response = await http.post(url,
      body: jsonEncode(requestBody),
      headers:  {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      return {
        'status':response.statusCode,
        'message':'Registro Exitoso'
      };
    } else {
      return {
        'status':response.statusCode,
        'message':'Registro Fallido'
      };
    }
  }

  static Future<void> makeDbSqlLite() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'user.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE cart(idproduct TEXT PRIMARY KEY, fullname TEXT, price TEXT, subcategory TEXT, quantity INTEGER, mainimage TEXT, onsale INTEGER, descount TEXT, measure TEXT)",
        );
      },
      version: 1,
    );
  }

  //Metodos sqllite
  //Ingresa un producto al carrito
  Future<void> insertProduct(ProductCart product) async {
    // Obtiene una referencia de la base de datos
    final Database db = await database;

    // `conflictAlgorithm` reemplaza cualquier dato anterior.
    await db.insert(
      'cart',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

  }

  //Traer los productos del carrito de compras
  Future<List<ProductCart>> getProducts() async {
    // Obtiene una referencia de la base de datos
    final Database db = await database;

    // Consulta la tabla por todos los productos.
    final List<Map<String, dynamic>> maps = await db.query('cart');

    // Convierte List<Map<String, dynamic> en List<Dog>.
    return List.generate(maps.length, (i) {
      return ProductCart(
        idproduct: maps[i]['idproduct'],
        fullname: maps[i]['fullname'],
        price: maps[i]['price'],
        subcategory: maps[i]['subcategory'],
        quantity: maps[i]['fullname'],
        mainimage: maps[i]['mainimage'],
        onsale: maps[i]['onsale'],
        descount: maps[i]['descount'],
        measure:maps[i]['measure']
      );
    });
  }

  // Future<Product> getUserByIdSqlLite({required String? userid}) async {
  //   // Obtiene una referencia de la base de datos
  //   final Database db = await database;

  //   // Busca el usuario de la base de datos
  //   final List<Map<String, dynamic>> user = await db.query(
  //     'cart',
  //     // Utiliza la cláusula `where` para encontrar al usuario
  //     where: "userid = ?",
  //     // Pasa el id Dog a través de whereArg para prevenir SQL injection
  //     whereArgs: [userid],
  //   );
  //   //Comprueba si existe o no el elemento
  //   if (user.isNotEmpty) {
  //     final Map<String, dynamic> oneUser = user[0];
  //     return User(
  //         userid: oneUser['userid'],
  //         username: oneUser['username'],
  //         lastname: oneUser['lastname'],
  //         password: 'No guardamos contraseñas',
  //         email: oneUser['email'],
  //         age: oneUser['age'],
  //         region: oneUser['region'],
  //         province: oneUser['province'],
  //         district: oneUser['district']
  //     );
  //   } else {
  //     final newUser = await getUserById(userid!);
  //     insertUser(newUser);
  //     return getUserByIdSqlLite(userid: newUser.userid);
  //   }
  // }

  Future<void> deleteProduct({required int idproduct}) async {
    // Obtiene una referencia de la base de datos
    final Database db = await database;

    // Elimina el producto de la base de datos
    await db.delete(
      'cart',
      // Utiliza la cláusula `where` para eliminar un producto específico
       where: "idproduct = ?",
      // Pasa el idproduct a través de whereArg para prevenir SQL injection
      whereArgs: [idproduct],
    );
  }
}