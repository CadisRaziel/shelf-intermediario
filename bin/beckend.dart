import 'package:shelf/shelf.dart';

import 'apis/blog_noticia_api.dart';
import 'apis/login_api.dart';
import 'infra/custom_server.dart';
import 'infra/dependency_injector/dependency_injector.dart';
import 'infra/middleware_interception.dart';
import 'infra/security/security_service.dart';
import 'infra/security/security_service_imp.dart';
import 'services/noticia_service.dart';
import 'utils/custom_env.dart';

void main() async {
  //*Utilizando nosso injetor de dependencia igual o get it
  //_di vai retornar sempre a mesma instancia !!
  final _di = DependencyInjector();

  //lembrando para fazer a injeção de dependencia precisamos que as classes tenha o D do solid
  //no 'LoginApi' olhe no construtor dele !!
  //repare que aqui a tipagem do SecurityService inicialmente era um 'T'
  _di.register<SecurityService>(() => SecurityServiceImp(), isSingleton: true);

  var _securityService = _di.get<SecurityService>();

  //para poder acessar diversos .env com diferentes informações
  // CustomEnv.fromFile('.env');
  //metodo para trabalhar com varios 'handlers' ja que na 'initializeServer' só aceita 1
  var cascadeHandlers = Cascade()
      //repare que ao passar a injeção de dependencia nos passamos quem esta implementando esse contrato
      //porém no construtor da loginApi nos passamos o contrato 'SecurityService'
      .add(LoginApi(_securityService).getHandler())
      //injetando dependencia como se fosse no provider (porém sem provider)
      .add(
        BlogNoticiaApi(NoticiaService()).getHandler(
          middlewares: [
            //repare agora que eu nao preciso ter a autorização e a verificação ali em baixo na pipeline
            //como estão implementados aqui só serão executados aqui (assim vai para outras apis)
            //isso deixa a pipeline local, do jeito que esta comentado ali em baixo esta global
            _securityService.authorization,
            _securityService.verifyJwt,
          ],
        ),
      )
      .handler;

  //Colocando Middleware (repare no terminal '2022-06-19T20:58:34.870555  0:00:00.007970 GET     [200] /blog/noticias')
  var handlerPipe = Pipeline()
      .addMiddleware(logRequests())
      //adicionando a classe de middleware que faz a interceptação e transforma o text/plain em aplication/json
      .addMiddleware(MiddlewareInterception().middlerware)
      // .addMiddleware(_securityService.authorization)
      // .addMiddleware(_securityService.verifyJwt)
      .addHandler(cascadeHandlers);

  await CustomServer().initializeServer(
    handler: handlerPipe,
    address: await CustomEnv.get<String>(key: 'server_address'),
    port: await CustomEnv.get<int>(key: 'server_port'),
  );
}

//Middleware -> Quando colocarmos autenticação, algumas url só serão possivel ser acessadas com autenticação
// ou seja o 'Middleware' vai verificar se o usuario ta logado ou não