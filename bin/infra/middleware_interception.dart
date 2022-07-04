//middleware intercepta nossa requisição e faz coisas antes que seja processado

import 'package:shelf/shelf.dart';

//Classe responsavel por deixar o 'headers: {'content-type': 'application/json'}' global
//Para que nos Body > Headers do postman pare de vir text/plain
class MiddlewareInterception {
  static Middleware get contentTypeJson => createMiddleware(
        responseHandler: (Response res) => res.change(
          headers: {
            'content-type': 'application/json',
          },
        ),
      );

  //!ativando o cors
  static Middleware get cors {
    //'*' -> expressão regular um regex que fala que ele esta aceitando requisições de todas as origens
    //com isso nossa api esta publica !!
    //caso eu queira que só um site em especifico consiga fazer requisições da nossa api
    //eu deveria colocar no lugar de '*' coloraria a url do site 'www.vitor.com.br'
    final headersPermitidos = {'Access-Control-Allow-Origin': '*'};

    //mostrando quais opções temos disponivel (get ou put ou delete ou post)
    Response? handlerOption(Request req) {
      if (req.method == 'OPTIONS') {
        return Response(200, headers: headersPermitidos);
      } else {
        return null;
      }
    }

    //alterando meu header para que ele tenha essa variavel 'headersPermitidos' explicitamente
    Response addCorsHeader(Response res) => res.change(
          headers: headersPermitidos,
        );

    return createMiddleware(
      requestHandler: handlerOption,
      responseHandler: addCorsHeader,
    );
  }
}
