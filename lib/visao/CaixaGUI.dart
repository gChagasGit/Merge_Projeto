import 'package:flutter_teste_msql1/controle/CaixaCtrl.dart';
import 'package:flutter_teste_msql1/controle/OpValoresCaixaCtrl.dart';
import 'package:flutter_teste_msql1/controle/UsuarioCtrl.dart';

class CaixaGUI {
  late CaixaCrtl _caixaCrtl;
  late OpValoresCaixaCrtl _opValoresCaixaCrtl;
  late UsuarioCtrl _usuarioCtrl;

  CaixaGUI(CaixaCrtl caixaCrtl, OpValoresCaixaCrtl opValoresCaixaCrtl,
      UsuarioCtrl usuarioCtrl) {
    _caixaCrtl = caixaCrtl;
    _opValoresCaixaCrtl = opValoresCaixaCrtl;
    _usuarioCtrl = usuarioCtrl;
  }

  Future<void> simulaBuscarTodosCaixasAtivos() async {
    await _caixaCrtl.buscarTodosOsCaixas();

    for (var caixaAtual in _caixaCrtl.caixas) {
      await _opValoresCaixaCrtl.buscarOperacaoPorCaixa(caixaAtual.id);

      for (var operacaoAtual in _opValoresCaixaCrtl.operacoesCaixa) {
        await _usuarioCtrl.buscarUsuario(id: operacaoAtual.usuario.id);
        operacaoAtual.usuario = _usuarioCtrl.usuario;
      }

      caixaAtual.operacoes.addAll(_opValoresCaixaCrtl.operacoesCaixa);
    }

    _caixaCrtl.caixas.forEach((element) {
      print(element);
    });
  }
}
