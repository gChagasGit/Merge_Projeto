// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_teste_msql1/controle/InventarioCtrl.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/dao/InventarioDAO.dart';
import 'package:flutter_teste_msql1/dao/ProdutoDAO.dart';
import 'package:flutter_teste_msql1/modelo/Inventario.dart';
import 'package:flutter_teste_msql1/modelo/Produto.dart';
import 'package:flutter_teste_msql1/modelo/Usuario.dart';
import 'package:flutter_teste_msql1/provider/produtoProvider.dart';

class TelaInventario extends StatefulWidget {
  // const MyWidget({super.key});
  PrincipalCtrl principalCtrl;
  InventarioCtrl inventarioCtrl;

  TelaInventario(this.principalCtrl, this.inventarioCtrl);

  @override
  State<TelaInventario> createState() => _TelaInventarioState();
}

class _TelaInventarioState extends State<TelaInventario> {
  TextEditingController quant = TextEditingController();
  Inventario inventario = Inventario();
  int selectIndex = 0;
  int id = 0;
  DateTime data = DateTime.now();
  Usuario usuario = Usuario();

  Widget quantidadeReal(double qtndReal) {
    return TextFormField(
        controller: quant,
        onEditingComplete: () {
          qtndReal = double.parse(quant.text);
        },
        decoration: InputDecoration(border: OutlineInputBorder()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Inventário"),
        ),
        body: FutureBuilder(
            future: ProdutoProvider(widget.principalCtrl).loadProdutos(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Produto>> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.yellow.shade400,
                  ),
                );
              }
              return Container(
                width: 1100,
                margin: EdgeInsets.fromLTRB(80, 20, 0, 0),
                padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: DataTable(
                      columns: <DataColumn>[
                        DataColumn(
                          label: Container(
                            padding: EdgeInsets.only(left: 80),
                            child: Text(
                              "Descrição",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              "Unidade",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              "Quant. Software",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              "Quant. Real",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              "Data alteração",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                      rows: snapshot.data!
                          .map(
                            (produto) => DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  InkWell(
                                      onTap: () {
                                        selectIndex = produto.id;
                                        quant.clear();
                                        setState(() {});
                                      },
                                      child: Text(produto.descricao)),
                                ),
                                DataCell(
                                  Container(
                                      padding: const EdgeInsets.only(left: 27),
                                      child: Text(produto.unidade)),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.only(left: 70),
                                    child: Text(
                                      produto.quantidadeAtual.toString(),
                                      // textAlign: TextAlign.,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                      width: 80,
                                      // margin: EdgeInsets.only(right: 30),
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Visibility(
                                        visible: (selectIndex == produto.id),
                                        child: TextField(
                                            controller: quant,
                                            onEditingComplete: () async {
                                              produto.quantidadeAtual =
                                                  double.parse(quant.text);
                                              await ProdutoDAO()
                                                  .alterar(produto);
                                              await inventario.dataHora;
                                              setState(() {});
                                            },
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder())),
                                      )),
                                ),
                                DataCell(
                                  Text(data.toString()),
                                  // Text("R\$ ${produto.valorCompra.toString()}"),
                                ),
                              ],
                            ),
                          )
                          .toList()),
                  // } else {
                  //   return Container();
                  // }
                  // ),
                ),
              );
            }));
  }
}







// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';

// class TelaInventario extends StatelessWidget {
//   // const MyWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Inventário"),
//       ),
//       body: Inventario(),
//     );
//   }
// }

// class Inventario extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return DataTable(columns: const <DataColumn>[
//       DataColumn(
//           label: Expanded(
//         child: Text(
//           "Nome",
//           style: TextStyle(fontSize: 20),
//         ),
//       ))
//     ], rows: const <DataRow>[
//       DataRow(cells: <DataCell>[
//         DataCell(
//           Text("Produto 1"),
//         ),
//       ])
//     ]);
//   }
// }
