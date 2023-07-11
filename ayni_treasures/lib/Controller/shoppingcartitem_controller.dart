// Importamos los paquetes necesarios
import '../Model/shoppingcart_model.dart'; 
// Importamos la clase User
import '../Entity/shoppingcartitem_entity.dart';
import 'package:nanoid/nanoid.dart';

class ShoppingCartItemController {
  Future<List<ShoppingCartItem>> getShoppingCartItemsByUserId({required String userId}) async{
    //Variables informacion del backend
    late Future<List<ShoppingCartItem>> futureShoppingCartItem;
    futureShoppingCartItem = ShoppingCartModel().getShoppingCartItemByUserId(userId);
    //UserModel().insertUser(await futureUser);
    return futureShoppingCartItem;
  }

  Future<ShoppingCartItem> getShoppingCartItemById(String id) async{
    return ShoppingCartModel().getShoppingCartItemById(id);
  }

  //ingresar un nuevo producto
  Future<Map<String,dynamic>> postShoppingCartItem({
    required String iduser,
    required String idproduct,
    required String productname,
    required String productprice,
    required String mainimage,
    required String selectedmeasure,
    required String totalquantity,
    required String discount,
    required String totalprice,
    required String totalwithdiscount,
  }) async{
    var idcartitem = nanoid(8);
    final newShoppingCartItem = ShoppingCartModel().postNewShoppingCartItem(iduser: iduser, idproduct: idproduct, idcartitem: idcartitem, productname: productname, productprice: productprice, mainimage: mainimage, selectedmeasure: selectedmeasure, totalquantity: totalquantity, discount: discount, totalprice: totalprice, totalwithdiscount: totalwithdiscount);
    return newShoppingCartItem;
  }

  //modificar un nuevo producto
  Future<Map<String,dynamic>> updateShoppingCartItem({
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
  }) async{
    //var idpaymentinfo = nanoid(8);
    final updatedShoppingCartItem = ShoppingCartModel().updateShoppingCartItem(iduser: iduser, idproduct: idproduct, idcartitem: idcartitem, productname: productname, productprice: productprice, mainimage: mainimage, selectedmeasure: selectedmeasure, totalquantity: totalquantity, discount: discount, totalprice: totalprice, totalwithdiscount: totalwithdiscount);
    return updatedShoppingCartItem;
  }

  Future<String> deleteShoppingCartItem(String id) async{
    //devuelve solo el mensaje
    return ShoppingCartModel().deleteShoppigCartModel(id);
  }
}