import '../Entity/shoppingcartitem_entity.dart';
import '../Entity/response_entity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ShoppingCartModel {
  static late dynamic database;
  //late ResponseEntity responseEntity;
  final String _baseURI = 'certus-proyecto-dot-steady-syntax-385612.de.r.appspot.com';

  Future<List<ShoppingCartItem>> getShoppingCartItemByUserId(String userid) async {
    var url = Uri.https(_baseURI,'cartitems/$userid');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseEntity = responseEntityFromJson(response.body);
      final responseCartItems = listShoppingCartItemFromJson(jsonEncode(responseEntity.entity)) ;
      return responseCartItems;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Fallo en la carga de información');
    }
  }
  
  Future<ShoppingCartItem> getShoppingCartItemById(String idcartitem) async {
    //User? user;
    //final client = http.Client();
    var url = Uri.https(_baseURI,'cartitem/$idcartitem');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseEntity = responseEntityFromJson(response.body);
      final responseCartItem = shoppingCartItemFromJson(jsonEncode(responseEntity.entity)) ;
      return responseCartItem;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Fallo en la carga de información');
    }
  }

  Future<Map<String,dynamic>> postNewShoppingCartItem<T>({required String iduser,
    required String idproduct,
    required String idcartitem,
    required String productname,
    required String productprice,
    required String mainimage,
    required String selectedmeasure,
    required String totalquantity,
    required String discount,
    required String totalprice,
    required String totalwithdiscount,}) async {
    var url = Uri.https(_baseURI,'/newcartitem');
    Map<String, dynamic> requestBody = {
      "iduser": iduser,
      "idproduct": idproduct,
      "idcartitem": idcartitem,
      "productname": productname,
      "productprice": productprice,
      "mainimage": mainimage,
      "selectedmeasure": selectedmeasure,
      "totalquantity": totalquantity,
      "discount": discount,
      "totalprice": totalprice,
      "totalwithdiscount": totalwithdiscount,
    };
    final response = await http.post(url,
      body: jsonEncode(requestBody),
      headers:  {"Content-Type": "application/json"},
    );
    final responseEntity = responseEntityFromJson(response.body);
    if (response.statusCode == 200) {      
      final responseCartItem = shoppingCartItemFromJson(jsonEncode(responseEntity.entity)) ;
      return {
        'status':response.statusCode,
        'message':'Posteo Exitoso',
        'body':responseCartItem
      };
    } else {
      return {
        'status':response.statusCode,
        'message':'Posteo Fallido',
        'body':responseEntity.message,
      };
    }
  }

  Future<Map<String, dynamic>> updateShoppingCartItem({
    required String iduser,
    required String idproduct,
    required String idcartitem,
    required String productname,
    required String productprice,
    required String mainimage,
    required String selectedmeasure,
    required String totalquantity,
    required String discount,
    required String totalprice,
    required String totalwithdiscount,
  }) async {
    var url = Uri.https(_baseURI, '/changedcartitem');
    Map<String, dynamic> requestBody = {
      "iduser": iduser,
      "idproduct": idproduct,
      "idcartitem": idcartitem,
      "productname": productname,
      "productprice": productprice,
      "mainimage": mainimage,
      "selectedmeasure": selectedmeasure,
      "totalquantity": totalquantity,
      "discount": discount,
      "totalprice": totalprice,
      "totalwithdiscount": totalwithdiscount,
    };
    final response = await http.put(
      url,
      body: jsonEncode(requestBody),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      return {
        'status': response.statusCode,
        'message': 'Actualización Exitosa',
      };
    } else {
      return {
        'status': response.statusCode,
        'message': 'Actualización Fallida',
      };
    }
  }

  Future<String> deleteShoppigCartModel(String idcartitem) async {
    var url = Uri.https(_baseURI, '/cartitem/$idcartitem');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      final responseEntity = responseEntityFromJson(response.body);
      //final responseProduct = deliveryInfoEntityFromJson(jsonEncode(responseEntity.entity)) ;
      return responseEntity.message;
    } else {
      throw Exception('Failed to delete delivery info');
    }
  }
}