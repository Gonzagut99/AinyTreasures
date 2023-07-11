import 'package:ayni_treasures/Entity/user_entity.dart';

import '../Model/user_model.dart';

class UserPreferences {

  static Future<User> setMyUser (String? userId)=> UserModel().getUserByIdSqlLite(userid: userId);
  // User(
  //   age: age,
  //   district: district, 
  //   email: email, 
  //   lastname: lastname, 
  //   password: password, 
  //   province: province, 
  //   region: region, 
  //   userid: userid, 
  //   username: username, 
  //   profileimage: profileimage)
}