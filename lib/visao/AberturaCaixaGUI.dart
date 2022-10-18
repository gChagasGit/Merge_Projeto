import 'package:flutter_teste_msql1/controle/AutenticacaoCtrl.dart';
import 'package:flutter_teste_msql1/controle/CaixaCtrl.dart';
import 'package:flutter_teste_msql1/controle/OpValoresCaixaCtrl.dart';
import 'package:flutter_teste_msql1/controle/UsuarioCtrl.dart';
import 'package:flutter_teste_msql1/modelo/OpValoresCaixa.dart';

class AberturaCaixaGUI {
  late CaixaCrtl _caixaCrtl;
  late OpValoresCaixaCrtl _opValoresCaixaCrtl;
  late UsuarioCtrl _usuarioCtrl;
  late AutenticacaoCtrl _autenticacaoCtrl;

  AberturaCaixaGUI(CaixaCrtl caixaCrtl, OpValoresCaixaCrtl opValoresCaixaCrtl,
      UsuarioCtrl usuarioCtrl, AutenticacaoCtrl autenticacaoCtrl) {
    _caixaCrtl = caixaCrtl;
    _opValoresCaixaCrtl = opValoresCaixaCrtl;
    _usuarioCtrl = usuarioCtrl;
    _autenticacaoCtrl = autenticacaoCtrl;
  }

  Future<bool> abrirCaixa({required double valor}) async {
    await _caixaCrtl.salvarCaixa(
        _caixaCrtl.caixa); //Salva o caixa no banco e trás o id dele

    await _caixaSendoAberto(valor: valor);

    _opValoresCaixaCrtl.opValoresCaixa.caixa = _caixaCrtl.caixa;
    await _opValoresCaixaCrtl.salvarOperacaoDeValoresDoCaixa();
    _caixaCrtl.caixa.operacoes.add(_opValoresCaixaCrtl.opValoresCaixa);
    return _caixaCrtl.caixa.operacoes.isNotEmpty;
  }

  Future<void> _caixaSendoAberto({required double valor}) async {
    OpValoresCaixa opvc = OpValoresCaixa();
    opvc.caixa = _caixaCrtl.caixa;
    opvc.horario = DateTime.now();
    opvc.justificativa = "Abertura de caixa";
    opvc.tipo = OpValoresCaixaCrtl.ABERTURA;
    opvc.usuario = _usuarioCtrl.usuarioLogado;
    opvc.valor = valor;
    _opValoresCaixaCrtl.opValoresCaixa = opvc;
  }
}
