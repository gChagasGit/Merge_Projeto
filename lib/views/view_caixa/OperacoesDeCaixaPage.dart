import 'package:flutter/material.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/modelo/Caixa.dart';
import 'package:flutter_teste_msql1/modelo/OpValoresCaixa.dart';
import 'package:flutter_teste_msql1/provider/caixa/caixaProvider.dart';
import 'package:intl/intl.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../util/ConversorMoeda.dart';

class OperacoesCaixaPage extends StatefulWidget {
  //OperacoesCaixaPage({Key? key}) : super(key: key);

  late PrincipalCtrl principalCtrl;

  OperacoesCaixaPage(this.principalCtrl);

  @override
  State<OperacoesCaixaPage> createState() =>
      _OperacoesCaixaPageState(principalCtrl);
}

class _OperacoesCaixaPageState extends State<OperacoesCaixaPage> {
  late PrincipalCtrl principalCtrl;

  late CaixaProvider caixaProvider;

  final _dateRangePickerController = DateRangePickerController();

  _OperacoesCaixaPageState(this.principalCtrl);

  @override
  Widget build(BuildContext context) {
    caixaProvider = Provider.of<CaixaProvider>(context);

    NumberPaginatorController _controllerPaginator =
        NumberPaginatorController();

    caixaProvider.contaQuantidadeDeRegistrosCaixa(
        range: _dateRangePickerController.selectedRange);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            caixaProvider.limpar();
            principalCtrl.routeHomePage(context);
          },
        ),
        title: const Text(
          'Operações do Caixa',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            menuLateral(context),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                color: Colors.blueGrey[400],
                child: listViewCaixasPagamentos(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Card(
        margin: EdgeInsets.fromLTRB(250, 0, 40, 5),
        elevation: 4,
        child: NumberPaginator(
          controller: _controllerPaginator,
          config: NumberPaginatorUIConfig(
            height: 50,
            buttonSelectedForegroundColor: Colors.white,
            buttonUnselectedForegroundColor: Colors.white,
            buttonSelectedBackgroundColor: Colors.amber.shade300,
          ),
          numberPages: caixaProvider.numPages,
          onPageChange: (int index) {
            setState(() {
              caixaProvider.currentPage = index;
              if (caixaProvider.listaDeCaixas.isNotEmpty) {
                caixaProvider.buscarListaCaixas();
              }
            });
          },
        ),
      ),
    );
  }

  botaoTodosOsCaixas() {
    return SizedBox(
      width: 70,
      height: 70,
      child: FloatingActionButton(
          tooltip: "Todos os caixas",
          heroTag: "botaoTodosOsCaixas",
          elevation: 10,
          child: const Icon(Icons.list_alt_outlined, size: 35),
          onPressed: () async {
            _dateRangePickerController.selectedRanges = null;
            setState(() {
              caixaProvider.buscarListaCaixas();
            });
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
          await showDialogoDatas(context);
          if (_dateRangePickerController.selectedRange!.startDate != null &&
              _dateRangePickerController.selectedRange!.endDate != null) {
            caixaProvider.limpar();
            caixaProvider.contaQuantidadeDeRegistrosCaixa(
                range: _dateRangePickerController.selectedRange);
            await caixaProvider.buscarListaCaixas(
                range: _dateRangePickerController.selectedRange);
          } else {
            await createAlertDialogDatasNaoSelecionadas(context);
          }
        },
      ),
    );
  }

  botaoLimpar() {
    return SizedBox(
      width: 70,
      height: 70,
      child: FloatingActionButton(
          tooltip: "Limpar",
          heroTag: "botaoLimpar",
          elevation: 10,
          child: const Icon(Icons.cleaning_services_outlined, size: 35),
          onPressed: () async {
            caixaProvider.limpar();
          }),
    );
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
            botaoTodosOsCaixas(),
            botaoFlutuanteSelecionarData(context),
            botaoLimpar()
          ],
        ));
  }

  // --------------------------------------- DATA

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

  createAlertDialogDatasNaoSelecionadas(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Voçê precisa selecionar duas datas!"),
          );
        });
  }

  // ---------------------------------------------

  listViewCaixasPagamentos() {
    return Consumer<CaixaProvider>(
      builder: (context, _caixaProvider, child) {
        _caixaProvider.listaDeCaixas.forEach((element) {});
        caixaProvider = _caixaProvider;
        if (_caixaProvider.listaDeCaixas.isEmpty) {
          return Center(
              child: Text(
            "Busque pelo caixa",
            style: TextStyle(fontSize: 22),
          ));
        }
        if (_caixaProvider.listaDeCaixas.last.operacoes.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.yellow.shade400,
            ),
          );
        }
        return ListView.separated(
          separatorBuilder: (context, index) => Divider(height: 2),
          itemCount: _caixaProvider.listaDeCaixas.length,
          itemBuilder: (context, index) {
            Caixa caixaAtual = _caixaProvider.listaDeCaixas.elementAt(index);
            return Container(
              color: Colors.blueGrey[200],
              child: ExpansionTile(
                textColor: Colors.black,
                title: columnInicialCaixa(caixaAtual),
                iconColor: Colors.black,
                collapsedIconColor: Colors.black,
                children: [rowDasOperacoes(caixaAtual.operacoes)],
                // onExpansionChanged: (isExpanded) =>
                //     caixaProvider.buscarListaOperacoes(caixaAtual.id),
              ),
            );
          },
        );
      },
    );
  }

  columnInicialCaixa(Caixa caixaAtual) {
    double subTotalEntradaCaixa = caixaAtual.valorTotalDinheiro +
        caixaAtual.valorTotalDebito +
        caixaAtual.valorTotalCredito +
        caixaAtual.valorTotalPix +
        caixaAtual.valorTotalPrazo;
    return Column(
      children: [
        _rowInicialCaixa(caixaAtual),
        Row(
          children: [
            SizedBox(
              width: 150,
              child: Text(
                'Dinheiro R\$ ${ConversorMoeda.converterDoubleEmTexto(caixaAtual.valorTotalDinheiro.toStringAsFixed(2))}',
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              width: 150,
              child: Text(
                'Débito R\$ ${ConversorMoeda.converterDoubleEmTexto(caixaAtual.valorTotalDebito.toStringAsFixed(2))}',
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              width: 150,
              child: Text(
                'Crédito R\$ ${ConversorMoeda.converterDoubleEmTexto(caixaAtual.valorTotalCredito.toStringAsFixed(2))}',
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              width: 150,
              child: Text(
                'PIX R\$ ${ConversorMoeda.converterDoubleEmTexto(caixaAtual.valorTotalPix.toStringAsFixed(2))}',
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              width: 150,
              child: Text(
                'Prazo R\$ ${ConversorMoeda.converterDoubleEmTexto(caixaAtual.valorTotalPrazo.toStringAsFixed(2))}',
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              width: 150,
              child: Text(
                'Total R\$ ${ConversorMoeda.converterDoubleEmTexto(subTotalEntradaCaixa.toStringAsFixed(2))}',
                textAlign: TextAlign.start,
              ),
            ),
          ],
        )
      ],
    );
  }

  _rowInicialCaixa(Caixa caixaAtual) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          height: 30,
          child: Text(
            'CAIXA #${caixaAtual.id}',
            textAlign: TextAlign.start,
          ),
        ),
        _aberturaDoCaixa(caixaAtual),
        _fechamentoDoCaixa(caixaAtual),
      ],
    );
  }

  _aberturaDoCaixa(Caixa caixaAtual) {
    if (caixaAtual.operacoes.length > 1) {
      return SizedBox(
        width: 120,
        child: Text(
          caixaAtual.operacoes.last.tipo,
          textAlign: TextAlign.center,
        ),
      );
    }
    return Container();
  }

  _fechamentoDoCaixa(Caixa caixaAtual) {
    if (caixaAtual.operacoes.length == 1) {
      return Text('Caixa não foi fechado');
    }
    if (caixaAtual.operacoes.isNotEmpty) {
      return Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              DateFormat("dd/MM/yyyy | hh:mm")
                  .format(caixaAtual.operacoes.last.horario),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 80,
            child: Text('R\$ '+ConversorMoeda.converterDoubleEmTexto(
              caixaAtual.operacoes.last.valor.toStringAsFixed(2)),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 20,
            child: Text('|',textAlign: TextAlign.center,),
          ),
          SizedBox(
            width: 120,
            child: Text(
              caixaAtual.operacoes.first.tipo,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              DateFormat("dd/MM/yyyy | hh:mm")
                  .format(caixaAtual.operacoes.first.horario),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 80,
            child: Text('R\$ '+ConversorMoeda.converterDoubleEmTexto(
              caixaAtual.operacoes.first.valor.toStringAsFixed(2)),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 120,
            child: Text('Usuário: '+
              caixaAtual.operacoes.first.usuario.nome,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }
    return Container();
  }

  rowDasOperacoes(List<OpValoresCaixa> operacoes) {
    if (operacoes.isEmpty || (operacoes.length - 2) == 0) {
      return Container(
          height: 50,
          alignment: Alignment.center,
          child: Text(
            "Nenhuma operação de sangria ou aporte",
            style: TextStyle(fontSize: 16),
          ));
    }
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(
              height: 1,
            ),
        shrinkWrap: true,
        itemCount: operacoes.length - 1,
        itemBuilder: (context, index) {
          if (index != 0) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  //height: 30,
                  child: Text(
                    operacoes[index].tipo,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Text(
                    DateFormat("dd/MM/yyyy | hh:mm")
                        .format(operacoes[index].horario),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    operacoes[index].valor.toStringAsFixed(2),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Text(
                    operacoes[index].usuario.nome,
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          }
          return Container();
        });
  }
}