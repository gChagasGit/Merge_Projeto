import 'package:flutter_teste_msql1/controle/CaixaCtrl.dart';
import 'package:flutter_teste_msql1/controle/OpValoresCaixaCtrl.dart';
import 'package:flutter_teste_msql1/controle/UsuarioCtrl.dart';
import 'package:flutter_teste_msql1/modelo/OpValoresCaixa.dart';

import '../modelo/Caixa.dart';

class FechamentoCaixaGUI {
  late CaixaCrtl _caixaCrtl;
  late OpValoresCaixaCrtl _opValoresCaixaCrtl;
  late UsuarioCtrl _usuarioCtrl;

  FechamentoCaixaGUI(CaixaCrtl caixaCrtl, OpValoresCaixaCrtl opValoresCaixaCrtl,
      UsuarioCtrl usuarioCtrl) {
    _caixaCrtl = caixaCrtl;
    _opValoresCaixaCrtl = opValoresCaixaCrtl;
    _usuarioCtrl = usuarioCtrl;
  }

  Future<void> fecharCaixa({required double valor, String? justificativa}) async {

    if(justificativa == null){
      justificativa = "";
    }

    await _caixaSendoFechado(valor, justificativa);
    
    _opValoresCaixaCrtl.opValoresCaixa.caixa = _caixaCrtl.caixa;
    _opValoresCaixaCrtl.salvarOperacaoDeValoresDoCaixa();
    _caixaCrtl.caixa = Caixa();
    // _caixaCrtl.caixa.operacoes.add(_opValoresCaixaCrtl.opValoresCaixa);

  }

  //Pode ser apagado depois
  //é como se fosse uma entrada de valores
  Future<void> _caixaSendoFechado(double valor, String justificativa) async {
    OpValoresCaixa opvc = OpValoresCaixa();
    opvc.caixa = _caixaCrtl.caixa;
    opvc.horario = DateTime.now();
    opvc.justificativa = (justificativa.isNotEmpty)? justificativa : "Fechamento de caixa";
    opvc.tipo = OpValoresCaixaCrtl.FECHAMENTO;
    opvc.usuario = _usuarioCtrl.usuarioLogado;
    opvc.valor = valor;
    _opValoresCaixaCrtl.opValoresCaixa = opvc;
  }
}
