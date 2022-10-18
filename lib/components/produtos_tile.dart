// // VERSAO PAGINACAO FUNCIONAL
// // TELA MOSTRAR CLIENTES

// // ignore_for_file: prefer_const_constructors, avoid_print, use_key_in_widget_constructors

// import 'package:flutter/material.dart';
// import 'package:flutter_teste_msql1/components/procurarProduto.dart';
// import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
// import 'package:flutter_teste_msql1/controle/ProdutoCtrl.dart';
// import 'package:flutter_teste_msql1/dao/ProdutoDAO.dart';
// import 'package:flutter_teste_msql1/modelo/Produto.dart';
// import 'package:flutter_teste_msql1/provider/produtoProvider.dart';
// // import 'package:flutter_teste_msql1/views/view_inventario/novoInventario.dart';
// // import 'package:number_paginator/number_paginator.dart';
// import 'package:provider/provider.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// import 'package:syncfusion_flutter_core/theme.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// class ProdutoTile extends StatefulWidget {
//   // const ({ Key? key }) : super(key: key);
//   PrincipalCtrl principalCtrl;

//   ProdutoTile(this.principalCtrl);

//   @override
//   State<ProdutoTile> createState() => _ProdutoTileState(principalCtrl);
// }

// List<Produto> paginacaoProduto = [];
// List<Produto> _produtos = [];
// int linhasPorPagina = 8;

// class _ProdutoTileState extends State<ProdutoTile> {
//   // final NumberPaginatorController numberPaginatorController =
//   //     NumberPaginatorController();
//   PrincipalCtrl principalCtrl;
//   _ProdutoTileState(this.principalCtrl);

//   late ProdutoProvider produtoProvider;
//   TextEditingController _qtnd = TextEditingController();
//   int selectIndex = 0;
//   static const double dataPagerHeight = 70.0;

//   bool loadingIndicator = false;
//   double contPagina = 0;

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   produtoProvider = Provider.of<ProdutoProvider>(context, listen: false);
//   //   // _produtos = await pegarProdutos();
//   //   // _produtos = produtoProvider.buscarProdutos(_produtos);
//   //   // print("AQUIII" + _produtos.length.toString());
//   // }

//   void rebuildList() {
//     setState(() {});
//   }

//   Widget loadListView(BoxConstraints constraints) {
//     List<Widget> _getChildren() {
//       pegarProdutos();
//       final List<Widget> stackChildren = [];

//       if (_produtos.isNotEmpty) {
//         print(_produtos.length);
//         stackChildren.add(ListView.custom(
//             childrenDelegate: CustomSliverChildBuilderDelegate(indexBuilder)));
//       }

//       if (loadingIndicator) {
//         stackChildren.add(Container(
//           color: Colors.black12,
//           width: constraints.maxWidth,
//           height: constraints.maxHeight,
//           child: Align(
//             alignment: Alignment.center,
//             child: CircularProgressIndicator(
//               strokeWidth: 3,
//             ),
//           ),
//         ));
//       }
//       return stackChildren;
//     }

