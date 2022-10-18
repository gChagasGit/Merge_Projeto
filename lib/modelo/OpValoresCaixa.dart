// ignore_for_file: avoid_return_types_on_setters, unnecessary_getters_setters, unused_field, file_names, recursive_getters

import 'package:flutter_teste_msql1/dao/CaixaDAO.dart';
import 'package:flutter_teste_msql1/util/ConversorDataHora.dart';

import 'Caixa.dart';
import 'Usuario.dart';

class OpValoresCaixa {
  late int id;
  late String tipo;
  late double valor;
  late DateTime horario;
  late String justificativa;
  late Usuario usuario;
  late Caixa caixa;

  OpValoresCaixa() {
    id = 0;
    tipo = "";
    valor = 0.0;
    horario = DateTime.now();
    justificativa = "";
    usuario = Usuario();
    caixa = Caixa();
  }

  OpValoresCaixa.DAO(
    this.id,
    this.tipo,
    this.valor,
    this.horario,
    this.justificativa,
    this.usuario,
    this.caixa
  );

  OpValoresCaixa.novo(
      {required int id,
      required String tipo,
      required double valor,
      required DateTime horario,
      required String justificativa,
      required Usuario usuario,
      required Caixa caixa});

  @override
  String toString() {
    // TODO: implement toString
    return "OpValoresCaixa: Usuário (CPF): ${usuario.cpf}, Data: ${horario.toString()}, Tipo: $tipo, Valor: $valor, Justificativa: $justificativa";
  }
}
