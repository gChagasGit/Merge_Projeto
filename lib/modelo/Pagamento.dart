// ignore_for_file: avoid_return_types_on_setters, unnecessary_getters_setters

import 'package:flutter_teste_msql1/modelo/Venda.dart';

import 'TipoPagamento.dart';

class Pagamento {
  late int id;
  late double valor;
  late double novoValor;
  late int numParcelas;
  late DateTime dataPagamento;
  late Venda venda;
  late TipoPagamento tipoPagamento;

  Pagamento() {
    id = 0;
    valor = 0.0;
    novoValor = 0.0;
    numParcelas = 1;
    dataPagamento = DateTime.parse("2000-01-01");
    venda = Venda();
    tipoPagamento = TipoPagamento();
  }

  Pagamento.DAO(
      this.id, this.valor, this.novoValor, this.numParcelas, this.dataPagamento, this.venda, this.tipoPagamento);

  Pagamento.novo(
      {required int id,
      required double valor,
      required double novoValor,
      required int numParcelas,
      required DateTime dataPagamento,
      required Venda venda,
      required TipoPagamento tipoPagamento});

  @override
  String toString() {
    // TODO: implement toString
    return "Pagamento: Valor: $valor, Novo Valor: $novoValor, Nº Parcelas: $numParcelas, Data de Pagamento: $dataPagamento, TipoPagamento: ${tipoPagamento.id} | ${tipoPagamento.descricao}";
  }
}
