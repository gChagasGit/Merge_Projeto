import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_teste_msql1/provider/clienteProvider.dart';
import 'package:flutter_teste_msql1/provider/produtoProvider.dart';
import 'package:provider/provider.dart';

import '../modelo/Cliente.dart';
import '../modelo/Produto.dart';
import '../provider/pdv/clientesPdvProvider.dart';

Future produtosEspecificacaoPDV(BuildContext context,
    ProdutoProvider produtosEspecificacaoPdvProvider, Text titulo) {
  final _pesquisaProdutoController = TextEditingController();
  _pesquisaProdutoController.text = "";
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: titulo,
          content: Container(
            //height: 500,
            width: MediaQuery.of(context).size.width * 0.5,
            color: Colors.grey[400],
            child: Expanded(
                child: Column(children: [
              cabecalhoBuscarProdutoEspecificacao(
                  _pesquisaProdutoController, produtosEspecificacaoPdvProvider),
              listaProdutoEspecificacaoEncontrados(
                  _pesquisaProdutoController.text)
            ])),
          ),
        );
      });
}

listaProdutoEspecificacaoEncontrados(String nomeProdutoEspecifico) {
  return Consumer<ProdutoProvider>(
    builder: (context, valueProvider, child) {
      //clientesProvider.buscarClientes(nome: nomeCliente);
      return Expanded(
          child: (valueProvider.produtos.isEmpty)
              ? const Center(
                  child: Text(
                    "Adicione um ou mais produto",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                )
              : listViewComAsFormasDePagamento(valueProvider));
    },
  );
}

listViewComAsFormasDePagamento(
    ProdutoProvider produtosEspecificacaoPdvProvider) {
  List<Produto> listaDeProdutos = produtosEspecificacaoPdvProvider.produtos;
  return ListView.separated(
    separatorBuilder: (context, index) => Divider(height: 1),
    padding: const EdgeInsets.all(8),
    itemCount: listaDeProdutos.length,
    itemBuilder: (context, index) {
      Produto produtoAtual = listaDeProdutos.elementAt(index);
      return Container(
        height: 60,
        color: (produtoAtual.id ==
                produtosEspecificacaoPdvProvider.produtoSelecionado.id)
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
                title: Text(produtoAtual.descricao),
                subtitle: Text('Código: ${produtoAtual.cod}'),
                onTap: () async {
                  await produtosEspecificacaoPdvProvider
                      .atualizaProdutoSelecionado(produtoAtual);
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

cabecalhoBuscarProdutoEspecificacao(
    TextEditingController _pesquisaProdutoController,
    ProdutoProvider produtosEspecificacaoPdvProvider) {
  return Container(
      margin: const EdgeInsets.all(8),
      color: Colors.grey[200],
      child: Row(
        children: [
          SizedBox(width: 20),
          Expanded(
              child: fieldPesquisaDoCliente(_pesquisaProdutoController,
                  produtosEspecificacaoPdvProvider)),
        ],
      ));
}

fieldPesquisaDoCliente(TextEditingController _pesquisaProdutoController,
    ProdutoProvider produtosEspecificacaoPdvProvider) {
  return TextFormField(
    controller: _pesquisaProdutoController,
    keyboardType: TextInputType.text,
    decoration: const InputDecoration(
      labelText: "Pesquise o produto",
      prefixIcon: Icon(Icons.search),
      border: InputBorder.none,
    ),
    onChanged: (text) {
      print("Texto >> $text");
      if (text.isNotEmpty) {
        produtosEspecificacaoPdvProvider.loadProdutos(
            descricao: _pesquisaProdutoController.text);
      } else {
        produtosEspecificacaoPdvProvider.loadProdutos();
      }
    },
  );
}
