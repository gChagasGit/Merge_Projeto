// ignore_for_file: file_names, unnecessary_getters_setters, avoid_return_types_on_setters

import 'package:flutter_teste_msql1/modelo/ItemEntrada.dart';
import 'package:flutter_teste_msql1/modelo/Usuario.dart';

class RegistroEntrada {
  late int id;
  late Usuario usuario;
  late DateTime dataHora;

  RegistroEntrada() {
    id = 0;
    usuario = Usuario();
    dataHora = DateTime.now();
  }

  RegistroEntrada.DAO(this.id, this.dataHora, this.usuario);

  RegistroEntrada.novo(
      {required int id, required Usuario usuario, required DateTime dataHora});

  @override
  String toString() {
    // TODO: implement toString
    return "RegistroEntrada: Usuário: ${usuario.nome} | Data/Hora: ${dataHora}";
  }
}
