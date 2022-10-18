import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_teste_msql1/components/clientes_pdv.dart';
import 'package:flutter_teste_msql1/provider/clienteProvider.dart';
import 'package:flutter_teste_msql1/provider/pdv/clientesPdvProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../controle/PrincipalCtrl.dart';
import '../../modelo/ItemVenda.dart';
import '../../modelo/Venda.dart';
import '../../provider/pdv/itensVendidosProvider.dart';
import '../../provider/venda_relatorio/vendasProvider.dart';

class VendasClientesPage extends StatefulWidget {
  //VendasClientes({Key? key}) : super(key: key);

  PrincipalCtrl principalCtrl;

  VendasClientesPage(this.principalCtrl);

  @override
  State<VendasClientesPage> createState() =>
      _VendasClientesPageState(principalCtrl);
}

class _VendasClientesPageState extends State<VendasClientesPage> {
  PrincipalCtrl principalCtrl;

  _VendasClientesPageState(this.principalCtrl);

  final _dateRangePickerController = DateRangePickerController();

  late ClientePdvProvider clienteProvider;
  late VendasProvider vendasProvider;
  late ItensVendidosProvider itensVendidosProvider;

  bool _flagVariosClietes = false;

  @override
  Widget build(BuildContext context) {
    vendasProvider = Provider.of<VendasProvider>(context);
    itensVendidosProvider = Provider.of<ItensVendidosProvider>(context);
    clienteProvider = Provider.of<ClientePdvProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Vendas"),
        ),
        body:
            Consumer<VendasProvider>(builder: (_context, valueProvider, child) {
          List<Venda> listaDeVendas = valueProvider.listaVendas;
          return Container(
            color: Colors.white,
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                menuLateral(context),
                Expanded(
                  child: Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                      padding: EdgeInsets.all(10),
                      color: Colors.blueGrey[400],
                      child: vendas(listaDeVendas)),
                ),
                listaItensVendidos(),
              ],
            ),
          );
        }));
  }

  menuLateral(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width * 0.15,
        margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
        padding: EdgeInsets.all(10),
        color: Colors.blueGrey[400],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
                clienteProvider.clienteDaVenda.nome.isEmpty
                    ? ''
                    : 'Cliente: \n${clienteProvider.clienteDaVenda.nome}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            textoRangeDatas(),
            botaoTodosOsClientes(),
            botaoFlutuanteSelecionarCliente(),
            botaoFlutuanteSelecionarData(context),
            botaoLimparFiltros()
          ],
        ));
  }

  String textoParaUmaListaDeVendaVazia() {
    if (clienteProvider.clienteDaVenda.nome.isNotEmpty) {
      return "Cliente selecionado não possui vendas";
    } else if (_dateRangePickerController.selectedRange != null) {
      return "Sem vendas no periodo selecionado";
    }
    return "Selecione um cliente ao lado";
  }

  textoRangeDatas() {
    String start = "";
    String end = "";
    if (_dateRangePickerController.selectedRange != null) {
      start = _dateRangePickerController.selectedRange!.startDate
          .toString()
          .split(' ')
          .first;
      start =
          "${start.split('-')[2]}/${start.split('-')[1]}/${start.split('-')[0]}";
      end = _dateRangePickerController.selectedRange!.endDate!
          .toString()
          .split(' ')
          .first;
      end = "${end.split('-')[2]}/${end.split('-')[1]}/${end.split('-')[0]}";
    }
    return Column(
      children: [
        Text((start.isNotEmpty ? 'Entre: \n $start e $end' : ''),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ],
    );
  }

  botaoTodosOsClientes() {
    return SizedBox(
      width: 70,
      height: 70,
      child: FloatingActionButton(
        tooltip: "Todos os clientes",
          heroTag: "botaoTodosOsClientes",
          elevation: 10,
          child: const Icon(Icons.people_outline, size: 35),
          onPressed: () async {
            _flagVariosClietes = true;
            await vendasProvider.carregarListaDeVendas();
          }),
    );
  }

  botaoFlutuanteSelecionarCliente() {
    return SizedBox(
      width: 70,
      height: 70,
      child: FloatingActionButton(
        tooltip: "Selecionar cliente",
          heroTag: "botaoFlutuanteSelecionarCliente",
          elevation: 10,
          child: const Icon(Icons.person_add_alt_1_sharp, size: 30),
          onPressed: () async {
            _flagVariosClietes = false;
            await clienteProvider.buscarClientes();
            await clientes_PDV(context, clienteProvider, false);
            if (clienteProvider.clienteDaVenda.id > 0) {
              await itensVendidosProvider.limpar();
              vendasProvider.carregarListaDeVendas(
                  idCliente: clienteProvider.clienteDaVenda.id);
            }
          }),
    );
  }

  botaoFlutuanteSelecionarData(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 70,
      child: FloatingActionButton(
        tooltip: "Selecionar período",
          heroTag: "botaoFlutuanteSelecionarData",
          elevation: 10,
          child: const Icon(Icons.calendar_month_sharp, size: 35),
          onPressed: () async {
            if (clienteProvider.clienteDaVenda.nome.isEmpty) {
              _flagVariosClietes = true;
            }
            await showDialogoDatas(context);
            print(
                "Range selecionado: ${_dateRangePickerController.selectedRange}");
            if (_dateRangePickerController.selectedRange!.startDate != null &&
                _dateRangePickerController.selectedRange!.endDate != null) {
              await itensVendidosProvider.limpar();
              await vendasProvider.carregarListaDeVendas(
                  range: _dateRangePickerController.selectedRange);
            } else {
              await createAlertDialogDatasNaoSelecionadas(context);
            }
          }),
    );
  }

  createAlertDialogDatasNaoSelecionadas(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Voçê precisa selecionar duas datas!"),
          );
        });
  }

  botaoLimparFiltros() {
    return SizedBox(
      width: 70,
      height: 70,
      child: FloatingActionButton(
        tooltip: "Limpar",
          heroTag: "botaoLimparFiltros",
          elevation: 10,
          child: const Icon(Icons.cleaning_services_outlined, size: 35),
          onPressed: () {
            limpar();
          }),
    );
  }

  limpar() {
    _flagVariosClietes = false;
    _dateRangePickerController.selectedRange = null;
    vendasProvider.limpar();
    itensVendidosProvider.limpar();
    clienteProvider.limpar();
  }

  showDialogoDatas(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Selecione um intervalo entre datas"),
            content: Container(
              height: 400,
              width: MediaQuery.of(context).size.width * 0.6,
              //color: Colors.grey[300],
              child: Expanded(
                child: calendario(),
              ),
            ),
          );
        });
  }

  calendario() {
    return SfDateRangePicker(
        controller: _dateRangePickerController,
        minDate: DateTime(2022),
        maxDate: DateTime.now(),
        backgroundColor: Colors.grey[200],
        enableMultiView: true,
        view: DateRangePickerView.month,
        selectionMode: DateRangePickerSelectionMode.range,
        startRangeSelectionColor: Colors.blue[500],
        endRangeSelectionColor: Colors.blue[500],
        rangeSelectionColor: Colors.blue[300],
        selectionShape: DateRangePickerSelectionShape.rectangle,
        rangeTextStyle: const TextStyle(color: Colors.white, fontSize: 15),
        viewSpacing: 40,
        headerHeight: 50,
        initialSelectedRange: PickerDateRange(
            DateTime.now().subtract(Duration(days: 7)), DateTime.now()),
        headerStyle: DateRangePickerHeaderStyle(
            backgroundColor: Colors.blue[400],
            textStyle: TextStyle(fontSize: 20)));
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

  vendas(List<Venda> listaDeVendas) {
    if (listaDeVendas.isEmpty) {
      return Center(
        child: Text(
          textoParaUmaListaDeVendaVazia(),
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      );
    }
    return Column(
      children: <Widget>[
        cabecalhoListView(),
        Expanded(
          child: listView_Vendas(listaDeVendas),
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
          children: [
            SizedBox(width: 10),
            SizedBox(
                width: 30,
                child: Text('#',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            // SizedBox(width: 20),
            SizedBox(
                width: 160,
                child: Text('Data   |   Hora',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            // SizedBox(width: 20),
            SizedBox(
                width: 60,
                child: Text('Valor',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            // SizedBox(width: 20),
            SizedBox(
                width: 90,
                child: Text('Desconto',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            // SizedBox(width: 20),
            SizedBox(
                width: 90,
                child: Text('Usuário',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            viewColunaClienteCabecalho(),
          ],
        ));
  }

  viewColunaClienteCabecalho() {
    if (_flagVariosClietes) {
      return SizedBox(
          width: 100,
          child: Text('Cliente',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)));
    }
    return SizedBox();
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
                      width: 160,
                      child: Text(
                        '${DateFormat("dd/MM/yyyy  |  HH:mm").format(vendaAtual.data)}',
                        textAlign: TextAlign.center,
                      )),
                  // const SizedBox(width: 20),
                  SizedBox(
                      width: 60,
                      child: Text(
                        vendaAtual.valor.toStringAsFixed(2),
                        textAlign: TextAlign.center,
                      )),
                  // const SizedBox(width: 20),
                  SizedBox(
                      width: 80,
                      child: Text(
                        vendaAtual.desconto.toStringAsFixed(2),
                        textAlign: TextAlign.center,
                      )),
                  // const SizedBox(width: 20),
                  SizedBox(
                      width: 90,
                      child: Text(
                        vendaAtual.usuario.nome.split(' ').first,
                        textAlign: TextAlign.center,
                      )),
                  viewColunaClienteLinhas(
                      vendaAtual.cliente.nome.split(' ').first)
                ],
              )),
        );
      },
    );
  }

  viewColunaClienteLinhas(String nome) {
    if (_flagVariosClietes) {
      return SizedBox(
          width: 100,
          child: Text(
            nome,
            textAlign: TextAlign.center,
          ));
    }
    return SizedBox();
  }

  _createDataTable(List<ItemVenda> itensVendidos) {
    return DataTable(
        columnSpacing: 0,
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
              DataCell(Text(
                "${itemVenda.produto.cod}",
                textAlign: TextAlign.start,
              )),
              DataCell(
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text("${itemVenda.produto.descricao}"),
                ),
              ),
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
