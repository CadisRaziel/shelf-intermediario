//arquivo para ler as 'env'
//repare que não estamos utilizando 'packages' para isso

import 'dart:io';
import 'parser_extension.dart';

class CustomEnv {
  //Como nosso .env é 'chave': 'valor', criaremos um MAP
  static Map<String, String> _map = {};
  static String _file = '.env';

  CustomEnv._();

  factory CustomEnv.fromFile(String file) {
    _file = file;
    return CustomEnv._();
  }

  static Future<T> get<T>({required String key}) async {
    if (_map.isEmpty) {
      await _load();
    }
    return _map[key]!.toType(T);
  }

  static Future<void> _load() async {
    //* \n para criar as linhas (repare la no .env que temos 2 linhas)
    List<String> linhas =
        (await _readFile()).replaceAll(String.fromCharCode(13), '').split("\n");
    _map = {
      for (var l in linhas)
        //Repare que estamos removendo o '='
        //esse código vai ficar assim (repare que não tem o '=' igual la no .env e sim ':')
        //"server_address" : "localhost"
        l.split('=')[0]: l.split('=')[1]
    };
  }

  static Future<String> _readFile() async {
    return await File('.env').readAsString();
  }
}
