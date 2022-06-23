//middleware intercepta nossa requisição e faz coisas antes que seja processado

import 'package:shelf/shelf.dart';

//Classe responsavel por deixar o 'headers: {'content-type': 'application/json'}' global
//Para que nos Body > Headers do postman pare de vir text/plain
class MiddlewareInterception {
  Middleware get middlerware => createMiddleware(
        responseHandler: (Response res) => res.change(
          headers: {
            'content-type': 'application/json',
          },
        ),
      );
}
