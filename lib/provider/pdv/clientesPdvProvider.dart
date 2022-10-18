import 'package:flutter/material.dart';
import 'package:flutter_teste_msql1/controle/ClienteCtrl.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/modelo/Cliente.dart';

class ClientePdvProvider with ChangeNotifier {  

  final int _numPages = 10;
  int _currentPage = 0;

  final PrincipalCtrl _principalCtrl;
  Cliente clienteDaVenda = Cliente();
  late List<Cliente> clientes = [];

  ClientePdvProvider(this._principalCtrl);

  Future<List<Cliente>> buscarClientes({String? nome}) async {
    if (nome != null && nome.isNotEmpty) {
      clientes = await _principalCtrl.clienteCtrl.buscarCliente(nome: nome);
    } else {
      clientes = await _principalCtrl.clienteCtrl
          .buscarTodosClientes(ativo: true); //busca cliente ativos
    }
    notifyListeners();
    return clientes;
  }

  atualizaClienteAtual(Cliente cliente) {
    clienteDaVenda = cliente;
    _principalCtrl.clienteCtrl.cliente = clienteDaVenda;
    notifyListeners();
  }

  limpar() {
    clienteDaVenda = Cliente();
    _principalCtrl.clienteCtrl.cliente = clienteDaVenda;
    clientes.clear();
    notifyListeners();
  }
}
