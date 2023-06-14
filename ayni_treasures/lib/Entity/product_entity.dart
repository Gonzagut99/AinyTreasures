// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

//Para listas de productos: importante
List<Product> listProductFromJson(String str) {
  final List<dynamic> jsonData = json.decode(str);
  return jsonData.map((item) => Product.fromJson(item)).toList();
}


class Product {
    final String idproduct;
    final String fullname;
    final String price;
    final String description;
    final String category;
    final String subcategory;
    final int stock;
    final String mainimage;
    final String addimage1;
    final String addimage2;
    final String origin;
    final String carbs;
    final String proteins;
    final String kcal;
    final String fats;
    final String etimology;
    final String infosource;
    final String linksource;
    final bool onsale;
    final bool newarrival;
    final String descount;

    Product({
      this.idproduct = '',
      this.fullname = '',
      this.price = '',
      this.description = '',
      this.category = '',
      this.subcategory = '',
      this.stock = 0,
      this.mainimage = '',
      this.addimage1 = '',
      this.addimage2 = '',
      this.origin = '',
      this.carbs = '',
      this.proteins = '',
      this.kcal = '',
      this.fats = '',
      this.etimology = '',
      this.infosource = '',
      this.linksource = '',
      this.onsale = false,
      this.newarrival = false,
      this.descount = ''
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        idproduct: json["idproduct"],
        fullname: json["fullname"],
        price: json["price"],
        description: json["description"],
        category: json["category"],
        subcategory: json["subcategory"],
        stock: json["stock"],
        mainimage: json["mainimage"],
        addimage1: json["addimage1"],
        addimage2: json["addimage2"],
        origin: json["origin"],
        carbs: json["carbs"],
        proteins: json["proteins"],
        kcal: json["kcal"],
        fats: json["fats"],
        etimology: json["etimology"],
        infosource: json["infosource"],
        linksource: json["linksource"],
        onsale: json["onsale"],
        newarrival: json["newarrival"],
        descount: json["descount"],
    );

    Map<String, dynamic> toJson() => {
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
    Map<String, dynamic> toMap() {
    return {
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
  }
}

class ProductCart {
  final String idproduct;
  final String fullname;
  final String price;
  final String subcategory;
  final String quantity;
  final String mainimage;
  final bool onsale;
  final String descount;
  final String measure; //'Kilos' o 'Gramos'

  ProductCart({
    required this.idproduct,
    required this.fullname,
    required this.price,
    required this.subcategory,
    required this.quantity,
    required this.mainimage,
    required this.onsale,
    required this.descount,
    required this.measure,
  });

  Map<String, dynamic> toMap() {
    return {
        "idproduct": idproduct,
        "fullname": fullname,
        "price": price,
        "subcategory": subcategory,
        "quantity":quantity,
        "mainimage": mainimage,
        "onsale": onsale,
        "descount": descount,
        "measure":measure
    };
  }
}