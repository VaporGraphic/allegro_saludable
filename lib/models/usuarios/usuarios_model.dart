import 'dart:convert';

class UsuariosModel {
  bool? admin;
  String? firebaseId;
  String? usuario;
  String? password;
  UsuariosModel({
    this.admin,
    this.firebaseId,
    this.usuario,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'admin': admin,
      'firebaseId': firebaseId,
      'usuario': usuario,
      'password': password,
    };
  }

  factory UsuariosModel.fromMap(Map<String, dynamic> map) {
    return UsuariosModel(
      admin: map['admin'],
      firebaseId: map['firebaseId'],
      usuario: map['usuario'],
      password: map['password'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UsuariosModel.fromJson(String source) =>
      UsuariosModel.fromMap(json.decode(source));
}
