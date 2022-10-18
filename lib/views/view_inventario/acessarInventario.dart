// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_teste_msql1/controle/ItemInventarioCtrl.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/controle/UsuarioCtrl.dart';
import 'package:flutter_teste_msql1/modelo/Inventario.dart';
import 'package:flutter_teste_msql1/modelo/ItemInventario.dart';
import 'package:flutter_teste_msql1/modelo/Usuario.dart';
import 'package:flutter_teste_msql1/util/ConversorMoeda.dart';
import 'package:intl/intl.dart';

List<ItemInventario> itensInventariados = [];
Inventario inventarioModal = Inventario();
Usuario usuario = Usuario();

class AcessarInventario extends StatelessWidget {
  PrincipalCtrl principalCtrl;
  AcessarInventario(this.principalCtrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
                "Inventário: #${inventarioModal.id} | ${DateFormat("\'Dia: 'dd/MM/yyyy, 'às:' HH\'h':mm\'min'").format(inventarioModal.dataHora)}")),
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
  inventarioModal = ModalRoute.of(context)!.settings.arguments as Inventario;
  itensInventariados = await principalCtrl.itemInventarioCtrl
      .buscarListaItensInventariadosPorInventario(inventarioModal.id);
  // itemInventario = await ItemInventarioCtrl()
  //     .buscarListaItensInventariadosPorInventario(inventarioModal.id);

  // while (itemInventario.isNotEmpty) {
  //   print(itemInventario[i].produto.descricao);
  //   i++;
}

dataTable(BuildContext context, PrincipalCtrl principalCtrl) {
  return DataTable(columns: _Columns(), rows: _Rows(context, principalCtrl));
}

//TEM QUE FAZER O QUANTIDADE ANTERIOR
_Columns() {
  return <DataColumn>[
    DataColumn(
      label: Container(
        padding: const EdgeInsets.only(left: 50),
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
          "Quantidade Anterior",
          style: TextStyle(fontSize: 20),
        ),
      ),
    ),
    DataColumn(
      label: Expanded(
        child: Text(
          "Quantidade ",
          style: TextStyle(fontSize: 20),
        ),
      ),
    ),
    DataColumn(
      label: Expanded(
        child: Text(
          "Usuario",
          style: TextStyle(fontSize: 20),
        ),
      ),
    ),
  ];
}

_Rows(BuildContext context, PrincipalCtrl principalCtrl) {
  geraLista(context, principalCtrl);
  print("AQUIIIIII  ${itensInventariados.length}");
  return itensInventariados
      .map(
        (itemInventario) => DataRow(
          cells: <DataCell>[
            DataCell(
              Align(
                alignment: Alignment.center,
                child: Container(
                    margin: const EdgeInsets.only(right: 30),
                    child: Text(itemInventario.produto.cod)),
              ),
            ),
            DataCell(
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: Text(
                    itemInventario.produto.descricao,
                    // textAlign: TextAlign.,
                  ),
                ),
              ),
            ),
            DataCell(
              // Text(inventario.quantidade.toString()),
              Container(
                  margin: EdgeInsets.only(left: 90),
                  child: Text(ConversorMoeda.converterDoubleEmTexto(
                      itemInventario.produto.quantidadeInventario.toStringAsFixed(3))+' '+itemInventario.produto.unidade)),
              // itemInventario.produto.quantidadeInventario.toString()
              // Text("R\$ ${produto.valorCompra.toString()}"),
            ),
            DataCell(
              // Text(inventario.quantidade.toString()),
              Container(
                  margin: EdgeInsets.only(left: 40),
                  child: Text(ConversorMoeda.converterDoubleEmTexto(itemInventario.quantidade.toStringAsFixed(3)+' '+itemInventario.produto.unidade))),
              // Text("R\$ ${produto.valorCompra.toString()}"),
            ),
            DataCell(
              Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(principalCtrl.usuarioCtrl.usuarioLogado.nome)),
            ),
          ],
        ),
      )
      .toList();
}
