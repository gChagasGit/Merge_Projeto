// ignore_for_file: use_build_context_synchronously, await_only_futures

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_teste_msql1/components/clientes_pdv.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/modelo/Cliente.dart';
import 'package:flutter_teste_msql1/modelo/ItemVenda.dart';
import 'package:flutter_teste_msql1/modelo/Venda.dart';
import 'package:flutter_teste_msql1/provider/pdv/clientesPdvProvider.dart';
import 'package:flutter_teste_msql1/provider/pdv/formasDePagamentoProvider.dart';
import 'package:flutter_teste_msql1/provider/pdv/itensVendidosProvider.dart';
import 'package:flutter_teste_msql1/util/PDF/modelo_pdf/client.dart';
import 'package:flutter_teste_msql1/util/PDF/modelo_pdf/invoice.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../controle/FormaDePagamentoCtrl.dart';
import '../main.dart';
import '../modelo/Pagamento.dart';
import '../modelo/TipoPagamento.dart';
import '../util/ConversorMoeda.dart';

double valorTotal = 0.0;
double valorTroco = 0.0;

//MudarTela - Formas de Pagamento
Widget formaDePagamentoSubPage(
    BuildContext context,
    PrincipalCtrl principalCtrl,
    FormasDePagamentoProvider formasDePagamentoProvider,
    ItensVendidosProvider itensVendidosProvider,
    ClientePdvProvider clientesPdvProvider) {
  valorTotal = itensVendidosProvider.valorTotalVenda;
  return Container(
    margin: const EdgeInsets.fromLTRB(50, 0, 0, 20),
    width: MediaQuery.of(context).size.width * 0.8,
    height: MediaQuery.of(context).size.height * 0.8,
    child: Column(
      children: [
        cabecalhoBotoesFormasDePagamento(context, principalCtrl,
            formasDePagamentoProvider, clientesPdvProvider),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //CONTAINER DO ADD PAGAMENTO
            Flexible(
              child: Container(
                margin: const EdgeInsets.fromLTRB(65, 0, 0, 0),
                width: MediaQuery.of(context).size.width * 0.75,
                height: 300,
                color: Colors.lightBlue,
                // color: Colors.blueGrey,
                child: Column(children: [
                  cabecalhoListaFormasDePagamento(),
                  listaFormasDePagamentoAtuais()
                ]),
              ),
            ),
          ],
        ),
        rodape(context, formasDePagamentoProvider, itensVendidosProvider,
            clientesPdvProvider, valorTotal, principalCtrl),
      ],
    ),
  );
}

double _converterTextoEmDouble(String texto) {
  //String texto = _valorController.text;
  if (texto.isNotEmpty) {
    if (texto.contains('.') || texto.contains(',')) {
      texto = texto.replaceAll('.', ',').replaceAll(',', '.');
      print("TEXTO replaceAll $texto");
    } else {
      return double.parse(texto).abs();
    }
    return double.parse(texto).abs();
  }
  return 0;
}

_finalizarVenda(
    PrincipalCtrl principalCtrl,
    ItensVendidosProvider itensVendidosProvider,
    FormasDePagamentoProvider formasDePagamentoProvider) async {
  await itensVendidosProvider
      .salvarItensVendidosNoBanco(principalCtrl.itemVendaCtrl);

  await formasDePagamentoProvider
      .salvarPagamentosNoBanco(principalCtrl.formaDePagamentoCtrl);

  await principalCtrl.vendaCtrl.alterarDescontoDaVenda(
      formasDePagamentoProvider.desconto,
      itensVendidosProvider.itensVendidos.first.venda.id);

  principalCtrl.vendaCtrl.venda.cliente = principalCtrl.clienteCtrl.cliente;
  print(
      " Formas de Pagamento Sub Page (${principalCtrl.hashCode}) --> ${principalCtrl.vendaCtrl.venda.cliente.id} | ${principalCtrl.clienteCtrl.cliente.id}");
  await principalCtrl.vendaCtrl.alterarClienteDaVenda(
      itensVendidosProvider.itensVendidos.first.venda.id);

  Invoice invoice = Invoice();
  invoice.id = itensVendidosProvider.itensVendidos.first.venda.id;
  invoice.date = itensVendidosProvider.itensVendidos.first.venda.data;
  invoice.client = Client(
      name: principalCtrl.clienteCtrl.cliente.nome,
      cpf: principalCtrl.clienteCtrl.cliente.cpf);
  invoice.itensVendidos.addAll(itensVendidosProvider.itensVendidos);
  invoice.pagamentos.addAll(formasDePagamentoProvider.listaDeFormasDePagamento);
  invoice.troco = valorTroco;
  print(">>: $invoice");
  principalCtrl.simularCriarDadosPDF(
      invoice, false); //false pra um cupom de venda
}

