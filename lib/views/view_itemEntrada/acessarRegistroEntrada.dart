// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_teste_msql1/controle/ItemInventarioCtrl.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/controle/UsuarioCtrl.dart';
import 'package:flutter_teste_msql1/modelo/Inventario.dart';
import 'package:flutter_teste_msql1/modelo/ItemEntrada.dart';
import 'package:flutter_teste_msql1/modelo/ItemInventario.dart';
import 'package:flutter_teste_msql1/modelo/RegistroEntrada.dart';
import 'package:flutter_teste_msql1/modelo/Usuario.dart';
import 'package:flutter_teste_msql1/views/view_itemEntrada/novoItemEntrada.dart';
import 'package:intl/intl.dart';

List<ItemEntrada> itemEntrada = [];
RegistroEntrada registroEntradaModal = RegistroEntrada();
Usuario usuario = Usuario();

class AcessarRegistroEntrada extends StatelessWidget {
  PrincipalCtrl principalCtrl;
  AcessarRegistroEntrada(this.principalCtrl);

  @override
  Widget build(BuildContext context) {
    geraLista(context, principalCtrl);
    return Scaffold(
        appBar: AppBar(
            // title: Text(inventarioModal.id.toString()),
            title: Text(
                "Registro de Entrada: ${registroEntradaModal.id.toString()} ID.Usuário: ${registroEntradaModal.usuario.id.toString()}  Data: ${DateFormat("HH:mm dd/MM/yyyy").format(registroEntradaModal.dataHora)}")),
        // body: Text(inventarioModal.listaItensInventario!.first.produto.cod),
        body: Container(
          width: 1100,
          margin: EdgeInsets.fromLTRB(80, 20, 0, 0),
          padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: dataTable(context, principalCtrl),
          ),
        ));
  }
}

geraLista(BuildContext context, PrincipalCtrl principalCtrl) async {
  registroEntradaModal =
      ModalRoute.of(context)!.settings.arguments as RegistroEntrada;
  print("ID" + registroEntradaModal.id.toString());
  itemEntrada = await principalCtrl.itemEntradaCtrl
      .buscarListaItensEntradaPorRegistroEntrada(registroEntradaModal.id);
  // itemInventario = await ItemInventarioCtrl()
  //     .buscarListaItensInventariadosPorInventario(inventarioModal.id);

  // while (itemInventario.isNotEmpty) {
  //   print(itemInventario[i].produto.descricao);
  //   i++;
}

dataTable(BuildContext context, PrincipalCtrl principalCtrl) {
  return DataTable(columns: _Columns(), rows: _Rows(context, principalCtrl));
}

_Columns() {
  return <DataColumn>[
    DataColumn(
      label: Container(
        padding: const EdgeInsets.only(left: 0),
        child: const Text(
          "Código",
          style: TextStyle(fontSize: 20),
        ),
      ),
    ),
    DataColumn(
      label: Container(
        padding: EdgeInsets.only(left: 60),
        child: Text(
          "Descrição",
          style: TextStyle(fontSize: 20),
        ),
      ),
    ),
    DataColumn(
      label: Expanded(
        child: Text(
          "Custo UN",
          style: TextStyle(fontSize: 20),
        ),
      ),
    ),
    DataColumn(
      label: Expanded(
        child: Text(
          "Quant. Entrada",
          style: TextStyle(fontSize: 20),
        ),
      ),
    ),
    DataColumn(
      label: Expanded(
        child: Text(
          "Quant. Estoque",
          style: TextStyle(fontSize: 20),
        ),
      ),
    ),
  ];
}

_Rows(BuildContext context, PrincipalCtrl principalCtrl) {
  // geraLista(context, principalCtrl);
  // print("AQUIIIIII" + itemInventario[0].id.toString());
  return itemEntrada
      .map(
        (itemEntrada) => DataRow(
          cells: <DataCell>[
            DataCell(
              Align(
                alignment: Alignment.center,
                child: Container(
                    margin: const EdgeInsets.only(right: 30),
                    child: Text(itemEntrada.produto.cod)),
              ),
            ),
            DataCell(
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: Text(
                    itemEntrada.produto.descricao,
                    // textAlign: TextAlign.,
                  ),
                ),
              ),
            ),
            DataCell(
              // Text(inventario.quantidade.toString()),
              Container(
                  margin: EdgeInsets.only(left: 40),
                  child: Text(itemEntrada.produto.valorCompra.toString())),
              // itemInventario.produto.quantidadeInventario.toString()
              // Text("R\$ ${produto.valorCompra.toString()}"),
            ),
            DataCell(
              // Text(inventario.quantidade.toString()),
              Container(
                  margin: EdgeInsets.only(left: 60),
                  child: Text(itemEntrada.quantidade.toString())),
              // itemInventario.produto.quantidadeInventario.toString()
              // Text("R\$ ${produto.valorCompra.toString()}"),
            ),
            DataCell(
              // Text(inventario.quantidade.toString()),
              Container(
                  margin: EdgeInsets.only(left: 60),
                  child: Text(itemEntrada.produto.quantidadeAtual.toString())),
              // Text("R\$ ${produto.valorCompra.toString()}"),
            ),
            // DataCell(
            //   Container(
            //       margin: EdgeInsets.only(left: 10),
            //       child: Text(principalCtrl.usuarioCtrl.usuarioLogado.nome)),
            // ),
          ],
        ),
      )
      .toList();
}
