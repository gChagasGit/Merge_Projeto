// ignore_for_file: unused_local_variable, iterable_contains_unrelated_type

import 'package:flutter/material.dart';
import 'package:flutter_teste_msql1/components/snackBar_custom.dart';
import 'package:flutter_teste_msql1/controle/ClienteCtrl.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/dao/ClienteDAO.dart';
import 'package:flutter_teste_msql1/modelo/Cliente.dart';

class ClienteProvider with ChangeNotifier {
  int aux = 0;

  List<Cliente> listaDeClientes = [];
  Cliente clienteAtual = Cliente();
  PrincipalCtrl principalCtrl;
  ClienteDAO clienteDAO = ClienteDAO();
  ClienteCtrl clienteCtrl = ClienteCtrl();

  ClienteProvider(this.principalCtrl);

  int numPages = 2;
  int currentPage = 0;
  int _limite = 5;

  Future<List<Cliente>> BuscarListaClientes() async {
    limpar();
    print("TAMANHO LISTA " + listaDeClientes.length.toString());
    print("PAGINA ATUAL " + currentPage.toString());
    contaQuantidadeDeClientes();
    await principalCtrl.clienteCtrl
        .buscarTodosClientes(
            ativo: true, limite: _limite, offset: (currentPage * _limite))
        .then(
      (value) {
        listaDeClientes.addAll(value);
      },
    );
    // listaDeProdutos.forEach((element) async {
    //   await principalCtrl.
    //  }
    //  )
    // print("QUANTIDADE " + listaDeProdutos.length.toString());
    notifyListeners();
    return listaDeClientes;
  }

  limpar() {
    clienteAtual = Cliente();
    listaDeClientes.clear();
    notifyListeners();
  }

  contaQuantidadeDeClientes() async {
    int quant =
        await principalCtrl.clienteCtrl.clienteDAO.contaQuantidadeDeClientes();
    numPages = (quant / _limite).ceil();
    if (numPages == 0) {
      numPages = 1;
    }
  }

  Future<List<Cliente>> loadClientes({String? nome}) async {
    if (nome == null) {
      listaDeClientes = await principalCtrl.clienteCtrl.buscarTodosClientes();
    } else if (nome.isNotEmpty) {
      listaDeClientes =
          await principalCtrl.clienteCtrl.buscarCliente(nome: nome);
    }
    notifyListeners();
    return listaDeClientes;
  }

  List<Cliente> get clientes => listaDeClientes;

  int get count {
    return listaDeClientes.length;
  }

  Future<int> salvar(Cliente cliente, BuildContext context) async {
    listaDeClientes = await principalCtrl.clienteCtrl.buscarTodosClientes();
    var contains = listaDeClientes.where((element) => element.id == cliente.id);
    var contemCpf =
        listaDeClientes.where((element) => element.cpf == cliente.cpf);
    //VERIFICAR EXISTENCIA
    if (contains.isEmpty && contemCpf.isEmpty) {
      print("NAO CONTEM");
      await principalCtrl.clienteCtrl.cadastrarCliente(
        Cliente.DAO(cliente.id, cliente.nome, cliente.telefone, cliente.cpf,
            cliente.diaPrevPag, cliente.status),
      );
      return 0;
    } else if (contains.isNotEmpty) {
      print("CONTEM");
      await principalCtrl.clienteCtrl.alterarCliente(cliente);
      return 0;
    }
    notifyListeners();
    showCustomSnackbar(
        context: context,
        text: "Já possui cliente com esse cpf cadastrado",
        color: Colors.lightBlue);
    return 1;
  }

  void remover(int id) async {
    Cliente cliente =
        (await principalCtrl.clienteCtrl.buscarCliente(id: id)).first;
    principalCtrl.clienteCtrl.excluirCliente(cliente);
    notifyListeners();
  }

  List<Cliente> get items => [...listaDeClientes]; //VERIFICAR
}
