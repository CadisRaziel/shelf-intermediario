import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';

import 'apis/blog_noticia_api.dart';
import 'apis/login_api.dart';
import 'apis/usuario_api.dart';
import 'dao/usuarios_dao_imp.dart';
import 'infra/custom_server.dart';
import 'infra/database/db_configuration.dart';
import 'infra/dependency_injector/injects.dart';
import 'infra/middleware_interception.dart';
import 'models/usuario_model.dart';
import 'utils/custom_env.dart';

void main() async {
  //!Rever a aula 22 para entender melhor injecao de dependencia "https://www.youtube.com/watch?v=Gp4ArNTc2HA&list=PLRpTFz5_57csByx34C_98wPn3PAxnUDFr&index=24&ab_channel=DeividWillyan%7CFlutter"

  //para poder acessar diversos .env com diferentes informações
  CustomEnv.fromFile('.env');

  //Objeto criado para melhorar a responsabilidade unica da classe main
  final _di = Injects.initialize();

  // UsuariosDaoImp _usuarioDAO = UsuariosDaoImp(_di.get<IDBConfiguration>());
  // var usuario = UsuarioModel()
  //   ..id = 15
  //   ..name = 'novo user'
  //   ..email = 'novouser@email.com'
  //   ..password = '1234';
  // _usuarioDAO.findAll().then(print); //LIST
  // _usuarioDAO.findOne(1).then(print); //OBJ 1
  // _usuarioDAO.create(usuario).then(print); // TRUE
  // usuario.name = 'ATUALIZADO';
  // _usuarioDAO.update(usuario).then(print); // TRUE
  // _usuarioDAO.delete(13).then(print); // TRUE

  //metodo para trabalhar com varios 'handlers' ja que na 'initializeServer' só aceita 1
  var cascadeHandlers = Cascade()
      .add(_di.get<LoginApi>().getHandler())
      .add(
        //isSecurity se for true é necessario que os middleware de segurança seja aplicado nele
        //se for false ele nao precisa ter os middleware de segurança (nao preciso especificar)
        _di.get<BlogNoticiaApi>().getHandler(isSecurity: true),
      )
      .add(_di.get<UsuarioApi>().getHandler(isSecurity: true))
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