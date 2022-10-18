import 'package:flutter/material.dart';
import 'package:flutter_teste_msql1/components/procurarProduto.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/controle/ProdutoCtrl.dart';
import 'package:flutter_teste_msql1/dao/ProdutoDAO.dart';
import 'package:flutter_teste_msql1/modelo/Produto.dart';
import 'package:flutter_teste_msql1/provider/produtoProvider.dart';
import 'package:flutter_teste_msql1/util/ConversorMoeda.dart';
import 'package:flutter_teste_msql1/views/view_inventario/novoInventario.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';

class ProdutoTile extends StatefulWidget {
  // const ({ Key? key }) : super(key: key);
  PrincipalCtrl principalCtrl;

  ProdutoTile(this.principalCtrl);

  @override
  State<ProdutoTile> createState() => _ProdutoTileState(principalCtrl);
}

// List<Produto> selecionados = [];

class _ProdutoTileState extends State<ProdutoTile> {
  final NumberPaginatorController numberPaginatorController =
      NumberPaginatorController();
  TextEditingController _qtnd = TextEditingController();
  // int selectIndex = 0;
  ProdutoProvider? produtoProvider;

  PrincipalCtrl principalCtrl;
  _ProdutoTileState(this.principalCtrl) {
    produtoProvider = ProdutoProvider(principalCtrl);
  }
  @override
  Widget build(BuildContext context) {
    // produtoProvider = Provider.of<ProdutoProvider>(context);
    produtoProvider!.contaQuantidadeDeProdutos();
    final avatar = CircleAvatar(child: Icon(Icons.shopping_cart));
    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: FloatingActionButton(
          onPressed: () async {
            await principalCtrl.routeCadastrarProdutos(context);
            setState(() {});
          },
          child: const Icon(Icons.add),
        ),
      ),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 110),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Produtos",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.right,
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(left: 900),
              child: IconButton(
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: ProcurarProduto(principalCtrl));
                },
                color: Colors.white,
                icon: const Icon(Icons.search),
                iconSize: 30,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        // future: ProdutoProvider(principalCtrl).loadProdutos(),
        future: produtoProvider!.BuscarListaProdutos(),
        builder: (BuildContext context, AsyncSnapshot<List<Produto>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.yellow.shade400,
              ),
            );
          }
          return Container(
            color: Colors.grey.shade300,
            width: 1100,
            margin: EdgeInsets.fromLTRB(80, 20, 0, 0),
            padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
            child: SizedBox(
              // width: MediaQuery.of(context).size.width * 0.5,
              width: double.infinity,
              height: double.infinity,
              child: ListView.builder(
                // itemCount: clientes.count,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, i) {
                  Produto produto = snapshot.data![i];
                  // NumberPaginator(numberPages:);
                  if (produto.status) {
                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      leading: avatar,
                      // selected: selecionados.contains(produto.selecionado),
                      // selected: i == selectIndex,
                      selectedTileColor: Colors.indigo[50],
                      title: Row(
                        children: [
                          Text("${produto.descricao} | "),
                          Text("Preço: R\$${ConversorMoeda.converterDoubleEmTexto(produto.valorVenda.toStringAsFixed(2))} | "),
                          Text("Estoque: ${ConversorMoeda.converterDoubleEmTexto(produto.quantidadeAtual.toStringAsFixed(3))}"),
                        ],
                      ),
                      subtitle: Row(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Text(" Código: ${produto.cod} | "),
                          Text(produto.unidade),
                        ],
                      ),

                      // dense: true,
                      trailing: Container(
                        width: 200,
                        margin: const EdgeInsets.only(top: 10),
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Row(
                          children: <Widget>[
                            IconButton(
                                onPressed: () async {
                                  await principalCtrl.routeEditarProdutos(
                                      context, produto);

                                  setState(() {});
                                },
                                icon: const Icon(Icons.edit),
                                color: Colors.orange,
                                iconSize: 28),
                            IconButton(
                                onPressed: () {
                                  ProdutoProvider(principalCtrl)
                                      .remover(produto.id);
                                  setState(() {});
                                },
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                iconSize: 28),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Card(
        margin: EdgeInsets.fromLTRB(80, 0, 100, 0),
        // color: Colors.,
        child: NumberPaginator(
          controller: numberPaginatorController,
          config: NumberPaginatorUIConfig(
            height: 50,
            buttonSelectedForegroundColor: Colors.lightBlue,
            buttonUnselectedForegroundColor: Colors.lightBlue,
            buttonSelectedBackgroundColor: Colors.amber.shade300,
          ),
          // numberPages:
          // (produtosProvider == null) ? produtosProvider.numPages : 10,
          numberPages: 2,
          onPageChange: (int index) {
            produtoProvider!.currentPage = index;
            // produtoProvider!.BuscarListaProdutos();
            setState(() {});
          },
        ),
      ),
    );
  }
}





