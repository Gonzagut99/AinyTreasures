// Importamos los paquetes necesarios
import '../Model/paymentinfo_model.dart'; 
// Importamos la clase User
import '../Entity/paymentinfo_entity.dart';
import 'package:nanoid/nanoid.dart';

class PaymentInfoCcontroller {
  Future<List<PaymentInfoEntity>> getPaymentInfoByUserId({required String userId}) async{
    //Variables informacion del backend
    late Future<List<PaymentInfoEntity>> futurePaymentInfo;
    futurePaymentInfo = PaymentInfoModel().getPaymentInfoByUserId(userId);
    //UserModel().insertUser(await futureUser);
    return futurePaymentInfo;
  }

  Future<PaymentInfoEntity> getPaymentInfoById(String id) async{
    return PaymentInfoModel().getPaymentInfoEntityById(id);
  }

  //ingresar un nuevo producto
  Future<Map<String,dynamic>> postPaymentInfo({
    required String iduser,
    required String paymethod,
    required String cardnumber,
    required String expdate,
    required String securitycode,
  }) async{
    var idpaymentinfo = nanoid(8);
    final newPaymentInfo = PaymentInfoModel().postNewPaymentInfoEntity(iduser: iduser, idpaymentinfo: idpaymentinfo, paymethod: paymethod, cardnumber: cardnumber, expdate: expdate, securitycode: securitycode);
    return newPaymentInfo;
  }

  //modificar un nuevo producto
  Future<Map<String,dynamic>> updatePaymentInfo({
    required String iduser,
    required String idpaymentinfo,
    required String paymethod,
    required String cardnumber,
    required String expdate,
    required String securitycode,
  }) async{
    //var idpaymentinfo = nanoid(8);
    final updatedPaymentInfo = PaymentInfoModel().updatePaymentInfoEntity(iduser: iduser, idpaymentinfo: idpaymentinfo, paymethod: paymethod, cardnumber: cardnumber, expdate: expdate, securitycode: securitycode);
    return updatedPaymentInfo;
  }

  Future<String> deletePaymentInfo(String id) async{
    //devuelve solo el mensaje
    return PaymentInfoModel().deletePaymentInfo(id);
  }
}