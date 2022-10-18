// ignore_for_file: avoid_return_types_on_setters, unnecessary_getters_setters

import 'package:flutter_teste_msql1/dao/Dao.dart';
import 'package:flutter_teste_msql1/modelo/Venda.dart';

import 'Produto.dart';

class ItemVenda {
  
  late int id;
  late double quantidadeVendida;
  late double valorVendido;
  late Produto produto;
  late Venda venda;

  ItemVenda() {
    id = 0;
    quantidadeVendida = 0.0;
    valorVendido = 0.0;
    produto = Produto();
    venda = Venda();
  }

  ItemVenda.DAO(this.id, this.quantidadeVendida, this.valorVendido,
      this.produto, this.venda);

  ItemVenda.novo(
      {required int id,
      required double quantidadeVendida,
      required double valorVenda,
      required Produto produto,
      required Venda venda});

  @override
  String toString() {
    return "ItemVenda: Produto: ${produto.descricao}, Valor venda: $valorVendido, Quantidade Vendida: $quantidadeVendida";
  }
}
