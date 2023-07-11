// To parse this JSON data, do
//
//     final shoppingCartItem = shoppingCartItemFromJson(jsonString);

import 'dart:convert';

ShoppingCartItem shoppingCartItemFromJson(String str) => ShoppingCartItem.fromJson(json.decode(str));

String shoppingCartItemToJson(ShoppingCartItem data) => json.encode(data.toJson());

//Para listas de shopping cart item: importante
List<ShoppingCartItem> listShoppingCartItemFromJson(String str) {
  final List<dynamic> jsonData = json.decode(str);
  return jsonData.map((item) => ShoppingCartItem.fromJson(item)).toList();
}

class ShoppingCartItem {
    final String iduser;
    final String idproduct;
    final String idcartitem;
    final String productname;
    final String productprice;
    final String mainimage;
    final String selectedmeasure;
    String totalquantity;
    final String discount;
    String totalprice;
    String totalwithdiscount;

    ShoppingCartItem({
        required this.iduser,
        required this.idproduct,
        required this.idcartitem,
        required this.productname,
        required this.productprice,
        required this.mainimage,
        required this.selectedmeasure,
        required this.totalquantity,
        required this.discount,
        required this.totalprice,
        required this.totalwithdiscount,
    });

    factory ShoppingCartItem.fromJson(Map<String, dynamic> json) => ShoppingCartItem(
        iduser: json["iduser"],
        idproduct: json["idproduct"],
        idcartitem: json["idcartitem"],
        productname: json["productname"],
        productprice: json["productprice"],
        mainimage: json["mainimage"],
        selectedmeasure: json["selectedmeasure"],
        totalquantity: json["totalquantity"],
        discount: json["discount"],
        totalprice: json["totalprice"],
        totalwithdiscount: json["totalwithdiscount"],
    );

    Map<String, dynamic> toJson() => {
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
}