//     return Stack(
//       children: _getChildren(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     produtoProvider = Provider.of<ProdutoProvider>(context);
//     // print("AQUIII" + produtoProvider.buscarProdutos(_produtos).toString());
//     pegarProdutos();
//     contPagina = (_produtos.length / linhasPorPagina).ceilToDouble();
//     final avatar = CircleAvatar(child: Icon(Icons.shopping_cart));
//     return MaterialApp(
//       theme: ThemeData(
//         primarySwatch: Colors.lightBlue,
//       ),
//       home: SafeArea(
//         bottom: true,
//         top: false,
//         child: Scaffold(
//           extendBody: true,
//           floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//           floatingActionButton: Container(
//             margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
//             child: FloatingActionButton(
//               onPressed: () async {
//                 await principalCtrl.routeCadastrarProdutos(context);
//                 setState(() {});
//               },
//               child: const Icon(Icons.add),
//             ),
//           ),
//           appBar: AppBar(
//             title: Row(
//               children: [
//                 Container(
//                   margin: EdgeInsets.only(left: 110),
//                   alignment: Alignment.centerLeft,
//                   child: const Text(
//                     "Produtos",
//                     style: TextStyle(fontSize: 20),
//                     textAlign: TextAlign.right,
//                   ),
//                 ),
//                 Container(
//                   alignment: Alignment.centerRight,
//                   margin: EdgeInsets.only(left: 900),
//                   child: IconButton(
//                     onPressed: () {
//                       showSearch(
//                           context: context,
//                           delegate: ProcurarProduto(principalCtrl));
//                     },
//                     color: Colors.white,
//                     icon: const Icon(Icons.search),
//                     iconSize: 30,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           body: LayoutBuilder(builder: (context, constraint) {
//             return Column(
//               children: [
//                 Container(
//                   height: constraint.maxHeight - dataPagerHeight,
//                   child: loadListView(constraint),
//                 ),
//                 Container(
//                   height: dataPagerHeight,
//                   child: SfDataPagerTheme(
//                       data: SfDataPagerThemeData(
//                         itemBorderRadius: BorderRadius.circular(5),
//                       ),
//                       child: SfDataPager(
//                           pageCount: contPagina,
//                           onPageNavigationStart: (pageIndex) {
//                             setState(() {
//                               print("AQUI" + _produtos.length.toString());
//                               loadingIndicator = true;
//                               // indexBuilder(context, 0);
//                             });
//                           },
//                           onPageNavigationEnd: (pageIndex) {
//                             setState(() {
//                               loadingIndicator = false;
//                             });
//                           },
//                           delegate:
//                               CustomSliverChildBuilderDelegate(indexBuilder)
//                                 ..addListener(rebuildList))),
//                   // delegate: CustomSliverChildBuilderDelegate(indexBuilder)
//                   //   ..addListener(rebuildList))),
//                 )
//               ],
//             );
//           }),
//         ),
//       ),
//     );
//   }

//   Widget indexBuilder(BuildContext context, int index) {
//     final Produto produto = paginacaoProduto[index];
//     // print("CHEGOU AQUI");
//     return ListTile(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       leading: CircleAvatar(child: Icon(Icons.shopping_cart)),
//       title: LayoutBuilder(
//         builder: (context, constraint) {
//           return Container(
//               width: constraint.maxWidth,
//               height: 50,
//               child: Row(
//                 children: [
//                   Row(
//                     children: [
//                       Text("${produto.descricao} | "),
//                       Text("Preço: R\$${produto.valorVenda} | "),
//                       Text("Estoque: ${produto.quantidadeAtual}"),
//                     ],
//                   ),
//                   //   subtitle: Row(
//                   //   // ignore: prefer_const_literals_to_create_immutables
//                   //   children: [
//                   //     Text(" Código:${produto.cod} | "),
//                   //     Text(produto.unidade),
//                   //   ],
//                   // ),

//                   // // dense: true,
//                   // trailing: Container(
//                   //   width: 200,
//                   //   margin: const EdgeInsets.only(top: 10),
//                   //   padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
//                   //   child: Row(
//                   //     children: <Widget>[
//                   //       // (selectIndex == 0)
//                   //       Visibility(
//                   //         visible: (selectIndex == i),
//                   //         child: Container(
//                   //           width: 80,
//                   //           margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
//                   //           child: TextField(
//                   //             controller: _qtnd,
//                   //             decoration: InputDecoration(
//                   //               // helperText: 'Adicionar quantidade',
//                   //               icon:
//                   //                   Icon(Icons.add_shopping_cart_outlined),
//                   //               // border: OutlineInputBorder(),
//                   //             ),
//                   //             onEditingComplete: () async {
//                   //               produto.quantidadeAtual =
//                   //                   produto.quantidadeAtual +
//                   //                       double.parse(_qtnd.text);
//                   //               await ProdutoDAO().itemEntrada(
//                   //                   produto, produto.quantidadeAtual);
//                   //               _qtnd.clear();
//                   //               setState(() {});
//                   //             },
//                   //           ),
//                   //           // child: campoInserirQtd(
//                   //           //     produto, produto.quantidadeAtual),
//                   //         ),
//                   //       ),
//                   //       IconButton(
//                   //           onPressed: () async {
//                   //             await principalCtrl.routeEditarProdutos(
//                   //                 context, produto);

//                   //             setState(() {});
//                   //           },
//                   //           icon: const Icon(Icons.edit),
//                   //           color: Colors.orange,
//                   //           iconSize: 28),
//                   //       IconButton(
//                   //           onPressed: () {
//                   //             ProdutoProvider(principalCtrl)
//                   //                 .remover(produto.id);
//                   //             setState(() {});
//                   //           },
//                   //           icon: const Icon(Icons.delete),
//                   //           color: Colors.red,
//                   //           iconSize: 28),
//                   //     ],
//                   //   ),
//                   // ),
//                 ],
//               ));
//         },
//       ),
//     );
//   }

