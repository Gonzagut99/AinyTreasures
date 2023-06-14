// Importamos los paquetes necesarios
import '../Model/product_model.dart'; 
// Importamos la clase User
import '../Entity/product_entity.dart';
import 'package:nanoid/nanoid.dart';

// Creamos la capa Controlador
class ProductController {
  //List<User>? _usersList;

  // Método para obtener la lista de libros
  //List<User> get UserList => _UserList;
  Future<List<Product>> getProductsBySubcategory({required String subcategory}) async{
    //Variables informacion del backend
    late Future<List<Product>> futureProductList;
    futureProductList = ProductModel().getProductsBySubcategory(subcategory);
    //UserModel().insertUser(await futureUser);
    return futureProductList;
  }

  //ingresar un nuevo producto
  Future<Map<String,dynamic>> postNewProduct({
    required String fullname,
    required String price,
    required String description,
    required String category,
    required String subcategory,
    required int stock,
    required String mainimage,
    required String addimage1,
    required String addimage2,
    required String origin,
    required String carbs,
    required String proteins,
    required String kcal,
    required String fats,
    required String etimology,
    required String infosource,
    required String linksource,
    required bool onsale,
    required bool newarrival,
    required String descount
  }) async{
    var idproduct = nanoid(8);
    final newProduct = ProductModel().postNewProduct(idproduct:idproduct,fullname:fullname, price: price, description:description,category:category, subcategory: subcategory, stock: stock, mainimage: mainimage, addimage1: addimage1, addimage2:addimage2 , origin:origin , carbs:carbs , proteins:proteins , kcal:kcal , fats:fats , etimology:etimology , infosource:infosource , linksource:linksource , onsale:onsale , newarrival:newarrival , descount:descount);
    return newProduct;
  }
}