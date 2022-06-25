import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import '../../utils/custom_env.dart';
import 'security_service.dart';

class SecurityServiceImp implements SecurityService<JWT> {
  @override
  Future<String> generateJWT(String userID) async {
    var jwt = JWT({
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
  JWT? validateJWT(String token) {
    // TODO: implement validateJWT
    throw UnimplementedError();
  }
}
