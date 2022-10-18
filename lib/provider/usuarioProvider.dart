import 'package:flutter/material.dart';
import 'package:flutter_teste_msql1/components/snackBar_custom.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/controle/ProdutoCtrl.dart';
import 'package:flutter_teste_msql1/controle/UsuarioCtrl.dart';
import 'package:flutter_teste_msql1/dao/ProdutoDAO.dart';
import 'package:flutter_teste_msql1/dao/UsuarioDAO.dart';
import 'package:flutter_teste_msql1/modelo/Usuario.dart';

class UsuarioProvider with ChangeNotifier {
  List<Usuario> _items = [];
  PrincipalCtrl principalCtrl;
  UsuarioCtrl usuarioCtrl = UsuarioCtrl();
  UsuarioDAO usuarioDAO = UsuarioDAO();
  Usuario usuarioAtual = Usuario();

  UsuarioProvider(this.principalCtrl);

  int numPages = 2;
  int currentPage = 0;
  int _limite = 5;

  Future<List<Usuario>> BuscarListaUsuarios() async {
    limpar();
    // print("TAMANHO LISTA " + listaDeClientes.length.toString());
    // print("PAGINA ATUAL " + currentPage.toString());
    contaQuantidadeDeUsuarios();
    await principalCtrl.usuarioCtrl
        .buscarTodosUsuarios(
            ativo: true, limite: _limite, offset: (currentPage * _limite))
        .then(
      (value) {
        _items.addAll(value);
      },
    );
    notifyListeners();
    return _items;
  }

  limpar() {
    usuarioAtual = Usuario();
    _items.clear();
    notifyListeners();
  }

  contaQuantidadeDeUsuarios() async {
    int quant =
        await principalCtrl.usuarioCtrl.usuarioDAO.contaQuantidadeDeUsuarios();
    numPages = (quant / _limite).ceil();
    if (numPages == 0) {
      numPages = 1;
    }
  }

  Future<List<Usuario>> loadUsuarios({String? nome}) async {
    if (nome == null) {
      _items = await principalCtrl.usuarioCtrl.buscarTodosUsuarios();
    } else {
      _items = await principalCtrl.usuarioCtrl.buscarUsuario(nome: nome);
    }
    notifyListeners();
    return _items;
  }

  List<Usuario> get produtos => _items;

  Future<int> salvar(Usuario usuario, BuildContext context) async {
    _items = await principalCtrl.usuarioCtrl.buscarTodosUsuarios();
    var contains = _items.where((element) =>
        element.id == usuario.id &&
        element.cpf == usuario.cpf); //VERIFICAR EXISTENCIA
    if (contains.isEmpty) {
      print("NAO CONTEM");
      await principalCtrl.usuarioCtrl.cadastrarUsuario(usuario);
      return 0;
    } else if (contains.isNotEmpty) {
      print("CONTEM");
      await principalCtrl.usuarioCtrl.alterarUsuario(usuario);
      return 0;
    }
    showCustomSnackbar(
        context: context,
        text: "Já possui usuário com esse cpf cadastrado",
        color: Colors.lightBlue);
    notifyListeners();
    return 1;
  }

  void remover(int id) async {
    Usuario usuario =
        (await principalCtrl.usuarioCtrl.buscarUsuario(id: id)).first;
    principalCtrl.usuarioCtrl.excluirUsuario(usuario);
    notifyListeners();
  }
}
