// To parse this JSON data, do
//
//     final responseEntity = responseEntityFromJson(jsonString);

import 'dart:convert';

ResponseEntity responseEntityFromJson(String str) => ResponseEntity.fromJson(json.decode(str));

String responseEntityToJson(ResponseEntity data) => json.encode(data.toJson());

class ResponseEntity {
    final dynamic entity;
    final String message;
    final dynamic status;

    ResponseEntity({
        required this.entity,
        required this.message,
        required this.status,
    });

    factory ResponseEntity.fromJson(Map<String, dynamic> json) => ResponseEntity(
        entity: json["entity"],
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "entity": entity.toJson(),
        "message": message,
        "status": status,
    };
}