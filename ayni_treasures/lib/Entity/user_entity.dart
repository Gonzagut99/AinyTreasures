//     final user = userFromJson(jsonString);
// To parse this JSON data, do
//
//     final responseEntity = responseEntityFromJson(jsonString);

import 'dart:convert';

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);
User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    final int age;
    final String district;
    final String email;
    final String lastname;
    final String password;
    final String province;
    final String region;
    final String userid;
    final String username;

    User({
        required this.age,
        required this.district,
        required this.email,
        required this.lastname,
        required this.password,
        required this.province,
        required this.region,
        required this.userid,
        required this.username,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        age: json["age"],
        district: json["district"],
        email: json["email"],
        lastname: json["lastname"],
        password: json["password"],
        province: json["province"],
        region: json["region"],
        userid: json["userid"],
        username: json["username"],
    );

    Map<String, dynamic> toJson() => {
        "age": age,
        "district": district,
        "email": email,
        "lastname": lastname,
        "password": password,
        "province": province,
        "region": region,
        "userid": userid,
        "username": username,
    };
  
  Map<String, dynamic> toMap() {
    return {
      "userid": userid,
      "username": username,
      "lastname": lastname,
      //"password": password,
      "email": email,
      "age": age,
      "region": region,
      "province": province,
      "district": district,
    };
  }
}

// class User {
//   String _userid;
//   String _username;
//   String _lastname;
//   String _password;
//   String _email;
//   int _age;
//   String _region;
//   String _province;
//   String _district;

//   User ({
//     required String userid,
//     required String username,
//     required String lastname,
//     required String password,
//     required String email,
//     required int age,
//     required String region,
//     required String province,
//     required String district
// ,
//   })  : _userid = userid,
//         _username = username,
//         _lastname = lastname,
//         _password = password,
//         _email = email,
//         _age = age,
//         _region = username,
//         _province = lastname,
//         _district = password;

// }