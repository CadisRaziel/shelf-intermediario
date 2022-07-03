import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../infra/security/security_service.dart';

import '../services/login_service.dart';
import '../to/auth_to.dart';
import 'api.dart';

//vou aplicar um extension para poder utilizar o que ja esta implementar
//se eu fizer implements eu vou sobrescrever uma classe que eu ja implementei
class LoginApi extends IApi {
  //injetando dependencia para podermos usar no nosso container de injeção de dependencia
  //Letra D do solid
  final ISecurityService _securityService;
  final LoginService _loginService;
  LoginApi(this._securityService, this._loginService);

  @override
  Handler getHandler({
    List<Middleware>? middlewares,
    bool isSecurity = false,
  }) {
    Router router = Router();

    router.post('/login', (Request req) async {
      var body = await req.readAsString();

      //agora com o 'usuarioTO' conseguimos manipular o email e senha dele
      var authTO = AuthTO.fromRequest(body);
      var userID = await _loginService.authenticate(authTO);
      if (userID > 0) {
        var jwt = await _securityService.generateJWT(userID.toString());
        return Response.ok(jsonEncode({'token': jwt}));
      } else {
        return Response(401);
      }
    });

    return createHandler(
      router: router,
      middlewares: middlewares,
    );
  }
}
