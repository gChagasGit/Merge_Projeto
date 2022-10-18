import 'package:flutter_teste_msql1/controle/CaixaCtrl.dart';
import 'package:flutter_teste_msql1/controle/OpValoresCaixaCtrl.dart';
import 'package:flutter_teste_msql1/controle/UsuarioCtrl.dart';
import 'package:flutter_teste_msql1/modelo/OpValoresCaixa.dart';

class AporteCaixaGUI {

  late CaixaCrtl _caixaCrtl;
  late OpValoresCaixaCrtl _opValoresCaixaCrtl;
  late UsuarioCtrl _usuarioCtrl;

  AporteCaixaGUI(CaixaCrtl caixaCrtl, OpValoresCaixaCrtl opValoresCaixaCrtl,
      UsuarioCtrl usuarioCtrl) {
    _caixaCrtl = caixaCrtl;
    _opValoresCaixaCrtl = opValoresCaixaCrtl;
    _usuarioCtrl = usuarioCtrl;
  }

  Future<void> aporteNoCaixa({required double valor, required String justificativa}) async {

    await _aporteNoCaixa(valor, justificativa);
    
    _opValoresCaixaCrtl.salvarOperacaoDeValoresDoCaixa();
    _caixaCrtl.caixa.operacoes.add(_opValoresCaixaCrtl.opValoresCaixa);

  }

  //Pode ser apagado depois
  //é como se fosse uma entrada de valores
  Future<void> _aporteNoCaixa(double valor, String justificativa) async {
    OpValoresCaixa opvc = OpValoresCaixa();
    opvc.caixa = _caixaCrtl.caixa;
    print("_simulaAporteNoCaixa | ${_caixaCrtl.caixa}");
    opvc.horario = DateTime.now();
    opvc.justificativa = justificativa;
    opvc.tipo = OpValoresCaixaCrtl.APORTE;
    opvc.usuario = _usuarioCtrl.usuarioLogado;
    opvc.valor = valor;
    _opValoresCaixaCrtl.opValoresCaixa = opvc;
  }
}
