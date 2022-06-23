import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/noticia_model.dart';
import '../services/generic_service.dart';

class BlogNoticiaApi {
  //Injetando dependencia do 'IGenericService' aqui dentro do BlogNoticiaApi
  //Essa classe sabe que existe um contrato que implementa os metodos, mais ele nao sabe quem pois pra ele nao importa
  final IGenericService<NoticiaModel> _service;
  BlogNoticiaApi(this._service);

  Handler get handlerBlogApi {
    Router router = Router();

    //!CRUD

    //listagem
    router.get('/blog/noticias', (Request req) {
      //Injetando a dependencia eu posso utilizar os metodos da classe IGenericService(principio D do solid)
      List<NoticiaModel> noticias = _service.findAll();
      List<Map> noticiasMap = noticias.map((e) => e.toMap()).toList();
      return Response.ok(jsonEncode(noticiasMap));
    });

    //nova noticia
    router.post('/blog/noticias', (Request req) async {
      var body = await req.readAsString();
      //Injetando a dependencia eu posso utilizar os metodos da classe IGenericService(principio D do solid)
      _service.save(
        NoticiaModel.fromMap(
          jsonDecode(body),
        ),
      );
      return Response(201);
    });

    //blog/noticias?id=1 (editar uma noticia)
    router.put('/blog/noticias', (Request req) {
      String? id = req.url.queryParameters['id'];
      //Injetando a dependencia eu posso utilizar os metodos da classe IGenericService(principio D do solid)
      // _service.save('');
      return Response.ok('Api de blog');
    });

    //blog/noticias?id=1 (deletar uma noticia)
    router.delete('/blog/noticias', (Request req) {
      String? id = req.url.queryParameters['id'];
      //Injetando a dependencia eu posso utilizar os metodos da classe IGenericService(principio D do solid)
      _service.delete(1);
      return Response.ok('Api de blog');
    });

    return router;
  }
}
