import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/controle/VendaCtrl.dart';
import 'package:flutter_teste_msql1/modelo/ItemVenda.dart';
import 'package:flutter_teste_msql1/modelo/Venda.dart';
import 'package:flutter_teste_msql1/provider/venda_relatorio/vendasProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../provider/pdv/itensVendidosProvider.dart';

class VendasPage extends StatefulWidget {
  //VendasPage({Key? key}) : super(key: key);

  PrincipalCtrl principalCtrl;

  VendasPage(this.principalCtrl);

  @override
  State<VendasPage> createState() => _VendasPageState(principalCtrl);
}

class _VendasPageState extends State<VendasPage> {
  PrincipalCtrl principalCtrl;

  _VendasPageState(this.principalCtrl);

  //late VendasProvider vendasProvider;
  late ItensVendidosProvider itensVendidosProvider;

  @override
  Widget build(BuildContext context) {
    //vendasProvider = Provider.of<VendasProvider>(context);
    itensVendidosProvider = Provider.of<ItensVendidosProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Vendas"),
        ),
        body: FutureBuilder(
            future: VendasProvider(principalCtrl).carregarListaDeVendas(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Venda>> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.yellow.shade400,
                  ),
                );
              }
              return Container(
                color: Colors.white,
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          color: Colors.blueGrey[400],
                          child: vendas(snapshot.data!)),
                    ),
                    listaItensVendidos(),
                  ],
                ),
              );
            }));
  }

  listaItensVendidos() {
    return Consumer<ItensVendidosProvider>(
      builder: (context, value, child) {
        return Flexible(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            color: Colors.blueGrey[400],
            child: (value.itensVendidos.isEmpty)
                ? const Center(
                    child: Text(
                      "Ao lado selecione uma venda!",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  )
                : _createDataTable(value.itensVendidos),
          ),
        );
      },
    );
  }

  vendas(List<Venda> listaVendas) {
    return Column(
      children: <Widget>[
        cabecalhoListView(),
        Expanded(
          child: listView_Vendas(listaVendas),
        ),
      ],
    );
  }

  cabecalhoListView() {
    return Container(
        height: 60,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            SizedBox(width: 10),
            SizedBox(
                width: 30,
                child: Text('#',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            // SizedBox(width: 20),
            SizedBox(
                width: 200,
                child: Text('Data | Hora',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            // SizedBox(width: 20),
            SizedBox(
                width: 40,
                child: Text('Valor',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            // SizedBox(width: 20),
            SizedBox(
                width: 100,
                child: Text('Desconto',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            // SizedBox(width: 20),
            SizedBox(
                width: 100,
                child: Text('Cliente',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            // SizedBox(width: 20),
            SizedBox(
                width: 100,
                child: Text('Usuário',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          ],
        ));
  }

  listView_Vendas(List<Venda> listaVendas) {
    print("itemCount: listaVendas.length -->> ${listaVendas.length}");
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(height: 1),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: listaVendas.length,
      itemBuilder: (context, index) {
        Venda vendaAtual = listaVendas.elementAt(index);
        return GestureDetector(
          onTap: (() async {
            await itensVendidosProvider
                .buscarListaDeItensVendidosPorVenda(vendaAtual.id);
          }),
          child: Container(
              color: (itensVendidosProvider.idVendaSelecionada == vendaAtual.id)
                  ? Colors.amber[400]
                  : Colors.blueGrey[200],
              height: 45,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 10),
                  SizedBox(
                      width: 30,
                      child: Text(
                        '${(index + 1)}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.end,
                      )),
                  // const SizedBox(width: 20),
                  SizedBox(
                      width: 200,
                      child: Text(
                        '${DateFormat("dd/MM/yyyy   |   HH:mm").format(vendaAtual.data)}',
                        textAlign: TextAlign.center,
                      )),
                  // const SizedBox(width: 20),
                  SizedBox(
                      width: 40,
                      child: Text(
                        vendaAtual.valor.toStringAsFixed(2),
                        textAlign: TextAlign.center,
                      )),
                  // const SizedBox(width: 20),
                  SizedBox(
                      width: 100,
                      child: Text(
                        vendaAtual.desconto.toStringAsFixed(2),
                        textAlign: TextAlign.center,
                      )),
                  // const SizedBox(width: 20),
                  SizedBox(
                      width: 100,
                      child: Text(
                        vendaAtual.cliente.nome,
                        textAlign: TextAlign.center,
                      )),
                  // const SizedBox(width: 20),
                  SizedBox(
                      width: 100,
                      child: Text(
                        vendaAtual.usuario.nome,
                        textAlign: TextAlign.center,
                      )),
                ],
              )),
        );
      },
    );
  }

  _createDataTable(List<ItemVenda> itensVendidos) {
    return DataTable(
        columns: _columns(),
        rows: _rows(itensVendidos),
        dataRowColor: MaterialStateColor.resolveWith(
            (states) => Colors.blueGrey.shade200));
  }

  _columns() {
    return <DataColumn>[
      DataColumn(
        label: Text(
          "Código",
          style: TextStyle(fontSize: 16),
        ),
      ),
      DataColumn(
        label: Container(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            "Produto",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
      DataColumn(
        label: Container(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            "Quant.",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
      DataColumn(
        label: Container(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            "Valor",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
      DataColumn(
        label: Container(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            "Total",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    ];
  }

  _rows(List<ItemVenda> itens) {
    return itens
        .map((itemVenda) => DataRow(cells: <DataCell>[
              DataCell(Text("${itemVenda.produto.cod}")),
              DataCell(Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text("${itemVenda.produto.descricao}"),
              )),
              DataCell(Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(itemVenda.quantidadeVendida.toStringAsFixed(3)),
              )),
              DataCell(Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(itemVenda.valorVendido.toStringAsFixed(2)),
              )),
              DataCell(Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                    (itemVenda.quantidadeVendida * itemVenda.valorVendido)
                        .toStringAsFixed(2)),
              )),
            ]))
        .toList();
  }
}
