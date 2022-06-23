import '../models/noticia_model.dart';
import '../utils/list_extension.dart';
import 'generic_service.dart';

class NoticiaService implements IGenericService<NoticiaModel> {
  //criando uma lista de noticia para simular um banco de dados
  final List<NoticiaModel> _fakeDB = [];

  @override
  bool delete(int id) {
    _fakeDB.removeWhere((e) => e.id == id);
    return true;
  }

  @override
  List<NoticiaModel> findAll() {
    return _fakeDB;
  }

  @override
  NoticiaModel findOne(int id) {
    return _fakeDB.firstWhere((e) => e.id == id);
  }

  @override
  bool save(NoticiaModel value) {
    //*Não Utilizando nossa extension que retorna null
    // NoticiaModel model = _fakeDB.firstWhere(
    //   //*se não encontrarmos o nosso 'id' dentro da lista
    //   //*if
    //   (e) => e.id == value.id,
    //   //*nos utilizaremos o 'orElse' para retornar o value
    //   //*orElse é como se fosse um if else
    //   //*else
    //   orElse: (() {
    //     _fakeDB.add(value);
    //     return value;
    //   }),
    // );
    // return true;

    //*Utilizando nossa extension que retorna null
    NoticiaModel? model = _fakeDB.firstWhereOrNull(
      (e) => e.id == value.id,
    );
    //se o model nao for encontrado igual a null significa que é um novo objeto
    if (model == null) {
      //com isso adicionamos o value então
      _fakeDB.add(value);
    } else {
      //se o model for encontrado e for diferente de nullo (ele ja existe)
      //o indexOf vai me devolver o index do model dentro da nossa lista
      var index = _fakeDB.indexOf(model);
      _fakeDB[index] = value;
    }
    return true;
  }
}
