import 'package:flutter_teste_msql1/controle/AutenticacaoCtrl.dart';

class LoginGUI {
  late AutenticacaoCtrl _autenticacaoCtrl;

  LoginGUI(AutenticacaoCtrl autenticacaoCtrl) {
    _autenticacaoCtrl = autenticacaoCtrl;
  }

  Future<bool> simularLogin(
      {required String cpf, required String senha, required bool administrador}) async {
    await _autenticacaoCtrl.autenticarUsuario(cpf: cpf, senha: senha, administrador: administrador);
    if (_autenticacaoCtrl.isUsuarioLogado) {
      print("Usuário logado!");
    }
    return _autenticacaoCtrl.isUsuarioLogado;
  }
}
