class NoticiaModel {
  //porque int? olhe na api de blog/noticias e veja que noticias precisa de um id
  final int id;
  final String titulo;
  final String descricao;
  final String imagem;
  final DateTime dtPublicacao;
  final DateTime? dtAtualizacao;

  NoticiaModel({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.imagem,
    required this.dtPublicacao,
    this.dtAtualizacao,
  });

  @override
  String toString() {
    return 'NoticiaModel(id: $id, titulo: $titulo, descricao: $descricao, imagem: $imagem, dtPublicacao: $dtPublicacao, dtAtualizacao: $dtAtualizacao)';
  }
}
