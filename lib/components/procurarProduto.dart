import 'package:flutter/material.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/controle/ProdutoCtrl.dart';
import 'package:flutter_teste_msql1/dao/ProdutoDAO.dart';
import 'package:flutter_teste_msql1/modelo/Produto.dart';
import 'package:flutter_teste_msql1/provider/produtoProvider.dart';

class ProcurarProduto extends SearchDelegate {
  PrincipalCtrl principalCtrl;

  ProcurarProduto(this.principalCtrl) : super(searchFieldLabel: "Procurar");

  int selectIndex = 0;
  TextEditingController _qtnd = TextEditingController();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null); //ou Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: ProdutoProvider(principalCtrl).loadProdutos(descricao: query),
      builder: (BuildContext context, AsyncSnapshot<List<Produto>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.yellow.shade400,
            ),
          );
        }
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            color: Colors.grey.shade300,
            width: 1100,
            height: 550,
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
                  if (produto.status) {
                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      leading: CircleAvatar(child: Icon(Icons.shopping_cart)),
                      // selected: selecionados.contains(produto.selecionado),
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
        });
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text(""),
    );
  }
}

//---------------------------------------------------------------------//----------------------------

// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
// import 'package:flutter_teste_msql1/controle/ProdutoCtrl.dart';
// import 'package:flutter_teste_msql1/modelo/Produto.dart';
// import 'package:flutter_teste_msql1/provider/produtoProvider.dart';

// class ProcuraProduto extends StatefulWidget {
//   PrincipalCtrl principalCtrl;

//   ProcuraProduto(this.principalCtrl);

//   @override
//   State<ProcuraProduto> createState() => _ProcuraProdutoState(principalCtrl);
// }

// class _ProcuraProdutoState extends State<ProcuraProduto> {
//   PrincipalCtrl principalCtrl;
//   _ProcuraProdutoState(this.principalCtrl)

