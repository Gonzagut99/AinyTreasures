// Importamos los paquetes necesarios
import '../Model/ordersale_model.dart'; 
// Importamos la clase User
import '../Entity/ordersale_entity.dart';
import 'package:nanoid/nanoid.dart';
class OrderSaleController {
  // Método para obtener la lista de libros
  //List<User> get UserList => _UserList;
  Future<List<OrderSaleEntity>> getOrderSaleByUserId({required String userId}) async{
    //Variables informacion del backend
    late Future<List<OrderSaleEntity>> futureOrderSaleList;
    futureOrderSaleList = OrderSaleModel().getOrdersSaleEntity(userId);
    //UserModel().insertUser(await futureUser);
    return futureOrderSaleList;
  }

  Future<OrderSaleEntity> getOrderSaleEntityById(String id) async{
    return OrderSaleModel().getOrderSaleEntityById(id);
  }

  //ingresar un nuevo producto
  Future<Map<String,dynamic>> postNewOrderSale({
    required String iduser,
    required String productslist,
    required String discount,
    required String subtotal,
    required String total,
    required DateTime datesale,
    required String iddeliveryinfo,
    required String idpaymentinfo,
  }) async{
    var idorder = nanoid(8);
    final newOrderSale = OrderSaleModel().postOrderSaleEntity(idorder: idorder, iduser: iduser, productslist: productslist, discount: discount, subtotal: subtotal, total: total, datesale: datesale, iddeliveryinfo: iddeliveryinfo, idpaymentinfo: idpaymentinfo);
    return newOrderSale;
  }

  Future<String> deleteOrderSale(String id) async{
    //devuelve solo el mensaje
    return OrderSaleModel().deleteOrderSale(id);
  }
}