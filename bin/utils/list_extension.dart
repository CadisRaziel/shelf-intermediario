//! metodo criado para poder retornar um null no arquivo 'noticia_service'
//! no metodo 'save' do firstWhere (o firstWhere não deixa retornar null então estamos criando um firstWhere aqui)
//! assim o nosso firstWhere retornará nulo

extension ListExtension<E> on List<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