//   // Widget indexBuilder(BuildContext context, int index) {
//   //   final Produto data = paginacaoProduto[index];
//   //   print("AQUI");
//   //   return ListTile(
//   //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//   //     title: LayoutBuilder(
//   //       builder: (context, constraint) {
//   //         return Container(
//   //             width: constraint.maxWidth,
//   //             height: 100,
//   //             child: Row(
//   //               children: [
//   //                 Align(
//   //                   alignment: Alignment.centerRight,
//   //                   child: Container(
//   //                     clipBehavior: Clip.antiAlias,
//   //                     decoration: BoxDecoration(
//   //                         borderRadius: BorderRadius.circular(10)),
//   //                     // child: Image.asset(data.image, width: 100, height: 100),
//   //                   ),
//   //                 ),
//   //                 Container(
//   //                   padding: EdgeInsets.fromLTRB(20, 10, 5, 5),
//   //                   child: Column(
//   //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//   //                     children: [
//   //                       Container(
//   //                         width: constraint.maxWidth - 130,
//   //                         child: Text(data.cod,
//   //                             style: TextStyle(
//   //                                 fontWeight: FontWeight.w600,
//   //                                 color: Colors.black87,
//   //                                 fontSize: 15)),
//   //                       ),
//   //                       Container(
//   //                         width: constraint.maxWidth - 130,
//   //                         child: Text(data.descricao,
//   //                             style: TextStyle(
//   //                                 color: Colors.black87, fontSize: 10)),
//   //                       ),
//   //                       Container(
//   //                         width: constraint.maxWidth - 130,
//   //                         child: Row(
//   //                           children: [
//   //                             Container(
//   //                               color: Colors.green.shade900,
//   //                               padding: EdgeInsets.all(3),
//   //                               child: Row(
//   //                                 children: [
//   //                                   Text('${data.id}',
//   //                                       textAlign: TextAlign.end,
//   //                                       style: TextStyle(
//   //                                           color: Colors.white, fontSize: 13)),
//   //                                   SizedBox(width: 2),
//   //                                   Icon(
//   //                                     Icons.star,
//   //                                     color: Colors.white,
//   //                                     size: 15,
//   //                                   )
//   //                                 ],
//   //                               ),
//   //                             ),
//   //                             SizedBox(width: 5),
//   //                             Text('${data.quantidadeAtual}',
//   //                                 textAlign: TextAlign.end,
//   //                                 style: TextStyle(
//   //                                     color: Colors.black87, fontSize: 11))
//   //                           ],
//   //                         ),
//   //                       ),
//   //                       Container(
//   //                         width: constraint.maxWidth - 130,
//   //                         child: Row(
//   //                           children: [
//   //                             Container(
//   //                               child: Text('\$${data.unidade}',
//   //                                   style: TextStyle(
//   //                                       color: Colors.green.shade800,
//   //                                       fontSize: 13)),
//   //                             ),
//   //                             SizedBox(width: 8),
//   //                             Text('${data.cod}',
//   //                                 style: TextStyle(
//   //                                     color: Colors.black87, fontSize: 10))
//   //                           ],
//   //                         ),
//   //                       ),
//   //                     ],
//   //                   ),
//   //                 ),
//   //               ],
//   //             ));
//   //       },
//   //     ),
//   //   );
//   // }

//   Future<List<Produto>> pegarProdutos() async {
//     await ProdutoDAO().buscarTodos().then((value) {
//       _produtos.clear();
//       _produtos.addAll(value);
//     });
//     return _produtos;
//   }
// }

// class CustomSliverChildBuilderDelegate extends SliverChildBuilderDelegate
//     with DataPagerDelegate, ChangeNotifier {
//   CustomSliverChildBuilderDelegate(builder) : super(builder);

//   @override
//   int get childCount => paginacaoProduto.length;

//   @override
//   Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
//     int startRowIndex = newPageIndex * linhasPorPagina;
//     int endRowIndex = startRowIndex + linhasPorPagina;

//     if (endRowIndex > _produtos.length) {
//       endRowIndex = _produtos.length - 1;
//     }

//     await Future.delayed(Duration(milliseconds: 2000));
//     paginacaoProduto =
//         _produtos.getRange(startRowIndex, endRowIndex).toList(growable: false);
//     notifyListeners();
//     return true;
//   }

//   @override
//   bool shouldRebuild(covariant CustomSliverChildBuilderDelegate oldDelegate) {
//     return true;
//   }
// }

