//! eu passo o <T> aqui para eu poder tipar o 'implements' la no 'NoticiaService'
//! implements IGenericService<NoticiaModel> -> Repare no <NoticiaModel>
//! Se não tivesse esse <T> aqui 'IGenericService<T>' eu nao consegueria fazer isso IGenericService<NoticiaModel> dar essa tipagem
abstract class IGenericService<T> {
  Future<T?> findOne(int id);
  Future<List<T>> findAll();
  //save -> update e create
  Future<bool> save(T value);
  Future<bool> delete(int id);
}
