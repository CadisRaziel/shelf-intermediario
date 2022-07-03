//Padrão DAO vai abstrair todos as açoes da nossa database
//TODOS OS SELECTS VÃO ESTAR AQUI
abstract class IDAO<T> {
  //CRUD

  //create
  Future<bool> create(T value);

  //ready(apenas um)
  Future<T?> findOne(int id);

  //update
  Future<bool> update(T value);

  //delete
  Future<bool> delete(int id);

  //varios
  Future<List<T>> findAll();
}
