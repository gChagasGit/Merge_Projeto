import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_teste_msql1/modelo/PagamentoModificado.dart';
import 'package:flutter_teste_msql1/provider/pagamento_a_prazo/pagamentoProvider.dart';
import 'package:flutter_teste_msql1/provider/pdv/clientesPdvProvider.dart';
import 'package:flutter_teste_msql1/util/ConversorMoeda.dart';
import 'package:flutter_teste_msql1/util/PDF/modelo_pdf/invoice.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controle/PrincipalCtrl.dart';
import '../../modelo/Cliente.dart';
import '../../util/PDF/modelo_pdf/client.dart';

class PagamentosPrazoPage extends StatefulWidget {
  //VendasClientes({Key? key}) : super(key: key);

  PrincipalCtrl principalCtrl;

  PagamentosPrazoPage(this.principalCtrl);

  @override
  State<PagamentosPrazoPage> createState() =>
      _PagamentosPrazoPageState(principalCtrl);
}

class _PagamentosPrazoPageState extends State<PagamentosPrazoPage> {
  PrincipalCtrl principalCtrl;

  _PagamentosPrazoPageState(this.principalCtrl);

  late PagamentoProvider _pagamentoProvider;

  final _valorTotalController = TextEditingController();
  final _valorInseridoController = TextEditingController();
  final _valorTrocoController = TextEditingController();
  final __novoValorDaContaController = TextEditingController();

  final _valorDinheiroController = TextEditingController();
  final _valorDebitoController = TextEditingController();
  final _valorCreditoController = TextEditingController();
  final _valorPixController = TextEditingController();

