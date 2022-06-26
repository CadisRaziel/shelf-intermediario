//classe criada para melhorar a responsabilidade da main
//pois na main estao sendo criadas varias coisas diferentes

import '../../apis/blog_noticia_api.dart';
import '../../apis/login_api.dart';
import '../../models/noticia_model.dart';
import '../../services/generic_service.dart';
import '../../services/noticia_service.dart';
import '../security/security_service.dart';
import '../security/security_service_imp.dart';
import 'dependency_injector.dart';

class Injects {
  static DependencyInjector initialize() {
    //di vai retornar sempre a mesma instancia !!
    var di = DependencyInjector();

    //lembrando para fazer a injeção de dependencia precisamos que as classes tenha o D do solid
    //no 'LoginApi' olhe no construtor dele !!
    //repare que aqui a tipagem do SecurityService inicialmente era um 'T'
    di.register<ISecurityService>(() => SecurityServiceImp());

    //LoginApi(di.get()) -> o LoginApi esta esperando um SecurityService
    //Então passamos o di.get que vai ser responsavel por encontrar a instancia dele no construtor
    //do proprio loginApi, repare no construtor do LoginApi a gente passando o SecurityService
    di.register<LoginApi>(() => LoginApi(di.get()));

    //o BlogNoticiaApi pra ser criado ele precis do 'NoticiaService'
    //e como passamos o 'IGenericService<NoticiaModel' para o construtor do 'BlogNoticiaApi'
    //precisamos tipar ele aqui
    di.register<IGenericService<NoticiaModel>>(
        //como no NoticiaService nao temos injeção de dependencia ele nao precisa dar um get aqui
        () => NoticiaService());

    di.register<BlogNoticiaApi>(
      () => BlogNoticiaApi(
        di.get(),
      ),
      // se eu passar aqui 'isSingleton = false' estou dizendo que é uma factory
      //se eu nao passo nada por padrao é true e eu digo que é uma singleton
      // isSingleton: false
    );

    return di;
  }
}
