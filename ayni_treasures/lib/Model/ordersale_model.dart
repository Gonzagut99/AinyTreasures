import '../Entity/ordersale_entity.dart';
import '../Entity/response_entity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class OrderSaleModel {
  static late dynamic database;
  //late ResponseEntity responseEntity;
  final String _baseURI = 'certus-proyecto-dot-steady-syntax-385612.de.r.appspot.com';

  Future<List<OrderSaleEntity>> getOrdersSaleEntity(String userid) async {
    var url = Uri.https(_baseURI,'orders/$userid');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseEntity = responseEntityFromJson(response.body);
      final responseOrderSale = listOrderSaleEntityFromJson(jsonEncode(responseEntity.entity)) ;
      return responseOrderSale;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Fallo en la carga de información');
    }
  }
  
  Future<OrderSaleEntity> getOrderSaleEntityById(String idorder) async {
    //User? user;
    //final client = http.Client();
    var url = Uri.https(_baseURI,'order/$idorder');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseEntity = responseEntityFromJson(response.body);
      final responseOrderSale = orderSaleEntityFromJson(jsonEncode(responseEntity.entity)) ;
      return responseOrderSale;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Fallo en la carga de información');
    }
  }

  Future<Map<String,dynamic>> postOrderSaleEntity({required String idorder,
        required String iduser,
        required String productslist,
        required String discount,
        required String subtotal,
        required String total,
        required DateTime datesale,
        required String iddeliveryinfo,
        required String idpaymentinfo,}) async {
    var url = Uri.https(_baseURI,'/neworder');
    Map<String, dynamic> requestBody = {
      "idorder": idorder,
      "iduser": iduser,
      "productslist": productslist,
      "discount": discount,
      "subtotal": subtotal,
      "total": total,
      "datesale": datesale.toIso8601String(),
      "iddeliveryinfo": iddeliveryinfo,
      "idpaymentinfo": idpaymentinfo,
    };
    final response = await http.post(url,
      body: jsonEncode(requestBody),
      headers:  {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      return {
        'status':response.statusCode,
        'message':'Posteo Exitoso'
      };
    } else {
      return {
        'status':response.statusCode,
        'message':'Posteo Fallido'
      };
    }
  }

  // Future<Map<String, dynamic>> updatePaymentInfoEntity({
  //   required String iduser,
  //   required String idpaymentinfo,
  //   required String paymethod,
  //   required String cardnumber,
  //   required String expdate,
  //   required String securitycode,
  // }) async {
  //   var url = Uri.https(_baseURI, '/changepayment');
  //   Map<String, dynamic> requestBody = {
  //     "iduser": iduser,
  //     "idpaymentinfo": idpaymentinfo,
  //     "paymethod": paymethod,
  //     "cardnumber": cardnumber,
  //     "expdate": expdate,
  //     "securitycode": securitycode,
  //   };
  //   final response = await http.put(
  //     url,
  //     body: jsonEncode(requestBody),
  //     headers: {"Content-Type": "application/json"},
  //   );
  //   if (response.statusCode == 200) {
  //     return {
  //       'status': response.statusCode,
  //       'message': 'Actualización Exitosa',
  //     };
  //   } else {
  //     return {
  //       'status': response.statusCode,
  //       'message': 'Actualización Fallida',
  //     };
  //   }
  // }

  Future<String> deleteOrderSale(String idorder) async {
    var url = Uri.https(_baseURI, '/order/$idorder');
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