_valorQueFalta(FormasDePagamentoProvider formasDePagamentoProvider) {
  double aux = (valorTotal -
      formasDePagamentoProvider.valorTotalRecebido -
      formasDePagamentoProvider.desconto);

  if (aux <= 0) {
    return '0,00';
  }

  return ConversorMoeda.converterDoubleEmTexto(aux.toStringAsFixed(2));
}

_valorTroco(
    FormasDePagamentoProvider formasDePagamentoProvider, double valorTotal) {
  double valor = (formasDePagamentoProvider.valorTotalRecebido +
          formasDePagamentoProvider.desconto) -
      valorTotal;

  double aux = formasDePagamentoProvider.valorRecebidoDinheiro -
      (valorTotal -
          formasDePagamentoProvider.desconto -
          (formasDePagamentoProvider.valorTotalRecebido -
              formasDePagamentoProvider.valorRecebidoDinheiro));

  if (aux >= formasDePagamentoProvider.valorRecebidoDinheiro) {
    valorTroco = formasDePagamentoProvider.valorRecebidoDinheiro;
    return ConversorMoeda.converterDoubleEmTexto(valorTroco.toStringAsFixed(2));
  }

  if (valor <= 0 || (formasDePagamentoProvider.desconto >= valorTotal)) {
    valorTroco = 0.0;
    return "0,00";
  }

  valorTroco = ((formasDePagamentoProvider.valorTotalRecebido +
          formasDePagamentoProvider.desconto) -
      valorTotal);

  return ConversorMoeda.converterDoubleEmTexto(valorTroco.toStringAsFixed(2));
}

cabecalhoBotoesFormasDePagamento(
    BuildContext context,
    PrincipalCtrl principalCtrl,
    FormasDePagamentoProvider formasDePagamentoProvider,
    ClientePdvProvider clientePdvProvider) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      //DINHEIRO
      Container(
        height: 60,
        width: 120,
        margin: const EdgeInsets.fromLTRB(65, 20, 20, 20),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 15),
            primary: Colors.lightBlue, //backgorund
            onPrimary: Colors.white,
          ),
          label: const Text("Dinheiro"),
          icon: const Icon(Icons.attach_money_rounded, color: Colors.white),
          onPressed: () async {
            await botaoFormaPagamento(principalCtrl, formasDePagamentoProvider,
                FormaDePagamentoCtrl.DINHEIRO);
          },
        ),
      ),
      Container(
        height: 60,
        width: 120,
        margin: const EdgeInsets.all(20),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 15),
            primary: Colors.lightBlue, //backgorund
            onPrimary: Colors.white,
          ),
          label: const Text("Crédito"),
          icon: const Icon(Icons.credit_card_rounded, color: Colors.white),
          onPressed: () async {
            await botaoFormaPagamento(principalCtrl, formasDePagamentoProvider,
                FormaDePagamentoCtrl.CREDITO);
          },
        ),
      ),
      Container(
        height: 60,
        width: 120,
        margin: const EdgeInsets.all(20),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 15),
            primary: Colors.lightBlue, //backgorund
            onPrimary: Colors.white,
          ),
          label: const Text("Débito"),
          icon: const Icon(Icons.credit_card_rounded, color: Colors.white),
          onPressed: () async {
            await botaoFormaPagamento(principalCtrl, formasDePagamentoProvider,
                FormaDePagamentoCtrl.DEBITO);
          },
        ),
      ),
      Container(
        height: 60,
        width: 120,
        margin: const EdgeInsets.all(20),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 15),
            primary: Colors.lightBlue, //backgorund
            onPrimary: Colors.white,
          ),
          label: const Text("PIX"),
          icon:
              const Icon(Icons.pix, color: Colors.white), //ARRUMAR ISSO AQ DPS
          onPressed: () async {
            await botaoFormaPagamento(principalCtrl, formasDePagamentoProvider,
                FormaDePagamentoCtrl.PIX);
          },
        ),
      ),
      Container(
        height: 60,
        width: 120,
        margin: const EdgeInsets.all(20),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 15),
            primary: Colors.lightBlue, //backgorund
            onPrimary: Colors.white,
          ),
          label: const Text("A prazo"),
          icon: const Icon(Icons.calendar_today,
              color: Colors.white), //ARRUMAR ISSO AQ DPS
          onPressed: () async {
            if (clientePdvProvider.clienteDaVenda.id == 1) {
              await chamaAlertListaClientesPDV(
                  context, clientePdvProvider, true);
            }
            await botaoFormaPagamento(principalCtrl, formasDePagamentoProvider,
                FormaDePagamentoCtrl.A_PRAZO);
          },
        ),
      ),
    ],
  );
}

