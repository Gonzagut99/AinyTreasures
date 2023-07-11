// Importamos los paquetes necesarios
import '../Model/deliveryinfo_model.dart'; 
// Importamos la clase User
import '../Entity/deliveryinfo_entity.dart';
import 'package:nanoid/nanoid.dart';

class DeliveryInfoController {
  // Método para obtener la lista de libros
  //List<User> get UserList => _UserList;
  Future<List<DeliveryInfoEntity>> getDeliveryInfoByUserId({required String userId}) async{
    //Variables informacion del backend
    late Future<List<DeliveryInfoEntity>> futureDeliveryInfoList;
    futureDeliveryInfoList = DeliveryInfoModel().getDeliveryInfoByUserId(userId);
    //UserModel().insertUser(await futureUser);
    return futureDeliveryInfoList;
  }

  //ingresar un nuevo producto
  Future<Map<String,dynamic>> postNewDeliveryInfoEntity({
    required String delivnames,
    required String province,
    required String district,
    required String delivaddress,
    required String postalcode,
    required String telephone,
    required String deliverytype,
    required String deliveryprice,
    required String iduser,
  }) async{
    var iddelivery = nanoid(8);
    final newDeliveryInfo = DeliveryInfoModel().postNewDeliveryInfoEntity(delivnames: delivnames, province: province, district: district, delivaddress: delivaddress, postalcode: postalcode, telephone: telephone, deliverytype: deliverytype, deliveryprice: deliveryprice, iduser: iduser, iddelivery: iddelivery);
    return newDeliveryInfo;
  }

  //ingresar un nuevo producto
  Future<Map<String,dynamic>> updateDeliveryInfoEntity({
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
  }) async{
    //var iddelivery = nanoid(8);
    final updatedDeliveryInfo = DeliveryInfoModel().postNewDeliveryInfoEntity(delivnames: delivnames, province: province, district: district, delivaddress: delivaddress, postalcode: postalcode, telephone: telephone, deliverytype: deliverytype, deliveryprice: deliveryprice, iduser: iduser, iddelivery: iddelivery);
    return updatedDeliveryInfo;
  }


  Future<String> deleteDeliveryInfo(String id) async{
    //devuelve solo el mensaje
    return DeliveryInfoModel().deleteDeliveryInfo(id);
  }
}