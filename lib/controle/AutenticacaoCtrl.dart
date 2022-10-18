import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_teste_msql1/controle/UsuarioCtrl.dart';

import '../modelo/Usuario.dart';

class AutenticacaoCtrl {
  late UsuarioCtrl _usuarioCtrl;
  late bool _isUsuarioLogado;

  AutenticacaoCtrl(UsuarioCtrl usuarioCtrl) {
    _usuarioCtrl = usuarioCtrl;
    _isUsuarioLogado = false;
  }

  Future<void> autenticarUsuario(
      {required String cpf,
      required String senha,
      required bool administrador}) async {
    if (administrador) {
      print("Busca de usuário por administrador! $administrador");
      await _usuarioCtrl.buscarUsuario(cpf: cpf);
      if (_usuarioCtrl.usuarios.isNotEmpty) {
        _usuarioCtrl.usuarioLogado = _usuarioCtrl.usuarios.first;
        _isUsuarioLogado = true;
      }
    } else {
      if (cpf.isNotEmpty && senha.isNotEmpty) {
        await _usuarioCtrl.buscarUsuario(cpf: cpf);
        if (_usuarioCtrl.usuarios.isNotEmpty &&
            _usuarioCtrl.usuarios.first.senha.compareTo(textToSHA256(senha)) == 0) {
          _usuarioCtrl.usuarioLogado = _usuarioCtrl.usuarios.first;
          print("Senha correta! : NOME : ${_usuarioCtrl.usuarioLogado.nome}");
          _isUsuarioLogado = true;
        } else {
          _usuarioCtrl.usuarioLogado = Usuario();
          _isUsuarioLogado = false;
          print("Senha incorreta!");
        }
      }
    }
  }

  bool get isUsuarioLogado {
    _isUsuarioLogado = _usuarioCtrl.usuarioLogado.nome.isNotEmpty;
    return _isUsuarioLogado;
  }
}

String textToSHA256(String text) {
  return sha256.convert(utf8.encode(text)).toString();
}
