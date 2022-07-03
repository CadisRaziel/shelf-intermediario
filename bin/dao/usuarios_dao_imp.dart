import '../infra/database/db_configuration.dart';
import '../infra/database/mysql_db_configuration_imp.dart';
import '../models/usuario_model.dart';
import 'dao.dart';

//?TODOS OS SELECTS VÃO ESTAR AQUI

//!Repare que interessante, como na IDAO eu tipei tudo com <T>
//!ao dar o implementar a interface aqui com a tipagem <UsuarioModel>
//!o dart automaticamente tipou tudo que estava como <T> de <UsuarioModel>
class UsuariosDaoImp implements IDAO<UsuarioModel> {
  //invertendo a dependencia para depois buscarmos no injetor de dependencia
  //se eu quero utilizar informações do banco de dados, então a inversão de dependencia
  //precisa ser com a interface do banco de dados aonde tem nossos metodos
  //o IDBConfiguration devolve nosso banco de dados configurado com o metodo 'connection'
  final IDBConfiguration _dbConfiguration;
  UsuariosDaoImp(this._dbConfiguration);

  _execQuery(String sql, [List? params]) async {
    var connection = await _dbConfiguration.connection;
    return await connection.query(sql, params);
  }

  @override
  Future<bool> create(UsuarioModel value) async {
    //* Devemos colocar '?' nos campos pois o mysql ja sabe aonde ele tem que por os valores
    //*'INSERT INTO usuarios (nome, email, password) VALUES ('Deivid', 'deivid@email.com', '123456')'
    //* então vai ficar assim: (lembre-se é 3 '?' porque eu to dizendo aqui (nome, email, password))
    //*'INSERT INTO usuarios (nome, email, password) VALUES (?, ?, ?)'
    var result = await _execQuery(
      'INSERT INTO usuarios (nome, email, password) VALUES (?, ?, ?)',
      [
        value.name,
        value.email,
        value.password,
      ],
    );
    return result.affectedRows > 0;
  }

  @override
  Future<bool> delete(int id) async {
    var result = await _execQuery(
      'DELETE from usuarios where id = ?',
      [id],
    );
    return result.affectedRows > 0;
  }

  @override
  Future<List<UsuarioModel>> findAll() async {
    var result = await _execQuery('SELECT * FROM usuarios');
    return result
        .map((r) => UsuarioModel.fromMap(r.fields))
        .toList()
        .cast<UsuarioModel>();
  }

  @override
  Future<UsuarioModel?> findOne(int id) async {
    var result = await _execQuery(
      'SELECT * FROM usuarios WHERE id = ?',
      [id],
    );
    return result.affectedRows == 0
        ? null
        : UsuarioModel.fromMap(result.first.fields);
  }

  @override
  Future<bool> update(UsuarioModel value) async {
    var result = await _execQuery(
      'UPDATE usuarios set nome = ?, password = ? where id = ?',
      [
        value.name,
        value.password,
        value.id,
      ],
    );
    return result.affectedRows > 0;
  }

  //metodo criado para utilizar na 'usuario_service.dart'
  Future<UsuarioModel?> findByEmail(String email) async {
    var r = await _execQuery('SELECT * FROM usuarios WHERE email = ?', [email]);
    return r.affectedRows == 0 ? null : UsuarioModel.fromEmail(r.first.fields);
  }
}
