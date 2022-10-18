import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_teste_msql1/dao/UsuarioDAO.dart';
import 'package:flutter_teste_msql1/modelo/Usuario.dart';

class UsuarioCtrl {
  late Usuario _usuario;
  late Usuario _usuarioLogado;
  late List<Usuario> _usuarios;
  late UsuarioDAO _usuarioDAO;

  UsuarioCtrl() {
    _usuario = Usuario();
    _usuarioLogado = Usuario();
    _usuarioDAO = UsuarioDAO();
    _usuarios = [];
  }

  void set usuario(Usuario usuario) {
    _usuario = usuario;
  }

  Usuario get usuario => _usuario;

  void set usuarioLogado(Usuario usuario) {
    _usuarioLogado = usuario;
  }

  Usuario get usuarioLogado => _usuarioLogado;

  List<Usuario> get usuarios => _usuarios;

  Future<void> cadastrarUsuario(Usuario usuario) async {
    usuario.senha = textToSHA256(usuario.senha);
    _usuario.id = await _usuarioDAO.salvar(usuario);
  }

  Future<void> alterarUsuario(Usuario usuario) async {
    await _usuarioDAO.alterar(usuario);
  }

  Future<List<Usuario>> buscarUsuario(
      {int? id, String? nome, String? cpf}) async {
    if (id != null) {
      await _usuarioDAO.buscaPorId(id).then((user) {
        _usuario = user;
      });
      return [_usuario];
    }
    if (nome != null || cpf != null) {
      await _usuarioDAO
          .buscarPorEspecificacao(nome: nome, cpf: cpf)
          .then((users) {
        _usuarios.clear();
        _usuarios.addAll(users);
      });
    }
    return _usuarios;
  }

  Future<List<Usuario>> buscarTodosUsuarios(
      {int? limite = 10, int? offset = 0, bool? ativo}) async {
    await _usuarioDAO
        .buscarTodos(limite: limite, offset: offset, ativo: ativo)
        .then((value) {
      _usuarios.clear();
      _usuarios.addAll(value);
    });
    return _usuarios;
  }

  UsuarioDAO get usuarioDAO => _usuarioDAO;

  void excluirUsuario(Usuario usuario) {
    _usuarioDAO.excluir(usuario);
  }
}

String textToSHA256(String text) {
  return sha256.convert(utf8.encode(text)).toString();
}
