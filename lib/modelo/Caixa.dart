// ignorefor_file: unnecessary_getters_setters, avoid_return_types_on_setters, unused_field, file_names

import 'package:flutter_teste_msql1/modelo/OpValoresCaixa.dart';

class Caixa {
  late int id;
  late double valorTotalDinheiro;
  late double valorTotalPrazo;
  late double valorTotalPix;
  late double valorTotalCredito;
  late double valorTotalDebito;

  late List<OpValoresCaixa> _operacoes;

  Caixa() {
    id = 0;
    valorTotalDinheiro = 0;
    valorTotalPrazo = 0;
    valorTotalPix = 0;
    valorTotalCredito = 0;
    valorTotalDebito = 0;
    _operacoes = [];
  }

  Caixa.DAO(this.id, this.valorTotalDinheiro, this.valorTotalPrazo,
      this.valorTotalPix, this.valorTotalCredito, this.valorTotalDebito) {
    _operacoes = [];
  }

  Caixa.novo(this.id, this.valorTotalDinheiro, this.valorTotalPrazo,
      this.valorTotalPix, this.valorTotalCredito, this.valorTotalDebito) {
    _operacoes = [];
  }

  void set operacoes(List<OpValoresCaixa> operacoes) {
    operacoes.clear();
    operacoes.addAll(operacoes);
  }

  List<OpValoresCaixa> get operacoes => _operacoes;

  @override
  String toString() {
    return "Caixa: id: $id, Operacoes: ${_operacoes.length}";
  }
}