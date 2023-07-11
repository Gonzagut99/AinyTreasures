// To parse this JSON data, do
//
//     final paymentInfoEntity = paymentInfoEntityFromJson(jsonString);

import 'dart:convert';

PaymentInfoEntity paymentInfoEntityFromJson(String str) => PaymentInfoEntity.fromJson(json.decode(str));

String paymentInfoEntityToJson(PaymentInfoEntity data) => json.encode(data.toJson());

//Para listas de payment info: importante
List<PaymentInfoEntity> listPaymentInfoEntityFromJson(String str) {
  final List<dynamic> jsonData = json.decode(str);
  return jsonData.map((item) => PaymentInfoEntity.fromJson(item)).toList();
}

class PaymentInfoEntity {
    final String iduser;
    final String idpaymentinfo;
    final String paymethod;
    final String cardnumber;
    final String expdate;
    final String securitycode;

    PaymentInfoEntity({
        required this.iduser,
        required this.idpaymentinfo,
        required this.paymethod,
        required this.cardnumber,
        required this.expdate,
        required this.securitycode,
    });

    factory PaymentInfoEntity.fromJson(Map<String, dynamic> json) => PaymentInfoEntity(
        iduser: json["iduser"],
        idpaymentinfo: json["idpaymentinfo"],
        paymethod: json["paymethod"],
        cardnumber: json["cardnumber"],
        expdate: json["expdate"],
        securitycode: json["securitycode"],
    );

    Map<String, dynamic> toJson() => {
        "iduser": iduser,
        "idpaymentinfo": idpaymentinfo,
        "paymethod": paymethod,
        "cardnumber": cardnumber,
        "expdate": expdate,
        "securitycode": securitycode,
    };
}
