// To parse this JSON data, do
//
//     final orderSaleEntity = orderSaleEntityFromJson(jsonString);

import 'dart:convert';

OrderSaleEntity orderSaleEntityFromJson(String str) => OrderSaleEntity.fromJson(json.decode(str));

String orderSaleEntityToJson(OrderSaleEntity data) => json.encode(data.toJson());

//Para listas de order sale: importante
List<OrderSaleEntity> listOrderSaleEntityFromJson(String str) {
  final List<dynamic> jsonData = json.decode(str);
  return jsonData.map((item) => OrderSaleEntity.fromJson(item)).toList();
}

class OrderSaleEntity {
    final String idorder;
    final String iduser;
    final String productslist;
    final String discount;
    final String subtotal;
    final String total;
    final DateTime datesale;
    final String iddeliveryinfo;
    final String idpaymentinfo;

    OrderSaleEntity({
        required this.idorder,
        required this.iduser,
        required this.productslist,
        required this.discount,
        required this.subtotal,
        required this.total,
        required this.datesale,
        required this.iddeliveryinfo,
        required this.idpaymentinfo,
    });

    factory OrderSaleEntity.fromJson(Map<String, dynamic> json) => OrderSaleEntity(
        idorder: json["idorder"],
        iduser: json["iduser"],
        productslist: json["productslist"],
        discount: json["discount"],
        subtotal: json["subtotal"],
        total: json["total"],
        datesale: DateTime.parse(json["datesale"]),
        iddeliveryinfo: json["iddeliveryinfo"],
        idpaymentinfo: json["idpaymentinfo"],
    );

    Map<String, dynamic> toJson() => {
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
}
