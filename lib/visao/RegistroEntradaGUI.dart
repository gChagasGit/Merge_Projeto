import 'package:flutter_teste_msql1/controle/RegistroEntradaCtrl.dart';
import 'package:flutter_teste_msql1/controle/UsuarioCtrl.dart';
import 'package:flutter_teste_msql1/modelo/RegistroEntrada.dart';
import 'package:flutter_teste_msql1/modelo/Usuario.dart';

class RegistroEntradaGUI {
  late RegistroEntradaCtrl _registroEntradaCtrl;
  late UsuarioCtrl _usuarioCtrl;

  RegistroEntradaGUI(
      RegistroEntradaCtrl registroEntradaCtrl, UsuarioCtrl usuarioCtrl) {
    _registroEntradaCtrl = registroEntradaCtrl;
    _usuarioCtrl = usuarioCtrl;
  }

  Future<void> simulaSalvarRegistroDeEntrada() async {
    RegistroEntrada re = RegistroEntrada();

    re.dataHora = DateTime.now();

    re.usuario = _usuarioCtrl.usuarioLogado;

    _registroEntradaCtrl.registroEntrada = re;
    // await _registroEntradaCtrl.salvarRegistroEntrada();
  }
}