  final _pesquisaClienteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _pagamentoProvider = Provider.of<PagamentoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Vendas com pagamento à prazo"),
        leading: BackButton(
          onPressed: () {
            limpar();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder(
        future: ClientePdvProvider(principalCtrl)
            .buscarClientes(nome: _pagamentoProvider.valorCampoCliente),
        builder: (BuildContext context, AsyncSnapshot<List<Cliente>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.yellow.shade400,
              ),
            );
          }
          if (snapshot.data!.isNotEmpty && snapshot.data!.first.id == 1) {
            snapshot.data!.removeAt(0);
          }
          return Container(
              //color: Colors.amber[400],
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  listaClientes(snapshot.data!),
                  listaPagamentos(),
                  colunaParaPagamento(),
                ],
              )));
        },
      ),
    );
  }

  // ---------------------- TextFields -----------------------

  colunaParaPagamento() {
    return Flexible(
      child: Container(
        color: Colors.blueGrey[400],
        padding: EdgeInsetsDirectional.all(10),
        margin: EdgeInsetsDirectional.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width * 0.3,
        alignment: AlignmentDirectional.center,
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              fieldValorDinheiro(),
              SizedBox(
                height: 10,
              ),
              fieldValorDebito(),
              SizedBox(
                height: 10,
              ),
              fieldValorCredito(),
              SizedBox(
                height: 10,
              ),
              fieldValorPix(),
              SizedBox(
                height: 10,
              ),
              fieldValorInserido(),
              SizedBox(
                height: 10,
              ),
              fieldValorTroco(),
              SizedBox(
                height: 20,
              ),
              botaoFinalizar()
            ],
          ),
        ),
      ),
    );
  }

  Widget fieldValorTotal() {
    _valorTotalController.text = ConversorMoeda.converterDoubleEmTexto(
        _pagamentoProvider.valorTotal.toStringAsFixed(2));
    return SizedBox(
      width: 200,
      height: 50,
      child: TextFormField(
        controller: _valorTotalController,
        enabled: false,
        style: const TextStyle(fontSize: 18),
        keyboardType: TextInputType.name,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          CentavosInputFormatter()
        ],
        decoration: const InputDecoration(
          prefixText: "R\$ ",
          prefixIcon: Icon(Icons.monetization_on_outlined),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget fieldNovoValorDaConta() {
    __novoValorDaContaController.text = ConversorMoeda.converterDoubleEmTexto(
        _pagamentoProvider.novoValorDaConta.toStringAsFixed(2));
    return SizedBox(
      width: 200,
      height: 50,
      child: TextFormField(
        controller: __novoValorDaContaController,
        enabled: false,
        style: const TextStyle(fontSize: 18),
        keyboardType: TextInputType.name,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          CentavosInputFormatter()
        ],
        decoration: const InputDecoration(
          prefixText: "R\$ ",
          prefixIcon: Icon(Icons.monetization_on_outlined),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  //----------------------------------------------------

  Widget fieldValorInserido() {
    _valorInseridoController.text = ConversorMoeda.converterDoubleEmTexto(
        _pagamentoProvider.valorTotalRecebido.toStringAsFixed(2));
    return Column(
      children: [
        Text(
          "Total recebido: ",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 200,
          height: 50,
          child: TextFormField(
            enabled: false,
            controller: _valorInseridoController,
            style: const TextStyle(fontSize: 18),
            keyboardType: TextInputType.name,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CentavosInputFormatter()
            ],
            validator: (value) {
              if (value!.isEmpty) {
                return "Insira um valor valído";
              }
              return null;
            },
            decoration: const InputDecoration(
              prefixText: "R\$ ",
              prefixIcon: Icon(Icons.monetization_on_outlined),
              border: OutlineInputBorder(),
            ),
            onEditingComplete: () {
              //double valor = _converterTextoEmDouble(_valorInseridoController.text);
              //_pagamentoProvider.alteraSituacaoDoPagamento(valor.abs());
            },
          ),
        ),
      ],
    );
  }

  Widget fieldValorDinheiro() {
    //DINHEIRO
    //_valorDinheiroController.text = _pagamentoProvider.valorRecebidoEmDinheiro.toStringAsFixed(2);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Dinheiro: ",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 200,
          height: 50,
          child: TextFormField(
            controller: _valorDinheiroController,
            style: const TextStyle(fontSize: 18),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CentavosInputFormatter()
            ],
            validator: (value) {
              if (value!.isEmpty) {
                return "Insira um valor valído";
              }
              return null;
            },
            decoration: const InputDecoration(
              prefixText: "R\$ ",
              prefixIcon: Icon(Icons.monetization_on_outlined),
              border: OutlineInputBorder(),
            ),
            onEditingComplete: () {
              double valor =
                  _converterTextoEmDouble(_valorDinheiroController.text);
              _pagamentoProvider.alterarValorRecidoEmDinheiro(valor.abs());
            },
          ),
        ),
      ],
    );
  }

  Widget fieldValorDebito() {
    //DEBITO
    //_valorDebitoController.text = _pagamentoProvider.valorRecebidoEmDebito.toStringAsFixed(2);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Débito: ",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 200,
          height: 50,
          child: TextFormField(
            controller: _valorDebitoController,
            style: const TextStyle(fontSize: 18),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CentavosInputFormatter()
            ],
            validator: (value) {
              if (value!.isEmpty) {
                return "Insira um valor valído";
              }
              return null;
            },
            decoration: const InputDecoration(
              prefixText: "R\$ ",
              prefixIcon: Icon(Icons.monetization_on_outlined),
              border: OutlineInputBorder(),
            ),
            onEditingComplete: () {
              double valor =
                  _converterTextoEmDouble(_valorDebitoController.text);
              _pagamentoProvider.alterarValorRecidoEmDebito(valor.abs());
            },
          ),
        ),
      ],
    );
  }

  Widget fieldValorCredito() {
    //CREDITO
    //_valorCreditoController.text = _pagamentoProvider.valorRecebidoEmCredito.toStringAsFixed(2);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Crédito: ",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 200,
          height: 50,
          child: TextFormField(
            controller: _valorCreditoController,
            style: const TextStyle(fontSize: 18),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CentavosInputFormatter()
            ],
            validator: (value) {
              if (value!.isEmpty) {
                return "Insira um valor valído";
              }
              return null;
            },
            decoration: const InputDecoration(
              prefixText: "R\$ ",
              prefixIcon: Icon(Icons.monetization_on_outlined),
              border: OutlineInputBorder(),
            ),
            onEditingComplete: () {
              double valor =
                  _converterTextoEmDouble(_valorCreditoController.text);
              _pagamentoProvider.alterarValorRecidoEmCredito(valor.abs());
            },
          ),
        ),
      ],
    );
  }

  Widget fieldValorPix() {
    //PIX
    //_valorPixController.text = _pagamentoProvider.valorRecebidoEmPix.toStringAsFixed(2);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Pix: ",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 200,
          height: 50,
          child: TextFormField(
            controller: _valorPixController,
            style: const TextStyle(fontSize: 18),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CentavosInputFormatter()
            ],
            validator: (value) {
              if (value!.isEmpty) {
                return "Insira um valor valído";
              }
              return null;
            },
            decoration: const InputDecoration(
              prefixText: "R\$ ",
              prefixIcon: Icon(Icons.monetization_on_outlined),
              border: OutlineInputBorder(),
            ),
            onEditingComplete: () {
              double valor = _converterTextoEmDouble(_valorPixController.text);
              _pagamentoProvider.alterarValorRecidoEmPix(valor.abs());
            },
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------------------

  Widget fieldValorTroco() {
    _valorTrocoController.text = ConversorMoeda.converterDoubleEmTexto(
        _pagamentoProvider.valorTroco.toStringAsFixed(2));
    return Column(
      children: [
        Text(
          "Troco: ",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 200,
          height: 50,
          child: TextFormField(
            controller: _valorTrocoController,
            enabled: false,
            style: const TextStyle(fontSize: 18),
            keyboardType: TextInputType.name,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CentavosInputFormatter()
            ],
            decoration: const InputDecoration(
              prefixText: "R\$ ",
              prefixIcon: Icon(Icons.monetization_on_outlined),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  double _converterTextoEmDouble(String texto) {
    //String texto = _valorController.text;
    if (texto.isNotEmpty) {
      if (texto.contains('.') || texto.contains(',')) {
        texto = texto.replaceAll('.', ',').replaceAll(',', '.');
      } else {
        return double.parse(texto).abs();
      }
      return double.parse(texto).abs();
    }
    return 0;
  }

  // ----------------------- Botões --------------------------

  botaoFinalizar() {
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton.icon(
        icon: Icon(Icons.arrow_forward_ios_sharp),
        onPressed: () async {
          if (_pagamentoProvider.valorTotalRecebido > 0) {
            await _imprimirComprovantePagamento();
            await _pagamentoProvider.alterarPagamentos();
          } else {
            return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Confira os valores inseridos!"),
                  );
                });
          }
          setState(() {});
        },
        label: const Text(
          "Finalizar",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  _imprimirComprovantePagamento() {
    Invoice invoice = Invoice();
    invoice.id = 0;
    invoice.client = Client(
        name: _pagamentoProvider.clienteSelecionado.nome,
        cpf: _pagamentoProvider.clienteSelecionado.cpf);
    invoice.pagamentoModificado = _pagamentoProvider.pagamentoModificado;
    invoice.total = _pagamentoProvider.novoValorDaConta;
    invoice.troco = _pagamentoProvider.valorTroco;
    invoice.valorTotalAntigo = _pagamentoProvider.valorTotal;
    print(">>: $invoice");
    principalCtrl.simularCriarDadosPDF(
        invoice, true); //true para compravante de pagamento do prazo
  }

  //----------------------- Clientes --------------------------

  listaClientes(List<Cliente> listaClientes) {
    return Flexible(
      child: Container(
          color: Colors.blueGrey[400],
          padding: EdgeInsetsDirectional.all(20),
          margin: EdgeInsetsDirectional.all(10),
          width: MediaQuery.of(context).size.width * 0.25,
          child: Column(
            children: [buscarCliente(), listViewClientes(listaClientes)],
          )),
    );
  }

  listViewClientes(List<Cliente> listaClientes) {
    if (listaClientes.isEmpty) {
      return Text(
        "Cliente não encontrado!",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (context, index) => Divider(height: 1),
      itemCount: listaClientes.length,
      itemBuilder: (context, index) {
        Cliente clienteAtual = listaClientes.elementAt(index);
        return GestureDetector(
          child: Container(
            padding: EdgeInsets.only(left: 8),
            color: Colors.grey[200],
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                    width: 40,
                    child: Icon(
                      Icons.person_sharp,
                      size: 40,
                    )),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: ListTile(
                      title: Text(clienteAtual.nome),
                      subtitle: Text("CPF: ${clienteAtual.cpf}"),
                    )),
              ],
            ),
          ),
          onTap: () {
            limpar();
            _pagamentoProvider.clienteSelecionado = clienteAtual;
            _pagamentoProvider.buscarPagamentosPrazo(
                idCliente: clienteAtual.id);
          },
        );
      },
    );
  }

  buscarCliente() {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      color: Colors.grey[200],
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [fieldPesquisaDoCliente()],
      ),
    );
  }

  fieldPesquisaDoCliente() {
    return SizedBox(
      width: 200,
      child: TextFormField(
        controller: _pesquisaClienteController,
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          CentavosInputFormatter()
        ],
        decoration: const InputDecoration(
          labelText: "Pesquise o cliente",
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
        ),
        onEditingComplete: () {
          print("Texto >> ${_pesquisaClienteController.text}");
          setState(() {
            _pagamentoProvider.valorCampoCliente =
                _pesquisaClienteController.text;
          });
        },
      ),
    );
  }

  //----------------------- Pagamentos -------------------------
  listaPagamentos() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        cabecalhoListViewPagamentos(),
        Expanded(
          child: Container(
            color: Colors.blueGrey[400],
            padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
            margin: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
            width: MediaQuery.of(context).size.width * 0.5,
            child: listViewPagamentos(),
          ),
        ),
        Container(
          color: Colors.blueGrey[500],
          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
          margin: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
          width: MediaQuery.of(context).size.width * 0.5,
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Valor original: ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              fieldValorTotal(),
              SizedBox(
                width: 30,
              ),
              Text("Valor atual: ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              fieldNovoValorDaConta()
            ],
          ),
        ),
      ],
    );
  }

  cabecalhoListViewPagamentos() {
    return Container(
      color: Colors.blueGrey,
      height: 50,
      width: MediaQuery.of(context).size.width * 0.5,
      margin: EdgeInsetsDirectional.only(top: 10),
      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          SizedBox(
            width: 100,
            child: Text(
              "Data",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              "Atendente",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              "Valor",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              "Cliente",
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              "Data prevista",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  listViewPagamentos() {
    if (_pagamentoProvider.lista.isEmpty) {
      return Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: Text(
            (_pagamentoProvider.clienteSelecionado.nome.isEmpty)
                ? "Selecione um cliente ao lado"
                : "Cliente selecionado não possui compras à prazo em aberto!",
            style: TextStyle(fontSize: 22),
          ));
    }

    ScrollPhysics _controllerScroll = NeverScrollableScrollPhysics();

    return ListView.separated(
      physics: _controllerScroll,
      separatorBuilder: (context, index) => Divider(height: 1),
      itemCount: _pagamentoProvider.lista.length,
      itemBuilder: (context, index) {
        var objeto = _pagamentoProvider.lista.elementAt(index);
        if (index == 0) {
          return ExpansionTile(
            textColor: Colors.black,
            title: rowDoPagamento(objeto, index),
            iconColor: Colors.black,
            collapsedIconColor: Colors.black,
            children: [rowDoPagamentoModificado()],
            onExpansionChanged: (isExpanded) {
              if (isExpanded) {
                _controllerScroll = NeverScrollableScrollPhysics();
              } else {
                _controllerScroll = ScrollPhysics();
              }
              if (_pagamentoProvider.modificados.isEmpty) {
                _pagamentoProvider.buscarPagamentosModificado();
              }
            },
          );
        } else {
          return Container(
              //color: Colors.blue[200],
              padding: EdgeInsets.fromLTRB(15, 5, 50, 5),
              child: rowDoPagamento(objeto, index));
        }
      },
    );
  }

  rowDoPagamento(var objeto, int index) {
    return Container(
      decoration: BoxDecoration(
        color: corDaLinha(objeto[7], index),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              DateFormat("dd/MM/yyyy  HH:mm").format(objeto[1]),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(
            //atendente/usuario
            width: 120,
            child: Text(
              objeto[2].toString(),
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(
            //valor
            width: 120,
            child: textoParaNovoValor(
                objeto[3].toString(),
                objeto[4].toString(),
                (_pagamentoProvider.indexNovoValor == index)),
          ),
          SizedBox(
            //cliente
            width: 100,
            child: Text(
              objeto[5].toString(),
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(
            //data prevista de pagamento
            width: 150,
            child: Text(
              dataPrevistaParaPagamento(
                  int.parse(objeto[6].toString()), objeto[1].month),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  rowDoPagamentoModificado() {
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(
              height: 0.5,
            ),
        shrinkWrap: true,
        itemCount: _pagamentoProvider.modificados.length,
        itemBuilder: (context, index) {
          print(
              ">>: ListView.separated ${_pagamentoProvider.modificados.length} | $index");
          if (_pagamentoProvider.modificados.isNotEmpty) {
            _pagamentoProvider.pagamentoModificado =
                _pagamentoProvider.modificados.elementAt(index);
          }
          return Container(
            height: 30,
            margin: EdgeInsets.fromLTRB(15, 0, 50, 1),
            decoration: BoxDecoration(
                color: Colors.green[200],
                gradient: LinearGradient(
                    colors: [Colors.green.shade300, Colors.green]),
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "#${index + 1}",
                  textAlign: TextAlign.start,
                ),
                Text(
                  DateFormat("dd/MM/yyyy")
                      .format(_pagamentoProvider.pagamentoModificado.data),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Valor pago: R\$${_pagamentoProvider.pagamentoModificado.novoValor.toStringAsFixed(2)}",
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          );
        });
  }

  corDaLinha(int x, int index) {
    if (x == 1 && (index != _pagamentoProvider.indexNovoValor)) {
      return Colors.green[200];
    } else if (index == _pagamentoProvider.indexNovoValor) {
      return Colors.orange[200];
    } else {
      return Colors.grey[200];
    }
  }

  textoParaNovoValor(String valorOriginal, String novoValor, bool x) {
    print(
        ">> textoParaNovoValor | original: $valorOriginal, já pago: $novoValor, index? $x");
    if (x) {
      return ListTile(
        title: Text(
          "R\$ ${_pagamentoProvider.novoValor.toStringAsFixed(2)}",
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 16),
        ),
        subtitle: Text(
          "R\$ ${double.parse(valorOriginal).toStringAsFixed(2)}",
          textAlign: TextAlign.start,
          style:
              TextStyle(fontSize: 16, decoration: TextDecoration.lineThrough),
        ),
      );
    }
    if (double.parse(novoValor) != double.parse(valorOriginal)) {
      return ListTile(
        title: Text(
          "R\$ ${double.parse(novoValor).toStringAsFixed(2)}",
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 16),
        ),
        subtitle: Text(
          "R\$ ${double.parse(valorOriginal).toStringAsFixed(2)}",
          textAlign: TextAlign.start,
          style:
              TextStyle(fontSize: 16, decoration: TextDecoration.lineThrough),
        ),
      );
    }

    return Text(
      "R\$ ${double.parse(valorOriginal).toStringAsFixed(2)}",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16),
    );
  }

  dataPrevistaParaPagamento(int diaPrev, int mesVenda) {
    return DateFormat("dd/MM/yyyy")
        .format(DateTime(DateTime.now().year, mesVenda + 1, diaPrev));
  }

  limpar() {
    _pagamentoProvider.limpar();
    _valorCreditoController.clear();
    _valorDebitoController.clear();
    _valorDinheiroController.clear();
    _valorPixController.clear();
    _valorInseridoController.clear();
    _valorTotalController.clear();
    _valorTrocoController.clear();
  }
}
