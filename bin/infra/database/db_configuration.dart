abstract class IDBConfiguration {
  //criar conexão
  Future<dynamic> createConnection();

  //getter para a conexao ja configurada
  Future<dynamic> get connection;
}
