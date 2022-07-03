import '../dao/noticia_dao_imp.dart';
import '../models/noticia_model.dart';
import 'generic_service.dart';

class NoticiaService implements IGenericService<NoticiaModel> {
  final NoticiaDaoImp _noticiaDaoImp;
  NoticiaService(this._noticiaDaoImp);

  @override
  Future<bool> delete(int id) async {
    return _noticiaDaoImp.delete(id);
  }

  @override
  Future<List<NoticiaModel>> findAll() async {
    return _noticiaDaoImp.findAll();
  }

  @override
  Future<NoticiaModel?> findOne(int id) async {
    return _noticiaDaoImp.findOne(id);
  }

  @override
  Future<bool> save(NoticiaModel value) async {
    //!Como eu sei se estou criando uma notica ou atualizando uma notica ?
    //!a resposta é: a partir do ID
    //!Quando eu crio a notica ela NUNCA tem ID
    //!Quando eu atualizo a notica ele TEM ID

    if (value.id != null) {
      return _noticiaDaoImp.update(value);
    } else {
      return _noticiaDaoImp.create(value);
    }
  }
}
