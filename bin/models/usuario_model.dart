import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UsuarioModel {
  //!Repare que o campo de senha não estamos passando para o construtor e não estamos passando para o
  //!toString e fromMap pois ela só vai retornar em um momento e sera algo delicado e não podemos ter log dela

  int? id;
  String? name;
  String? email;
  String? password;
  bool? isActived;
  DateTime? dtCreated;
  DateTime? dtUpdated;

  UsuarioModel();

  UsuarioModel.create(
    this.id,
    this.name,
    this.email,
    this.isActived,
    this.dtCreated,
    this.dtUpdated,
  );

  @override
  String toString() {
    return 'UsuarioModel(id: $id, name: $name, email: $email, isActived: $isActived, dtCreated: $dtCreated, dtUpdated: $dtUpdated)';
  }

  factory UsuarioModel.fromMap(Map<String, dynamic> map) {
    return UsuarioModel.create(
        map['id'].toInt() ?? 0,
        map['nome'] ?? '',
        map['email'] ?? '',
        map['is_ativo'] == 1,
        map['dt_criacao'] ?? DateTime.now(),
        map['dt_atualizacao'] ?? DateTime.now());
  }

  //para utilizarmos na 'usuario_api'
  factory UsuarioModel.fromRequest(Map<String, dynamic> map) {
    return UsuarioModel()
      ..name = map['name']
      ..email = map['email']
      ..password = map['password'];
  }
}
