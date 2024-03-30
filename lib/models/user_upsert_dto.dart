import 'dart:convert';

class UserUpsertDto {
  String name;
  String password;

  UserUpsertDto({required this.name, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'password': password,
    };
  }

  String toBase64() {
    String jsonStr = json.encode(toJson());
    String base64Str = base64.encode(utf8.encode(jsonStr));
    return base64Str;
  }
}