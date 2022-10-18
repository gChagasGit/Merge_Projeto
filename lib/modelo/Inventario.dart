// ignore_for_file: avoid_return_types_on_setters, unnecessary_getters_setters, file_names

import 'package:flutter_teste_msql1/modelo/ItemInventario.dart';
import 'package:flutter_teste_msql1/modelo/Usuario.dart';

class Inventario {
  late int id;
  late DateTime dataHora;
  late Usuario usuario;

  Inventario() {
    id = 0;
    dataHora = DateTime.now();
    usuario = Usuario();
  }

  Inventario.DAO(this.id, this.dataHora, this.usuario);

  Inventario.novo(
      {required int id,
      required DateTime dataHota,
      required Usuario usuario,
      required List<ItemInventario> itensInventariados});

  @override
  String toString() {
    return "Inventário: Data/Hora: ${dataHora}, Usuário: ${usuario.nome}";
  }
}
