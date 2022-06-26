import 'package:shelf/shelf.dart';

abstract class ISecurityService<T> {
  Future<String> generateJWT(String userID);
  Future<T?> validateJWT(String token);

  // vamos criar 2 middlewares
  //1 verifyJwt -> autorização (vai popular as claim no usuario) (segurança)
  //2 authorization-> autenticação (vai validar se existe no contesto do usuario)
  Middleware get verifyJwt;
  Middleware get authorization;
}