rodape(
    BuildContext context,
    FormasDePagamentoProvider formasDePagamentoProvider,
    ItensVendidosProvider itensVendidosProvider,
    ClientePdvProvider clientePdvProvider,
    double valorTotal,
    PrincipalCtrl principalCtrl) {
  final _descontoController = TextEditingController();
  _descontoController.text = ConversorMoeda.converterDoubleEmTexto(
      formasDePagamentoProvider.desconto.toStringAsFixed(2));
  return Row(
    children: [
      Flexible(
        child: Container(
          margin: const EdgeInsets.fromLTRB(66.5, 20, 0, 0),
          width: MediaQuery.of(context).size.width * 0.75,
          height: 100,
          color: Colors.lightBlue,
          child: Row(
            children: [
              SizedBox(
                width: 180,
                child: ListTile(
                  title: const Text(
                    "Desconto:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: TextFormField(
                    controller: _descontoController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CentavosInputFormatter(),
                    ],
                    style: TextStyle(fontSize: 24),
                    decoration: const InputDecoration(
                      prefix: Text("R\$", style: TextStyle(fontSize: 24)),
                      suffixIcon: Icon(Icons.edit),
                    ),
                    onTap: () {
                      _descontoController.clear();
                    },
                    onEditingComplete: () async {
                      if (_descontoController.text.isNotEmpty) {
                        double valor =
                            _converterTextoEmDouble(_descontoController.text);
                        if (valor >= valorTotal) {
                          await vendaComDescontoTotal(
                              principalCtrl, formasDePagamentoProvider);
                        }
                        formasDePagamentoProvider.desconto = valor;
                        formasDePagamentoProvider.atualizarValor();
                      }
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: const Text("Recebido:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      "R\$ ${ConversorMoeda.converterDoubleEmTexto(formasDePagamentoProvider.valorTotalRecebido.toStringAsFixed(2))}",
                      style: TextStyle(fontSize: 32)),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: const Text("Falta:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      "R\$ ${_valorQueFalta(formasDePagamentoProvider)}",
                      style: TextStyle(fontSize: 32)),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: const Text("Troco:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      "R\$ ${_valorTroco(formasDePagamentoProvider, valorTotal)}",
                      style: TextStyle(fontSize: 32)),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: const Text("Total:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    "R\$ ${ConversorMoeda.converterDoubleEmTexto((valorTotal <= formasDePagamentoProvider.desconto) ? valorTotal.toStringAsFixed(2) : (valorTotal - formasDePagamentoProvider.desconto).toStringAsFixed(2))}",
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              //BOTAO FINALIZAR
              Container(
                width: 120,
                height: 50,
                margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (formasDePagamentoProvider
                        .listaDeFormasDePagamento.isEmpty) {
                      createAlertDialogErroAoFinalizarVenda(context);
                    } else if (formasDePagamentoProvider
                        .aprovarVenda(valorTotal)) {
                      await createAlertDialogFinalizarVendaOK(
                          context,
                          formasDePagamentoProvider,
                          principalCtrl,
                          itensVendidosProvider,
                          clientePdvProvider);
                    limparCamposPosFinalizarVenda(itensVendidosProvider, formasDePagamentoProvider, clientePdvProvider, principalCtrl);
                    } else {
                      createAlertDialogValorInsuficienteParaFinalizarVenda(
                          context);
                    }
                  },
                  child: const Text("Finalizar"),
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                      primary: Colors.blueGrey,
                      onPrimary: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

vendaComDescontoTotal(PrincipalCtrl principalCtrl,
    FormasDePagamentoProvider formasDePagamentoProvider) async {
  await botaoFormaPagamento(
      principalCtrl, formasDePagamentoProvider, FormaDePagamentoCtrl.DINHEIRO);
}

cabecalhoListaFormasDePagamento() {
  return Material(
    elevation: 5.0,
    child: Container(
      padding: const EdgeInsets.all(8),
      color: Colors.black45,
      child: Row(
        children: const [
          SizedBox(width: 60),
          SizedBox(
              width: 520,
              child: Text('Forma de pagamento',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          SizedBox(
              width: 100,
              child: Text('Valor',
                  textAlign: TextAlign.end,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          SizedBox(
              width: 130,
              child: Text('Parcelas',
                  textAlign: TextAlign.end,
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    ),
  );
}

listaFormasDePagamentoAtuais() {
  FormasDePagamentoProvider formasDePagamentoProvider;
  return Consumer<FormasDePagamentoProvider>(
    builder: (context, valueProvider, child) {
      formasDePagamentoProvider = valueProvider;
      return Expanded(
          child: (formasDePagamentoProvider.listaDeFormasDePagamento.isEmpty)
              ? const Center(
                  child: Text(
                    "Adicione um ou mais pagamentos",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                )
              : listViewComAsFormasDePagamento(formasDePagamentoProvider));
    },
  );
}

listViewComAsFormasDePagamento(
    FormasDePagamentoProvider formasDePagamentoProvider) {
  List<Pagamento> listaFormasDePagamento =
      formasDePagamentoProvider.listaDeFormasDePagamento;
  return ListView.builder(
    padding: const EdgeInsets.all(8),
    itemCount: listaFormasDePagamento.length,
    itemBuilder: (context, index) {
      final _valorSubPagamentoController = TextEditingController();
      final _numeroPacelasController = TextEditingController();
      Pagamento pagamentoAtual = listaFormasDePagamento.elementAt(index);
      bool _permiteVariasPacelas =
          (pagamentoAtual.tipoPagamento.id == FormaDePagamentoCtrl.CREDITO);

      _valorSubPagamentoController.text = ConversorMoeda.converterDoubleEmTexto(
          pagamentoAtual.valor.toStringAsFixed(2));
      _numeroPacelasController.text = pagamentoAtual.numParcelas.toString();
      return Container(
        height: 50,
        color: (index % 2 == 0) ? Colors.grey[300] : Colors.blueGrey[200],
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 20),
            SizedBox(width: 20, child: Text('${index + 1}')),
            const SizedBox(width: 20),
            SizedBox(
              width: 500,
              child: Text(pagamentoAtual.tipoPagamento.descricao),
            ),
            const SizedBox(width: 20),
            SizedBox(
                width: 100,
                height: 35,
                child: TextFormField(
                  //valor vendido
                  enabled: (formasDePagamentoProvider.desconto <= valorTotal),
                  controller: _valorSubPagamentoController,
                  textAlignVertical: TextAlignVertical.bottom,
                  textAlign: TextAlign.end,
                  inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CentavosInputFormatter()
                    ],
                  decoration: const InputDecoration(
                    hintText: "0,00",
                    prefix: Text("R\$"),
                    border: OutlineInputBorder(),
                  ),
                  onTap: () {
                    _valorSubPagamentoController.clear();
                  },
                  onEditingComplete: () {
                    if (_valorSubPagamentoController.text.isNotEmpty) {
                      double valor = double.parse(GetUtils.numericOnly(
                                      _valorSubPagamentoController.text)) /
                                  100;
                      pagamentoAtual.valor = valor;
                      formasDePagamentoProvider.atualizarValor();
                    }
                  },
                )),
            const SizedBox(width: 60),
            SizedBox(
                width: 70,
                height: 35,
                child: TextFormField(
                  //valor vendido
                  enabled: _permiteVariasPacelas,
                  controller: _numeroPacelasController,
                  textAlignVertical: TextAlignVertical.top,
                  textAlign: TextAlign.end,
                  keyboardType: TextInputType.number,
                  inputFormatters: [LengthLimitingTextInputFormatter(2)],
                  decoration: const InputDecoration(
                    suffix: Text("x"),
                    border: OutlineInputBorder(),
                  ),
                  onTap: () {
                    _numeroPacelasController.clear();
                  },
                  onEditingComplete: () {
                    if (_valorSubPagamentoController.text.isNotEmpty) {
                      double valor = _converterTextoEmDouble(
                          _valorSubPagamentoController.text);
                      pagamentoAtual.valor = valor;
                      formasDePagamentoProvider.atualizarValor();
                    }
                    if (_numeroPacelasController.text.isNotEmpty) {
                      pagamentoAtual.numParcelas =
                          int.tryParse(_numeroPacelasController.text) ?? 1;
                    }
                  },
                )),
            Expanded(
              child: IconButton(
                  onPressed: () {
                    formasDePagamentoProvider.remove(pagamentoAtual);
                  },
                  icon: const Icon(Icons.delete)),
            )
          ],
        ),
      );
    },
  );
}

// botoes

botaoFormaPagamento(
    PrincipalCtrl principalCtrl,
    FormasDePagamentoProvider formasDePagamentoProvider,
    int idTipoPagamento) async {
  if (!formasDePagamentoProvider
      .isFormaDePagamentoJaAdicionada(idTipoPagamento)) {
    TipoPagamento _tipoPagamento = TipoPagamento();
    _tipoPagamento = await principalCtrl.formaDePagamentoCtrl
        .buscaTipoDePagamentoPorId(idTipoPagamento);

    Pagamento _pag = Pagamento();
    _pag.dataPagamento = (idTipoPagamento == FormaDePagamentoCtrl.A_PRAZO)
        ? FormaDePagamentoCtrl.SEM_DATA_PAGAMENTO
        : DateTime.now();
    _pag.venda = principalCtrl.vendaCtrl.venda;
    _pag.tipoPagamento = _tipoPagamento;
    _pag.valor = 0.0;

    formasDePagamentoProvider.add(_pag);
  }
}

botaoFlutuanteSelecionarCliente(
    BuildContext context, ClientePdvProvider clientePdvProvider, bool aPrazo) {
  return SizedBox(
    width: 70,
    height: 70,
    child: FloatingActionButton(
        elevation: 10,
        child: const Icon(Icons.person_add_alt_1_sharp, size: 30),
        onPressed: () async {
          await chamaAlertListaClientesPDV(context, clientePdvProvider, aPrazo);
        }),
  );
}

// alerts dialogs

createAlertDialogFinalizarVendaOK(
    BuildContext context,
    FormasDePagamentoProvider formasDePagamentoProvider,
    PrincipalCtrl principalCtrl,
    ItensVendidosProvider itensVendidosProvider,
    ClientePdvProvider clientePdvProvider) {
  String nomeCliente = clientePdvProvider.clienteDaVenda.nome;
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: const [
              const Text("Confira os valores para finalizar venda",
                  textAlign: TextAlign.center),
              Divider(),
              Text(
                "*Clique 'Confirmar' para finalizar",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                            side: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        await _finalizarVenda(principalCtrl,
                            itensVendidosProvider, formasDePagamentoProvider);
                        await limparCamposPosFinalizarVenda(
                            itensVendidosProvider,
                            formasDePagamentoProvider,
                            clientePdvProvider,
                            principalCtrl);
                        await ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            padding: EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                            ),
                            content: Text('Venda finalizada com sucesso!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        principalCtrl.routeAbrirTela_FrenteCaixa(context);
                      },
                      child: const Text(
                        "CONFIRMAR",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                            side: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "CANCELAR",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
          content: Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width * 0.4,
            color: Colors.grey[400],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 40,
                    child: Text(
                      'Cliente: $nomeCliente',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
                Divider(height: 1),
                ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => Divider(height: 1),
                    //padding: const EdgeInsets.all(8),
                    itemCount: formasDePagamentoProvider
                        .listaDeFormasDePagamento.length,
                    itemBuilder: (context, index) {
                      Pagamento pag = formasDePagamentoProvider
                          .listaDeFormasDePagamento
                          .elementAt(index);
                      return Row(
                        children: [
                          SizedBox(
                              width: 200,
                              height: 40,
                              child: Text(pag.tipoPagamento.descricao)),
                          SizedBox(
                              width: 200,
                              height: 40,
                              child: Text(
                                  'R\$ ${ConversorMoeda.converterDoubleEmTexto(pag.valor.toStringAsFixed(2))}')),
                        ],
                      );
                    }),
                Divider(height: 1),
                Row(
                  children: [
                    SizedBox(
                        width: 200,
                        height: 40,
                        child: Text('VALOR RECEBIDO: ')),
                    SizedBox(
                      width: 200,
                      height: 40,
                      child: Text(
                          'R\$ ${ConversorMoeda.converterDoubleEmTexto(formasDePagamentoProvider.valorTotalRecebido.toStringAsFixed(2))}'),
                    )
                  ],
                ),
                Divider(height: 1),
                Row(
                  children: [
                    SizedBox(
                        width: 200, height: 50, child: Text('VALOR TOTAL: ')),
                    SizedBox(
                      width: 200,
                      height: 40,
                      child: Text(
                          'R\$ ${ConversorMoeda.converterDoubleEmTexto(valorTotal.toStringAsFixed(2))}'),
                    )
                  ],
                ),
                Divider(height: 1),
                Row(
                  children: [
                    SizedBox(width: 200, height: 40, child: Text('DESCONTO: ')),
                    SizedBox(
                      width: 200,
                      height: 40,
                      child: Text(
                          'R\$ ${ConversorMoeda.converterDoubleEmTexto(formasDePagamentoProvider.desconto.toStringAsFixed(2))}'),
                    )
                  ],
                ),
                Divider(height: 1),
                Row(
                  children: [
                    SizedBox(width: 200, height: 40, child: Text('TROCO: ')),
                    SizedBox(
                      width: 200,
                      height: 40,
                      child: Text(
                          'R\$ ${ConversorMoeda.converterDoubleEmTexto(_valorTroco(formasDePagamentoProvider, valorTotal))}'),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      });
}

createAlertDialogErroAoFinalizarVenda(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text("Você precisa adicionar uma forma de pagamento!"),
        );
      });
}

createAlertDialogValorInsuficienteParaFinalizarVenda(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text("Verifique o valor total recebido!"),
        );
      });
}

chamaAlertListaClientesPDV(BuildContext context,
    ClientePdvProvider clientePdvProvider, bool aPrazo) async {
  await clientePdvProvider.buscarClientes();
  await createAlertDialog_ListaClientesPDV(context, clientePdvProvider, aPrazo);
}

createAlertDialog_ListaClientesPDV(BuildContext context,
    ClientePdvProvider clientePdvProvider, bool aPrazo) async {
  return await clientes_PDV(context, clientePdvProvider, aPrazo);
}

limparCamposPosFinalizarVenda(
    ItensVendidosProvider itensVendidosProvider,
    FormasDePagamentoProvider formasDePagamentoProvider,
    ClientePdvProvider clientePdvProvider,
    PrincipalCtrl principalCtrl) {
  itensVendidosProvider.limpar();
  formasDePagamentoProvider.limpar();
  clientePdvProvider.limpar();
  principalCtrl.clienteCtrl.cliente = Cliente();
  principalCtrl.itemVendaCtrl.itemVenda = ItemVenda();
  print(
      ">> Venda antes ${principalCtrl.vendaCtrl.venda} \n ${principalCtrl.caixaCrtl.caixa} \n ${principalCtrl.usuarioCtrl.usuarioLogado}");
  principalCtrl.vendaCtrl.venda = Venda();
  print(
      ">> Venda depois ${principalCtrl.vendaCtrl.venda} \n ${principalCtrl.caixaCrtl.caixa} \n ${principalCtrl.usuarioCtrl.usuarioLogado}");
  principalCtrl.formaDePagamentoCtrl.pagamento = Pagamento();
}