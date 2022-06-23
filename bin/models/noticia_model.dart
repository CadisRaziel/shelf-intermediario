import 'dart:convert';

class NoticiaModel {
  //porque int? olhe na api de blog/noticias e veja que noticias precisa de um id
  final int? id;
  final String titulo;
  final String descricao;
  final String imagem;
  final DateTime dtPublicacao;
  final DateTime? dtAtualizacao;

  NoticiaModel(
    this.id,
    this.titulo,
    this.descricao,
    this.imagem,
    this.dtPublicacao,
    this.dtAtualizacao,
  );

  @override
  String toString() {
    return 'NoticiaModel(id: $id, titulo: $titulo, descricao: $descricao, imagem: $imagem, dtPublicacao: $dtPublicacao, dtAtualizacao: $dtAtualizacao)';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'imagem': imagem,
      'dtPublicacao': dtPublicacao.millisecondsSinceEpoch,
      'dtAtualizacao': dtAtualizacao?.millisecondsSinceEpoch,
    };
  }

  factory NoticiaModel.fromMap(Map<String, dynamic> map) {
    return NoticiaModel(
      map['id'] ?? '',
      map['titulo'] ?? '',
      map['descricao'] ?? '',
      map['imagem'] ?? '',
      DateTime.fromMillisecondsSinceEpoch(map['dtPublicacao']),
      map['dtAtualizacao'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dtAtualizacao'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NoticiaModel.fromJson(String source) =>
      NoticiaModel.fromMap(json.decode(source));
}
