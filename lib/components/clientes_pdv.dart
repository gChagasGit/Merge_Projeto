import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_teste_msql1/provider/clienteProvider.dart';
import 'package:provider/provider.dart';

import '../modelo/Cliente.dart';
import '../provider/pdv/clientesPdvProvider.dart';

Future clientes_PDV(
    BuildContext _context, ClientePdvProvider clientePdvProvider, bool aPrazo) {

  final _pesquisaProdutoController = TextEditingController();
  _pesquisaProdutoController.text = "";
  return showDialog(
      context: _context,
      builder: (context) {
        return AlertDialog(
          title: Column(
              children: const [
                const Text("Identificar cliente na venda", textAlign: TextAlign.center),
                Divider(),
                Text(
                  "*Clique fora da borda branca para fechar",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          content: Container(
            //height: 500,
            width: MediaQuery.of(context).size.width * 0.5,
            color: Colors.grey[400],
            child: Expanded(
                child: Column(children: [
              cabecalhoBuscarCliente(
                  _pesquisaProdutoController, clientePdvProvider),
              listaClientesEncontrados(_pesquisaProdutoController.text, aPrazo)
            ])),
          ),
        );
      });
}

listaClientesEncontrados(String nomeCliente, bool aPrazo) {
  return Consumer<ClientePdvProvider>(
    builder: (context, valueProvider, child) {
      //clientesProvider.buscarClientes(nome: nomeCliente);
      return Expanded(
          child: (valueProvider.clientes.isEmpty)
              ? const Center(
                  child: Text(
                    "Adicione um ou mais pagamentos",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                )
              : listViewComOsClientes(valueProvider, aPrazo));
    },
  );
}

listViewComOsClientes(ClientePdvProvider clienteProvider, bool aPrazo) {
  List<Cliente> listaDeClientes = clienteProvider.clientes;
  if (aPrazo && listaDeClientes.first.id == 1) {
    listaDeClientes.removeAt(0);
  }
  return ListView.separated(
    separatorBuilder: (context, index) => Divider(height: 1),
    padding: const EdgeInsets.all(8),
    itemCount: listaDeClientes.length,
    itemBuilder: (context, index) {
      Cliente clienteAtual = listaDeClientes.elementAt(index);
      return Container(
        height: 60,
        color: (clienteAtual.id == clienteProvider.clienteDaVenda.id)
            ? Colors.amber[300]
            : corDaLinha(index),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 20),
            SizedBox(width: 20, child: Text('${index + 1}')),
            const SizedBox(width: 20),
            SizedBox(
              width: 500,
              child: ListTile(
                title: Text(clienteAtual.nome),
                subtitle: Text('CPF: ${clienteAtual.cpf}'),
                onTap: () {
                  clienteProvider.atualizaClienteAtual(clienteAtual);
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

Color? corDaLinha(int index) {
  if (index % 2 == 0) {
    return Colors.grey[300];
  } else {
    return Colors.blueGrey[200];
  }
}

cabecalhoBuscarCliente(TextEditingController _pesquisaProdutoController,
    ClientePdvProvider clientePdvProvider) {
  return Container(
      margin: const EdgeInsets.all(8),
      color: Colors.grey[200],
      child: Row(
        children: [
          SizedBox(width: 20),
          Expanded(
              child: fieldPesquisaDoCliente(
                  _pesquisaProdutoController, clientePdvProvider)),
        ],
      ));
}

fieldPesquisaDoCliente(TextEditingController _pesquisaProdutoController,
    ClientePdvProvider clientePdvProvider) {
  return TextFormField(
    controller: _pesquisaProdutoController,
    keyboardType: TextInputType.text,
    decoration: const InputDecoration(
      labelText: "Pesquise o nome do cliente",
      prefixIcon: Icon(Icons.search),
      border: InputBorder.none,
    ),
    onChanged: (text) {
      print("Texto >> $text");
      if (text.isNotEmpty) {
        clientePdvProvider.buscarClientes(
            nome: _pesquisaProdutoController.text);
      } else {
        clientePdvProvider.buscarClientes();
      }
    },
  );
}
