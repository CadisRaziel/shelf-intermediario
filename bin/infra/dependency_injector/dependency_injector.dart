//*Container de injeção de dependencias

typedef T InstanceCreator<T>();

//* Aqui fizemos um container de injeção de dependencia igual o get it
class DependencyInjector {
  //criando um singleton (o construtor '()' não é visivel fora dessa classe)
  DependencyInjector._();

  //criando um metodo static que vai armazenar o singleton 'DependencyInjector._();'
  //_singleton poderia ser 'instance' que é o nome mais comum
  static final _singleton = DependencyInjector._();

  //criando uma factory para criar novos contrutores
  factory DependencyInjector() => _singleton;

  //!o que esta acontecendo acima
  //!toda vez que o usuario chamar 'DependencyInjector' e fazer a construção dele 'DependencyInjector()'
  //!ele vai devolver nosso '_singleton' que tem uma unica instancia que vai ser criado uma unica vez
  //!com isso podemos chamar a classe como um objeto DependencyInjector() porem será um singleton

  //mapa para guardar todas nossas instancias, toda vez que o usuario fazer o get
  //eu vou pra dentro desse mapa e tentar trazer essa instancia para devolver para o usuario
  final _instanceMap = Map<Type, _InstanceGenerator<Object>>();

  //metodo para registrar as intancias
  void register<T extends Object>(
    InstanceCreator<T> instance, {
    bool isSingleton = false,
  }) {
    _instanceMap[T] = _InstanceGenerator(
      instance,
      isSingleton,
    );
  }

  //metodo para devolver nossa instancia
  T get<T extends Object>() {
    final instance = _instanceMap[T]?.getInstance();
    if (instance != null && instance is T) {
      return instance;
    }
    throw Exception('[ERROR] -> Instance ${T.toString()} not found');
  }
}

//responsabilidade dessa classe privada
//pegar nossa instancia(se é um singleton ou não) e vai devolver a instancia
//do nosso objeto fabricada
class _InstanceGenerator<T> {
  //<T> -> quem chamar esse cara vai tipar com o que for ideal para ele
  //<T> -> quando crio assim eu nao sei o tipo dele, só vou saber quando alguem instanciar e passar um tipo
  //repare que passei ela para a variavel '_instanceMap' e tipei ela como Object

  T? _instance;
  bool _isFirstGet = false;

  final InstanceCreator<T> _instanceCreator;
  _InstanceGenerator(this._instanceCreator, bool isSingleton)
      : _isFirstGet = isSingleton;

  T? getInstance() {
    if (_isFirstGet) {
      //se for a primeira vez que o usuario esta pegando essa instancia
      //ela vai criar o _instanceGenerator
      _instance = _instanceCreator();
      _isFirstGet = false;
    }
    return _instance ?? _instanceCreator();
  }
}
