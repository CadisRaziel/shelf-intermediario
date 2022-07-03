import 'package:password_dart/password_dart.dart';

import '../dao/usuarios_dao_imp.dart';
import '../models/usuario_model.dart';
import 'generic_service.dart';

class UsuarioService implements IGenericService<UsuarioModel> {
  //injetando o UsuarioDao (inversão de dependencia letra D do solid)
  final UsuariosDaoImp _usuariosDaoImp;
  UsuarioService(this._usuariosDaoImp);

  @override
  Future<bool> delete(int id) async {
    return _usuariosDaoImp.delete(id);
  }

  @override
  Future<List<UsuarioModel>> findAll() async {
    return _usuariosDaoImp.findAll();
  }

  @override
  Future<UsuarioModel?> findOne(int id) async {
    return _usuariosDaoImp.findOne(id);
  }

  @override
  //save -> create and update
  Future<bool> save(UsuarioModel value) async {
    //!Como eu sei se estou criando um usuario ou atualizando um usuario ?
    //!a resposta é: a partir do ID
    //!Quando eu crio o usuario ele NUNCA tem ID
    //!Quando eu atualizo o usuario ele TEM ID

    if (value.id != null) {
      return _usuariosDaoImp.update(value);
    } else {
      //somente quando o usuario for criado eu vou por um hash na senha
      final hash = Password.hash(value.password!, PBKDF2());
      value.password = hash;
      return _usuariosDaoImp.create(value);
    }
  }

  //metodo criado para utilizar em 'auth_to.dart'
  Future<UsuarioModel?> findByEmail(String email) async {
    return _usuariosDaoImp.findByEmail(email);
  }
}
