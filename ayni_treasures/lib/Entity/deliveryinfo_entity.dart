// To parse this JSON data, do
//
//     final deliveryInfoEntity = deliveryInfoEntityFromJson(jsonString);

import 'dart:convert';

DeliveryInfoEntity deliveryInfoEntityFromJson(String str) => DeliveryInfoEntity.fromJson(json.decode(str));

String deliveryInfoEntityToJson(DeliveryInfoEntity data) => json.encode(data.toJson());

//Para listas de deliveryinfo: importante
List<DeliveryInfoEntity> listDeliveryInfoEntityFromJson(String str) {
  final List<dynamic> jsonData = json.decode(str);
  return jsonData.map((item) => DeliveryInfoEntity.fromJson(item)).toList();
}

class DeliveryInfoEntity {
    final String delivnames;
    final String province;
    final String district;
    final String delivaddress;
    final String postalcode;
    final String telephone;
    final String deliverytype;
    final String deliveryprice;
    final String iduser;
    final String iddelivery;

    DeliveryInfoEntity({
        required this.delivnames,
        required this.province,
        required this.district,
        required this.delivaddress,
        required this.postalcode,
        required this.telephone,
        required this.deliverytype,
        required this.deliveryprice,
        required this.iduser,
        required this.iddelivery,
    });

    factory DeliveryInfoEntity.fromJson(Map<String, dynamic> json) => DeliveryInfoEntity(
        delivnames: json["delivnames"],
        province: json["province"],
        district: json["district"],
        delivaddress: json["delivaddress"],
        postalcode: json["postalcode"],
        telephone: json["telephone"],
        deliverytype: json["deliverytype"],
        deliveryprice: json["deliveryprice"],
        iduser: json["iduser"],
        iddelivery: json["iddelivery"],
    );

    Map<String, dynamic> toJson() => {
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
}
 