// FUTURE BUILDER VERSION
// VERSAO FUNCIONAL -- ADICIONAR(ENXUTA)
// TELA MOSTRAR CLIENTES

// ignore_for_file: prefer_const_constructors, avoid_print, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_teste_msql1/components/procurarProduto.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/controle/ProdutoCtrl.dart';
import 'package:flutter_teste_msql1/dao/ProdutoDAO.dart';
import 'package:flutter_teste_msql1/modelo/Produto.dart';
import 'package:flutter_teste_msql1/provider/produtoProvider.dart';
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
                          Text("Preço: R\$${produto.valorVenda} | "),
                          Text("Estoque: ${produto.quantidadeAtual}"),
                        ],
                      ),
                      subtitle: Row(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Text(" Código:${produto.cod} | "),
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
                            // (selectIndex == 0)
                            // Container(
                            //   width: 80,
                            //   margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            //   child: TextField(
                            //     controller: _qtnd,
                            //     decoration: InputDecoration(
                            //       // helperText: 'Adicionar quantidade',
                            //       icon:
                            //           Icon(Icons.add_shopping_cart_outlined),
                            //       // border: OutlineInputBorder(),
                            //     ),
                            //     onEditingComplete: () async {
                            //       produto.quantidadeAtual =
                            //           produto.quantidadeAtual +
                            //               double.parse(_qtnd.text);
                            //       await ProdutoDAO().itemEntrada(
                            //           produto, produto.quantidadeAtual);
                            //       _qtnd.clear();
                            //       setState(() {});
                            //     },
                            //   ),
                            //   // child: campoInserirQtd(
                            //   //     produto, produto.quantidadeAtual),
                            // ),
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







// // FUTURE BUILDER VERSION
// // VERSAO FUNCIONAL -- ADICIONAR(ENXUTA)
// // TELA MOSTRAR CLIENTES

// // ignore_for_file: prefer_const_constructors, avoid_print, use_key_in_widget_constructors

// import 'package:flutter/material.dart';
// import 'package:flutter_teste_msql1/components/procurarProduto.dart';
// import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
// import 'package:flutter_teste_msql1/controle/ProdutoCtrl.dart';
// import 'package:flutter_teste_msql1/dao/ProdutoDAO.dart';
// import 'package:flutter_teste_msql1/modelo/Produto.dart';
// import 'package:flutter_teste_msql1/provider/produtoProvider.dart';
// import 'package:number_paginator/number_paginator.dart';
// import 'package:provider/provider.dart';

// class ProdutoTile extends StatefulWidget {
//   // const ({ Key? key }) : super(key: key);
//   PrincipalCtrl principalCtrl;

//   ProdutoTile(this.principalCtrl);

//   @override
//   State<ProdutoTile> createState() => _ProdutoTileState(principalCtrl);
// }

// // List<Produto> selecionados = [];

// class _ProdutoTileState extends State<ProdutoTile> {
//   final NumberPaginatorController numberPaginatorController =
//       NumberPaginatorController();
//   TextEditingController _qtnd = TextEditingController();
//   int selectIndex = 0;
//   final int numeroPaginas = 10;
//   int paginaAtual = 0;
//   int inicio = 0;
//   int mat = 0;
//   int limitBusca = 8;

//   PrincipalCtrl principalCtrl;
//   _ProdutoTileState(this.principalCtrl);
//   @override
//   Widget build(BuildContext context) {
//     final avatar = CircleAvatar(child: Icon(Icons.shopping_cart));
//     return Scaffold(
//       extendBody: true,
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//       floatingActionButton: Container(
//         margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
//         child: FloatingActionButton(
//           onPressed: () async {
//             await principalCtrl.routeCadastrarProdutos(context);
//             setState(() {});
//           },
//           child: const Icon(Icons.add),
//         ),
//       ),
//       appBar: AppBar(
//         title: Row(
//           children: [
//             Container(
//               margin: EdgeInsets.only(left: 110),
//               alignment: Alignment.centerLeft,
//               child: const Text(
//                 "Produtos",
//                 style: TextStyle(fontSize: 20),
//                 textAlign: TextAlign.right,
//               ),
//             ),
//             Container(
//               alignment: Alignment.centerRight,
//               margin: EdgeInsets.only(left: 900),
//               child: IconButton(
//                 onPressed: () {
//                   showSearch(
//                       context: context,
//                       delegate: ProcurarProduto(principalCtrl));
//                 },
//                 color: Colors.white,
//                 icon: const Icon(Icons.search),
//                 iconSize: 30,
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: FutureBuilder(
//         future: ProdutoProvider(principalCtrl).loadProdutos(),
//         builder: (BuildContext context, AsyncSnapshot<List<Produto>> snapshot) {
//           if (!snapshot.hasData) {
//             return Center(
//               child: CircularProgressIndicator(
//                 color: Colors.yellow.shade400,
//               ),
//             );
//           }
//           return Container(
//             color: Colors.grey.shade300,
//             width: 1100,
//             margin: EdgeInsets.fromLTRB(80, 20, 0, 0),
//             padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
//             child: SizedBox(
//               // width: MediaQuery.of(context).size.width * 0.5,
//               width: double.infinity,
//               height: double.infinity,
//               child: ListView.builder(
//                 // itemCount: clientes.count,
//                 itemCount: snapshot.data!.length,
//                 itemBuilder: (context, i) {
//                   Produto produto = snapshot.data![i];
//                   // NumberPaginator(numberPages:);
//                   if (produto.status) {
//                     return ListTile(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(12)),
//                       ),
//                       leading: avatar,
//                       // selected: selecionados.contains(produto.selecionado),
//                       selected: i == selectIndex,
//                       selectedTileColor: Colors.indigo[50],
//                       title: InkWell(
//                         onTap: () {
//                           setState(() {
//                             selectIndex = i;
//                             produto.selecionado = !produto.selecionado;
//                           });
//                         },
//                         child: Row(
//                           children: [
//                             Text("${produto.descricao} | "),
//                             Text("Preço: R\$${produto.valorVenda} | "),
//                             Text("Estoque: ${produto.quantidadeAtual}"),
//                           ],
//                         ),
//                       ),
//                       subtitle: Row(
//                         // ignore: prefer_const_literals_to_create_immutables
//                         children: [
//                           Text(" Código:${produto.cod} | "),
//                           Text(produto.unidade),
//                         ],
//                       ),

//                       // dense: true,
//                       trailing: Container(
//                         width: 200,
//                         margin: const EdgeInsets.only(top: 10),
//                         padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
//                         child: Row(
//                           children: <Widget>[
//                             // (selectIndex == 0)
//                             Visibility(
//                               visible: (selectIndex == i),
//                               child: Container(
//                                 width: 80,
//                                 margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
//                                 child: TextField(
//                                   controller: _qtnd,
//                                   decoration: InputDecoration(
//                                     // helperText: 'Adicionar quantidade',
//                                     icon:
//                                         Icon(Icons.add_shopping_cart_outlined),
//                                     // border: OutlineInputBorder(),
//                                   ),
//                                   onEditingComplete: () async {
//                                     produto.quantidadeAtual =
//                                         produto.quantidadeAtual +
//                                             double.parse(_qtnd.text);
//                                     await ProdutoDAO().itemEntrada(
//                                         produto, produto.quantidadeAtual);
//                                     _qtnd.clear();
//                                     setState(() {});
//                                   },
//                                 ),
//                                 // child: campoInserirQtd(
//                                 //     produto, produto.quantidadeAtual),
//                               ),
//                             ),
//                             IconButton(
//                                 onPressed: () async {
//                                   await principalCtrl.routeEditarProdutos(
//                                       context, produto);

//                                   setState(() {});
//                                 },
//                                 icon: const Icon(Icons.edit),
//                                 color: Colors.orange,
//                                 iconSize: 28),
//                             IconButton(
//                                 onPressed: () {
//                                   ProdutoProvider(principalCtrl)
//                                       .remover(produto.id);
//                                   setState(() {});
//                                 },
//                                 icon: const Icon(Icons.delete),
//                                 color: Colors.red,
//                                 iconSize: 28),
//                           ],
//                         ),
//                       ),
//                     );
//                   } else {
//                     return Container();
//                   }
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//       bottomNavigationBar: Card(
//         child: NumberPaginator(
//           controller: numberPaginatorController,
//           config: NumberPaginatorUIConfig(
//             height: 50,
//             buttonSelectedForegroundColor: Colors.white,
//             buttonUnselectedForegroundColor: Colors.white,
//             buttonSelectedBackgroundColor: Colors.amber.shade300,
//           ),
//           numberPages: numeroPaginas,
//           onPageChange: (int index) {
//             setState(() {
//               mat = index - 1;
//               inicio = mat * numeroPaginas;
//               paginaAtual = index;
//             });
//           },
//         ),
//       ),
//     );
//   }
// }
