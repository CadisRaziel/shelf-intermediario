import 'package:shelf/shelf.dart';

abstract class Api {
  //2 metodos

  //um que o usuario precisa implementar
  Handler getHandler({List<Middleware>? middlewares});

  //um que vamos deixar implementado
  Handler createHandler({
    required Handler router,
    List<Middleware>? middlewares,
  }) {
    //se for nulo atribui uma lista vazia
    middlewares ??= [];

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