//   @override
//   Widget buildResults(BuildContext context) {
//     // PrincipalCtrl principalCtrl;
//     return Scaffold(
//       appBar: AppBar(),
//       body: FutureBuilder(
//       future: ProdutoProvider(principalCtrl).loadProdutos(descricao: query),
//       builder: (BuildContext context, AsyncSnapshot<List<Produto>> snapshot) {
//         if (!snapshot.hasData) {
//           return Center(
//             child: CircularProgressIndicator(
//               color: Colors.yellow.shade400,
//             ),
//           );
//         }
//         return Container(
//           margin: EdgeInsets.fromLTRB(80, 20, 0, 0),
//           padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
//           child: SizedBox(
//             // width: MediaQuery.of(context).size.width * 0.5,
//             width: double.infinity,
//             height: double.infinity,
//             child: ListView.builder(
//               // itemCount: clientes.count,
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, i) {
//                 final Produto produto = snapshot.data![i];
//                 if (produto.status) {
//                   return ListTile(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(12)),
//                     ),
//                     leading: CircleAvatar(),
//                     // selected: selecionados.contains(produto.selecionado),
//                     selected: i == selectIndex,
//                     selectedTileColor: Colors.indigo[50],
//                     title: InkWell(
//                       onTap: () {
//                         setState(() {
//                           selectIndex = i;
//                           produto.selecionado = !produto.selecionado;
//                           // snapshot.data![i].selecionado = true;
//                           // produto.selecionado = true;
//                           // snapshot.data![i].selecionado =
//                           //     !snapshot.data![i].selecionado;
//                           // if (snapshot.data![i].selecionado == true) {
//                           //   print(snapshot.data![i].descricao);
//                           //   // produto.selecionado = true;
//                           //   selecionados.add(snapshot.data![i]);
//                           // }
//                         });
//                       },
//                       child: Row(
//                         children: [
//                           Text(produto.descricao),
//                           Text(" Preço: R\$${produto.valorVenda}"),
//                           Text(" Estoque: ${produto.quantidadeAtual}"),
//                         ],
//                       ),
//                     ),
//                     subtitle: Row(
//                       // ignore: prefer_const_literals_to_create_immutables
//                       children: [
//                         Text(" Código:${produto.cod}"),
//                       ],
//                     ),

//                     // dense: true,
//                     trailing: Container(
//                       width: 200,
//                       margin: const EdgeInsets.only(top: 10),
//                       padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
//                       child: Row(
//                         children: <Widget>[
//                           Visibility(
//                             visible: (selectIndex == i),
//                             child: Container(
//                               width: 80,
//                               margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
//                               child: TextField(
//                                 controller: _qtnd,
//                                 decoration: InputDecoration(
//                                   // helperText: 'Adicionar quantidade',
//                                   icon: Icon(Icons.add_shopping_cart_outlined),
//                                   // border: OutlineInputBorder(),
//                                 ),
//                                 onEditingComplete: () async {
//                                   produto.quantidadeAtual =
//                                       produto.quantidadeAtual +
//                                           double.parse(_qtnd.text);
//                                   await ProdutoDAO().itemEntrada(
//                                       produto, produto.quantidadeAtual);
//                                   _qtnd.clear();
//                                   setState(() {});
//                                 },
//                               ),
//                               // child: campoInserirQtd(
//                               //     produto, produto.quantidadeAtual),
//                             ),
//                           ),
//                           IconButton(
//                               onPressed: () async {
//                                 await principalCtrl.routeEditarProdutos(
//                                     context, produto);

//                                 setState(() {});
//                               },
//                               icon: const Icon(Icons.edit),
//                               color: Colors.orange,
//                               iconSize: 28),
//                           IconButton(
//                               onPressed: () {
//                                 ProdutoProvider(principalCtrl)
//                                     .remover(produto.id);
//                                 setState(() {});
//                               },
//                               icon: const Icon(Icons.delete),
//                               color: Colors.red,
//                               iconSize: 28),
//                         ],
//                       ),
//                     ),
//                   );
//                 } else {
//                   return Container();
//                 }
//               },
//             ),
//           ),
//         );
//       },
//     ));
//     // )

//   }
// }

// class ProcurarProduto extends SearchDelegate {
//   PrincipalCtrl principalCtrl;

//   TextEditingController _qtnd = TextEditingController();
//   int selectIndex = 0;

//   ProcurarProduto(this.principalCtrl);

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//           onPressed: () {
//             query = '';
//           },
//           icon: const Icon(Icons.clear))
//     ];
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//         onPressed: () {
//           close(context, null); //ou Navigator.pop(context);
//         },
//         icon: const Icon(Icons.arrow_back));
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return Center(
//       child: Text(""),
//     );
//   }
// }

// VERSAO FUNCIONAL -- ADICIONAR(ENXUTA)
//TELA MOSTRAR CLIENTES

// ignore_for_file: prefer_const_constructors, avoid_print, use_key_in_widget_constructors

// import 'package:flutter/material.dart';
// import 'package:flutter_teste_msql1/components/procurarProduto.dart';
// import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
// import 'package:flutter_teste_msql1/controle/ProdutoCtrl.dart';
// import 'package:flutter_teste_msql1/dao/ProdutoDAO.dart';
// import 'package:flutter_teste_msql1/modelo/Produto.dart';
// import 'package:flutter_teste_msql1/provider/produtoProvider.dart';
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
//   TextEditingController _qtnd = TextEditingController();
//   int selectIndex = 0;
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
//       body: 
//     );
//   }
// }

// class ProcurarProduto extends SearchDelegate {
//   PrincipalCtrl principalCtrl;

//   ProcurarProduto(this.principalCtrl);

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//           onPressed: () {
//             query = '';
//           },
//           icon: const Icon(Icons.clear))
//     ];
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//         onPressed: () {
//           close(context, null); //ou Navigator.pop(context);
//         },
//         icon: const Icon(Icons.arrow_back));
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return Center(
//       child: Text(""),
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return FutureBuilder(
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
//                             // snapshot.data![i].selecionado = true;
//                             // produto.selecionado = true;
//                             // snapshot.data![i].selecionado =
//                             //     !snapshot.data![i].selecionado;
//                             // if (snapshot.data![i].selecionado == true) {
//                             //   print(snapshot.data![i].descricao);
//                             //   // produto.selecionado = true;
//                             //   selecionados.add(snapshot.data![i]);
//                             // }
//                           });
//                         },
//                         child: Row(
//                           children: [
//                             Text(produto.descricao),
//                             Text(" Preço: R\$${produto.valorVenda}"),
//                             Text(" Estoque: ${produto.quantidadeAtual}"),
//                           ],
//                         ),
//                       ),
//                       subtitle: Row(
//                         // ignore: prefer_const_literals_to_create_immutables
//                         children: [
//                           Text(" Código:${produto.cod}"),
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
//                                     // setState(() {});
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

//                                   // setState(() {});
//                                 },
//                                 icon: const Icon(Icons.edit),
//                                 color: Colors.orange,
//                                 iconSize: 28),
//                             IconButton(
//                                 onPressed: () {
//                                   ProdutoProvider(principalCtrl)
//                                       .remover(produto.id);
//                                   // setState(() {});
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
//       );
//   }
// }
