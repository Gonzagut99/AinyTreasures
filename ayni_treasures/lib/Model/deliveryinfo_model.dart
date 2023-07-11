import '../Entity/deliveryinfo_entity.dart';
import '../Entity/response_entity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DeliveryInfoModel {
  static late dynamic database;
  //late ResponseEntity responseEntity;
  final String _baseURI = 'certus-proyecto-dot-steady-syntax-385612.de.r.appspot.com';

  Future<List<DeliveryInfoEntity>> getDeliveryInfoByUserId(String userid) async {
    var url = Uri.https(_baseURI,'delivery/$userid');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseEntity = responseEntityFromJson(response.body);
      final responseDeliveryInfo = listDeliveryInfoEntityFromJson(jsonEncode(responseEntity.entity)) ;
      return responseDeliveryInfo;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Fallo en la carga de información');
    }
  }
  
  // Future<DeliveryInfoEntity> getDeliveryInfoEntityById(String id) async {
  //   //User? user;
  //   //final client = http.Client();
  //   var url = Uri.https(_baseURI,'product/$id');
  //   final response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     final responseEntity = responseEntityFromJson(response.body);
  //     final responseProduct = deliveryInfoEntityFromJson(jsonEncode(responseEntity.entity)) ;
  //     return responseProduct;
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Fallo en la carga de información');
  //   }
  // }

  Future<Map<String,dynamic>> postNewDeliveryInfoEntity({required String delivnames,
        required String province,
        required String district,
        required String delivaddress,
        required String postalcode,
        required String telephone,
        required String deliverytype,
        required String deliveryprice,
        required String iduser,
        required String iddelivery,}) async {
    //User? user;
    //final client = http.Client();
    var url = Uri.https(_baseURI,'/newdelivery');
    Map<String, dynamic> requestBody = {
      "delivnames": delivnames,
        "province": province,
        "district": district,
        "delivaddress": delivaddress,
        "postalcode": postalcode,
        "telephone": telephone,
        "deliverytype": deliverytype,
        "deliveryprice": deliveryprice,
        "iduser": iduser,
        "iddelivery": iddelivery,
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

  Future<Map<String, dynamic>> updateDeliveryInfoEntity({
    required String delivnames,
    required String province,
    required String district,
    required String delivaddress,
    required String postalcode,
    required String telephone,
    required String deliverytype,
    required String deliveryprice,
    required String iduser,
    required String iddelivery,
  }) async {
    var url = Uri.https(_baseURI, '/changedelivery');
    Map<String, dynamic> requestBody = {
      "delivnames": delivnames,
      "province": province,
      "district": district,
      "delivaddress": delivaddress,
      "postalcode": postalcode,
      "telephone": telephone,
      "deliverytype": deliverytype,
      "deliveryprice": deliveryprice,
      "iduser": iduser,
      "iddelivery": iddelivery,
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

  Future<String> deleteDeliveryInfo(
      String idDelivery) async {
    var url = Uri.https(_baseURI, '/delivery/$idDelivery');
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