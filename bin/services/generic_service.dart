//! eu passo o <T> aqui para eu poder tipar o 'implements' la no 'NoticiaService'
//! implements IGenericService<NoticiaModel> -> Repare no <NoticiaModel>
//! Se não tivesse esse <T> aqui 'IGenericService<T>' eu nao consegueria fazer isso IGenericService<NoticiaModel> dar essa tipagem
abstract class IGenericService<T> {
  T findOne(int id);
  List<T> findAll();
  //save -> vai salvar um novo objeto ou um ja existente
  bool save(T value);
  bool delete(int id);
}
