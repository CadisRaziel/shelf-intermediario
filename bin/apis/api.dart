import 'package:shelf/shelf.dart';

import '../infra/dependency_injector/dependency_injector.dart';
import '../infra/security/security_service.dart';

abstract class IApi {
  //2 metodos

  //um que o usuario precisa implementar
  Handler getHandler({
    List<Middleware>? middlewares,
    bool isSecurity = false,
  });

  //um que vamos deixar implementado
  Handler createHandler({
    required Handler router,
    List<Middleware>? middlewares,
    bool isSecurity = false,
  }) {
    //se for nulo atribui uma lista vazia
    //fazendo isso aqui eu nao preciso ficar fazendo isso
    //middlewares?.addAll
    //middlewares?.forEach
    middlewares ??= [];

    //se o isSecurity for true ele adiciona o _securityService
    //se oisSecurity for false ele nao adiciona o _securityService
    if (isSecurity == true) {
      //*Utilizando nosso injetor de dependencia igual o get it
      //DependencyInjector() vai retornar sempre a mesma instancia é um singleton !!
      var _securityService = DependencyInjector().get<ISecurityService>();

      middlewares.addAll([
        _securityService.authorization,
        _securityService.verifyJwt,
      ]);
    }

    //criando uma pipeline e devolvendo um handler
    var pipe = Pipeline();

    //adicionando os middleware
    middlewares.forEach((m) {
      pipe = pipe.addMiddleware(m);
    });

    //devolvendo o handler
    return pipe.addHandler(router);
  }
}


//! o createHandler vai esta fazendo isso \/
  /*
  //Colocando Middleware (repare no terminal '2022-06-19T20:58:34.870555  0:00:00.007970 GET     [200] /blog/noticias')
  var handlerPipe = Pipeline()
      .addMiddleware(logRequests())
      //adicionando a classe de middleware que faz a interceptação e transforma o text/plain em aplication/json
      .addMiddleware(MiddlewareInterception().middlerware)
      .addMiddleware(_securityService.authorization)
      .addMiddleware(_securityService.verifyJwt)
      .addHandler(cascadeHandlers);
*/