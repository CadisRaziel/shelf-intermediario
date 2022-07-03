import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class NoticiaModel {
  int? id;
  String? title;
  String? description;
  DateTime? dtCreated;
  DateTime? dtUpdated;
  int? userId;

  NoticiaModel();

  factory NoticiaModel.fromMap(Map<String, dynamic> map) {
    //!Caso der um erro de 'Blop' de um toString() aonde deu erro
    //!Aqui deu erro de Blop no descricao
    return NoticiaModel()
      ..id = map['id']?.toInt()
      ..title = map['titulo']
      ..description = map['descricao'].toString()
      ..dtCreated = map['dt_criacao']
      ..dtUpdated = map['dt_autalizacao']
      ..userId = map['id_usuario']?.toInt();
  }

  factory NoticiaModel.fromRequest(Map<String, dynamic> map) {
    return NoticiaModel()
      ..id = map['id']?.toInt()
      ..title = map['title']
      ..description = map['description']
      // ..dtCreated = map['dt_criacao']
      // ..dtUpdated = map['dt_autalizacao']
      ..userId = map['userId']?.toInt();
  }

  Map toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'NoticiaModel(id: $id, title: $title, description: $description, dtCreated: $dtCreated, dtUpdated: $dtUpdated, userId: $userId)';
  }
}
