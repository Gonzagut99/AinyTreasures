
//Singleton
import '../../Entity/shoppingcartitem_entity.dart';

class CustomAppData {
  static final CustomAppData _appData = CustomAppData._internal();
  //Encrypt key: 16 caracteres: 128 bits, 16 bytes
  String encryptKkey= "Elgrupo1esmejor)";
  
  //Index-> current button ->BottomNavbar
  int singletonIndex = 0;
  //current user logged usuario actual logeado
  String? currentUserId = '';

  //current product selected*
  String productselectedid = '';

  //Lista de productos en el carrito de compras
  List<ShoppingCartItem> cartItems = [];

  //Totales del carrito
  Map<String,dynamic> totals = {
    'quantity':'0',
    'subtotal':'0.0',
    'discounts':'0.0',
    'delivery':'0.0',
    'total':'0.0'
  };

  factory CustomAppData() {
    return _appData;
  }
  CustomAppData._internal();
}

final appData = CustomAppData();
