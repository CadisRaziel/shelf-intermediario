//classe criada para melhorar a responsabilidade da main
//pois na main estao sendo criadas varias coisas diferentes

import '../../apis/noticias_api.dart';
import '../../apis/login_api.dart';
import '../../apis/usuario_api.dart';
import '../../dao/noticia_dao_imp.dart';
import '../../dao/usuarios_dao_imp.dart';
import '../../models/noticia_model.dart';
import '../../services/generic_service.dart';
import '../../services/login_service.dart';
import '../../services/noticia_service.dart';
import '../../services/usuario_service.dart';
import '../database/db_configuration.dart';
import '../database/mysql_db_configuration_imp.dart';
import '../security/security_service.dart';
import '../security/security_service_imp.dart';
import 'dependency_injector.dart';

class Injects {
  static DependencyInjector initialize() {
    //di vai retornar sempre a mesma instancia !!
    var di = DependencyInjector();

    //!=====================DataBase======================
    //TODO 'DB'
    di.register<IDBConfiguration>(
      () => MysqlDbConfigurationIMP(),
    );
    //!=====================DataBase======================

    //!=====================Segurança======================
    //TODO 'Security'
    //lembrando para fazer a injeção de dependencia precisamos que as classes tenha o D do solid
    //no 'LoginApi' olhe no construtor dele !!
    //repare que aqui a tipagem do SecurityService inicialmente era um 'T'
    di.register<ISecurityService>(
      () => SecurityServiceImp(),
    );
    //!=====================Segurança======================

    //!=====================NOTICIAS======================
    //TODO 'NOTICIAS'
    di.register<NoticiaDaoImp>(
      () => NoticiaDaoImp(
        di.get<IDBConfiguration>(),
      ),
    );
    //o BlogNoticiaApi pra ser criado ele precis do 'NoticiaService'
    //e como passamos o 'IGenericService<NoticiaModel' para o construtor do 'BlogNoticiaApi'
    //precisamos tipar ele aqui
    di.register<IGenericService<NoticiaModel>>(
      //como no NoticiaService nao temos injeção de dependencia ele nao precisa dar um get aqui
      () => NoticiaService(
        di.get<NoticiaDaoImp>(),
      ),
    );

    di.register<NoticiasApi>(
      () => NoticiasApi(
        di.get<IGenericService<NoticiaModel>>(),
      ),
      // se eu passar aqui 'isSingleton = false' estou dizendo que é uma factory
      //se eu nao passo nada por padrao é true e eu digo que é uma singleton
      // isSingleton: false
    );
    //!=====================NOTICIAS======================

    //!=====================USUARIO======================
    //TODO 'USUARIO'
    //registramos primeiro a camada mais externa (aqui será a que trata o db)
    di.register<UsuariosDaoImp>(
      () => UsuariosDaoImp(
        di.get<IDBConfiguration>(),
      ),
    );
    di.register<UsuarioService>(
      () => UsuarioService(
        di.get<UsuariosDaoImp>(),
      ),
    );
    di.register<UsuarioApi>(
      () => UsuarioApi(
        di.get<UsuarioService>(),
      ),
    );
    //!=====================USUARIO======================

    //!=====================LOGIN======================
    //TODO 'LOGIN'
    di.register<LoginService>(
      () => LoginService(
        di.get<UsuarioService>(),
      ),
    );
    di.register<LoginApi>(
      () => LoginApi(
        di.get<ISecurityService>(),
        di.get<LoginService>(),
      ),
    );
    //!=====================LOGIN======================

    return di;
  }
}
