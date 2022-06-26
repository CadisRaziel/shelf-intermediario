import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/src/middleware.dart';
import '../../utils/custom_env.dart';
import 'security_service.dart';

class SecurityServiceImp implements SecurityService<JWT> {
  @override
  Future<String> generateJWT(String userID) async {
    var jwt = JWT({
      //* tudo aqui dentro é 'claim'
      //Esses nomes esta no arquivo txt 'aprendendo_jwt'
      //millisecondsSinceEpoch -> formato de data em numerico
      'iat': DateTime.now().millisecondsSinceEpoch,
      //userID ->  claim customizada
      'userID': userID,
      'roles': ['admin', 'user']
      //repare que posso passar headers, mais se eu nao passa nada ele vai por valores padroes
      // JWTAlgorithm.HS256 e 'typ': 'JWT'
    } //, header:
        );

    //como a key é um dado sensivel colocamos ela em um .env
    String key = await CustomEnv.get(key: 'jwt_key');

    //sign -> 3 parte do jwt (as assinaturas)
    //secretKey -> padrao (For HMAC algorithms) tem outras (clique no secretKey e veja as outras)
    String token = jwt.sign(SecretKey(key));
    return token;
  }

  @override
  Future<JWT?> validateJWT(String token) async {
    String key = await CustomEnv.get(key: 'jwt_key');
    //verify -> espera receber um token e uma chave (se ele vier preenchido é valido, e nao vier preenchido não é valido)
    try {
      return JWT.verify(token, SecretKey(key));
    } on JWTInvalidError {
      return null;
    } on JWTExpiredError {
      return null;
    } on JWTNotActiveError {
      return null;
    } on JWTUndefinedError {
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  // TODO: implement authorization
  Middleware get authorization {
    return (Handler handler) {
      return (Request req) async {
        String? authorizationHeader = req.headers['Authorization'];
        JWT? jwt;
        if (authorizationHeader != null) {
          if (authorizationHeader.startsWith('Bearer ')) {
            String token = authorizationHeader.substring(7);
            jwt = await validateJWT(token);
          }
        }
        var request = req.change(context: {'jwt': jwt});
        return handler(request);
      };
    };
  }

  //!createMiddleware => é exatamente a mesma coisa que fizemos no metodo acima 'authorization'
  //! a diferença é que para didadica o metodo 'authorization' fizemos na mão só pra aprende seu funcionamento
  //! o metodo createMiddleware ja traz tudo o que esta acima para nós
  @override
  // TODO: implement verifyJwt
  Middleware get verifyJwt => createMiddleware(
        requestHandler: (Request req) {
          //se a requisição for diferente de login ela vem pra ca \/
          if (req.context['jwt'] == null) {
            return Response.forbidden('Not authozired');
          }
          return null;
        },
      );
}
