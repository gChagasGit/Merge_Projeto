// ignore_for_file: avoid_return_types_on_setters, file_names

import 'package:flutter_teste_msql1/modelo/Inventario.dart';
import 'package:flutter_teste_msql1/modelo/ItemEntrada.dart';
import 'package:flutter_teste_msql1/modelo/Produto.dart';

class ItemInventario {
  late int id;
  late double quantidade;
  late Inventario inventario;
  late Produto produto;

  ItemInventario() {
    id = 0;
    quantidade = 0.0;
    inventario = Inventario();
    produto = Produto();
  }

  ItemInventario.DAO(this.id, this.quantidade, this.inventario, this.produto);

  ItemInventario.novo(
      {required int id,
      required double quantidade,
      required Inventario inventario,
      required Produto produto});

  @override
  String toString() {
    // TODO: implement toString
    return "ItemInventario | Inventário: ${inventario.id}, Produto: ${produto.descricao}, Quant.: $quantidade";
  }
}
