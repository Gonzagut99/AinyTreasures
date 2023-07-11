import '../Entity/paymentinfo_entity.dart';
import '../Entity/response_entity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PaymentInfoModel {
  static late dynamic database;
  //late ResponseEntity responseEntity;
  final String _baseURI = 'certus-proyecto-dot-steady-syntax-385612.de.r.appspot.com';

  Future<List<PaymentInfoEntity>> getPaymentInfoByUserId(String userid) async {
    var url = Uri.https(_baseURI,'payment/$userid');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseEntity = responseEntityFromJson(response.body);
      final responsePaymentInfo = listPaymentInfoEntityFromJson(jsonEncode(responseEntity.entity)) ;
      return responsePaymentInfo;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Fallo en la carga de información');
    }
  }
  
  Future<PaymentInfoEntity> getPaymentInfoEntityById(String idpaymentinfo) async {
    //User? user;
    //final client = http.Client();
    var url = Uri.https(_baseURI,'paymentid/$idpaymentinfo');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseEntity = responseEntityFromJson(response.body);
      final responsePaymentInfo = paymentInfoEntityFromJson(jsonEncode(responseEntity.entity)) ;
      return responsePaymentInfo;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Fallo en la carga de información');
    }
  }

  Future<Map<String,dynamic>> postNewPaymentInfoEntity({required String iduser,
        required String idpaymentinfo,
        required String paymethod,
        required String cardnumber,
        required String expdate,
        required String securitycode,}) async {
    var url = Uri.https(_baseURI,'/newpayinfo');
    Map<String, dynamic> requestBody = {
      "iduser": iduser,
      "idpaymentinfo": idpaymentinfo,
      "paymethod": paymethod,
      "cardnumber": cardnumber,
      "expdate": expdate,
      "securitycode": securitycode,
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

  Future<Map<String, dynamic>> updatePaymentInfoEntity({
    required String iduser,
    required String idpaymentinfo,
    required String paymethod,
    required String cardnumber,
    required String expdate,
    required String securitycode,
  }) async {
    var url = Uri.https(_baseURI, '/changepayment');
    Map<String, dynamic> requestBody = {
      "iduser": iduser,
      "idpaymentinfo": idpaymentinfo,
      "paymethod": paymethod,
      "cardnumber": cardnumber,
      "expdate": expdate,
      "securitycode": securitycode,
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

  Future<String> deletePaymentInfo(String idpaymentinfo) async {
    var url = Uri.https(_baseURI, '/payment/$idpaymentinfo');
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