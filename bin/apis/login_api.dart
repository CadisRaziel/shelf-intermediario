import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../infra/security/security_service.dart';
import 'api.dart';

//vou aplicar um extension para poder utilizar o que ja esta implementar
//se eu fizer implements eu vou sobrescrever uma classe que eu ja implementei
class LoginApi extends Api {
  //injetando dependencia para podermos usar no nosso container de injeção de dependencia
  //Letra D do solid
  final SecurityService _securityService;
  LoginApi(this._securityService);

  @override
  Handler getHandler({
    List<Middleware>? middlewares,
  }) {
    Router router = Router();

    router.post('/login', (Request req) async {
      var token = await _securityService.generateJWT('1');
      var result = await _securityService.validateJWT(token);

      return Response.ok(token);
    });

    return createHandler(
      router: router,
      middlewares: middlewares,
    );
  }
}
