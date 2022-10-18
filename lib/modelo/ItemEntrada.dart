// ignore_for_file: file_names

import 'package:flutter_teste_msql1/modelo/Produto.dart';
import 'package:flutter_teste_msql1/modelo/RegistroEntrada.dart';

class ItemEntrada {
  late int id;
  late double quantidade;
  late RegistroEntrada registroEntrada;
  late Produto produto;

  ItemEntrada() {
    id = 0;
    quantidade = 0.0;
    registroEntrada = RegistroEntrada();
    produto = Produto();
  }

  ItemEntrada.DAO(this.id, this.quantidade, this.registroEntrada, this.produto);

  ItemEntrada.novo(
      {required int id,
      required double quantidade,
      required RegistroEntrada registroEntrada,
      required Produto produto});

  @override
  String toString() {
    return "Item Entrada: Produto: ${produto.descricao}, Quantia: $quantidade, Registro de Entrada: ${registroEntrada.dataHora}";
  }
}
