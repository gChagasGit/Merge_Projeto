import 'package:flutter_teste_msql1/controle/CaixaCtrl.dart';
import 'package:flutter_teste_msql1/controle/OpValoresCaixaCtrl.dart';
import 'package:flutter_teste_msql1/controle/UsuarioCtrl.dart';
import 'package:flutter_teste_msql1/modelo/OpValoresCaixa.dart';

class SangriaCaixaGUI {

  late CaixaCrtl _caixaCrtl;
  late OpValoresCaixaCrtl _opValoresCaixaCrtl;
  late UsuarioCtrl _usuarioCtrl;

  SangriaCaixaGUI(CaixaCrtl caixaCrtl, OpValoresCaixaCrtl opValoresCaixaCrtl,
      UsuarioCtrl usuarioCtrl) {
    _caixaCrtl = caixaCrtl;
    _opValoresCaixaCrtl = opValoresCaixaCrtl;
    _usuarioCtrl = usuarioCtrl;
  }

  Future<void> sangriaCaixa({required double valor, required String justificativa}) async {

    await _sangriaNoCaixa(valor, justificativa);
    
    _opValoresCaixaCrtl.opValoresCaixa.caixa = _caixaCrtl.caixa;
    _opValoresCaixaCrtl.salvarOperacaoDeValoresDoCaixa();
    _caixaCrtl.caixa.operacoes.add(_opValoresCaixaCrtl.opValoresCaixa);

  }

  //Pode ser apagado depois
  //é como se fosse uma entrada de valores
  Future<void> _sangriaNoCaixa(double valor, String justificativa) async {
    OpValoresCaixa opvc = OpValoresCaixa();
    opvc.caixa = _caixaCrtl.caixa;
    opvc.horario = DateTime.now();
    opvc.justificativa = justificativa;
    opvc.tipo = OpValoresCaixaCrtl.SANGRIA;
    opvc.usuario = _usuarioCtrl.usuarioLogado;
    opvc.valor = valor;
    _opValoresCaixaCrtl.opValoresCaixa = opvc;
  }
}
