import 'package:flutter/cupertino.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/modelo/Cliente.dart';
import 'package:flutter_teste_msql1/modelo/Pagamento.dart';

import '../../modelo/PagamentoModificado.dart';

class PagamentoProvider with ChangeNotifier {
  PrincipalCtrl principalCtrl;

  PagamentoProvider(this.principalCtrl);

  //data, user nome, valor, cli nome, diaPrevPag
  List<dynamic> lista = [];
  List<PagamentoModificado> modificados = [];
  PagamentoModificado pagamentoModificado = PagamentoModificado();

  double valorTotal = 0.0;
  double valorTroco = 0.0;
  double novoValor = 0.0;
  double novoValorPagamentoModificado = 0.0;
  int indexNovoValor = -1;
  double novoValorDaConta = 0.0;

  double valorTotalRecebido = 0.0;
  double valorRecebidoEmDinheiro = 0.0;
  double valorRecebidoEmDebito = 0.0;
  double valorRecebidoEmCredito = 0.0;
  double valorRecebidoEmPix = 0.0;

  bool _flagTodaCompraPaga = false;

  Cliente clienteSelecionado = Cliente();
  String valorCampoCliente = "";

  //-------------------- VALORES INSERIDOS --------------------

  void alterarValorRecidoEmDinheiro(double valor) {
    valorRecebidoEmDinheiro = valor;
    _valorTotalRecebido();
    _alteraSituacaoDoPagamento();
  }

  void alterarValorRecidoEmDebito(double valor) {
    valorRecebidoEmDebito = valor;
    _valorTotalRecebido();
    _alteraSituacaoDoPagamento();
  }

  void alterarValorRecidoEmCredito(double valor) {
    valorRecebidoEmCredito = valor;
    _valorTotalRecebido();
    _alteraSituacaoDoPagamento();
  }

  void alterarValorRecidoEmPix(double valor) {
    valorRecebidoEmPix = valor;
    _valorTotalRecebido();
    _alteraSituacaoDoPagamento();
  }

  _valorTotalRecebido() {
    valorTotalRecebido = valorRecebidoEmDinheiro +
        valorRecebidoEmDebito +
        valorRecebidoEmCredito +
        valorRecebidoEmPix;
  }

  //---------------------------------------------------
  alterarPagamentos() {
    lista.forEach((element) {
      if (element[7] == 1) {
        Pagamento pag = Pagamento();
        pag.id = element[0];
        pag.dataPagamento = DateTime.now();
        principalCtrl.formaDePagamentoCtrl.alterarConfirmacaoDePagamento(pag);
      }
    });

    if (!_flagTodaCompraPaga) {
      _salvarPagamentoModificado();
    }
    limpar();
    buscarPagamentosPrazo(idCliente: clienteSelecionado.id);
  }

  buscarPagamentosPrazo({int? idCliente}) async {
    if (idCliente != null) {
      clienteSelecionado.id = idCliente;
    }
    lista.clear();
    lista = await principalCtrl.formaDePagamentoCtrl
        .buscarPagamentosPrazoAberto(fkIdCliente: idCliente);
    await _somar();
    notifyListeners();
  }

  _somar() {
    valorTotal = 0.0;
    if (lista.isNotEmpty) {
      lista.forEach((element) {
        element.add(0); //simboliza que não foi pago ainda
        element.add(false); //isExpanded
        valorTotal += element[4];
      });
    }
    novoValorDaConta = valorTotal;
    print(
        ">> Valor -> total $valorTotal | troco: $valorTroco | novo valor da conta: $novoValorDaConta");
    notifyListeners();
  }

  _alteraSituacaoDoPagamento() {
    print("_alteraSituacaoDoPagamento | $valorTotalRecebido");
    if (valorTotalRecebido >= valorTotal) {
      indexNovoValor = -1;
      _marcarTodosComoPago(valorTotalRecebido);
      return;
    }

    indexNovoValor = -1;
    _limparCampoPago();
    if (lista.isNotEmpty) {
      double aux = double.parse(lista.elementAt(0)[4].toStringAsFixed(2));
      int i = 0;
      do {
        print("While | aux: ${aux.toStringAsFixed(2)} | i: $i");
        if (aux <= valorTotalRecebido) {
          lista.elementAt(i++)[7] = 1;
          aux += double.parse(lista.elementAt(i)[4].toStringAsFixed(2));
        } else {
          break;
        }
      } while (i < lista.length);
      aux -= lista.elementAt(i)[4];
      if (double.parse((valorTotalRecebido - aux).toStringAsFixed(2)) > 0) {
        indexNovoValor = i;
        novoValor =
            lista.elementAt(indexNovoValor)[4] - (valorTotalRecebido - aux);
        novoValorPagamentoModificado = (valorTotalRecebido - aux);
        print("While Novo valor: $novoValor | index: $indexNovoValor");
      }

      if (valorTotalRecebido > valorTotal) {
        valorTroco = valorTotalRecebido - valorTotal;
      }

      //novoValorDaConta = valorTotal-aux-(lista.elementAt(indexNovoValor)[3]-novoValor);
      novoValorDaConta = valorTotal - valorTotalRecebido;
      notifyListeners();
    }
  }

  void _salvarPagamentoModificado() {
    pagamentoModificado.data = DateTime.now();
    pagamentoModificado.dinheiro = valorRecebidoEmDinheiro;
    pagamentoModificado.credito = valorRecebidoEmCredito;
    pagamentoModificado.debito = valorRecebidoEmDebito;
    pagamentoModificado.pix = valorRecebidoEmPix;
    pagamentoModificado.novoValor = novoValorPagamentoModificado;
    pagamentoModificado.pagamento.id = lista.elementAt(indexNovoValor)[0];
    print(">>: Simulação | $pagamentoModificado");
    principalCtrl.formaDePagamentoCtrl
        .salvarPagamentoModificado(pagamentoModificado);
    novoValorPagamentoModificado = 0.0;
  }

  _limparCampoPago() {
    lista.forEach((element) => element[7] = 0);
  }

  _marcarTodosComoPago(double valorInserido) {
    lista.forEach((element) => element[7] = 1);
    valorTroco = valorInserido - valorTotal;
    novoValorDaConta = 0.0;
    _flagTodaCompraPaga = true;
    notifyListeners();
  }

  abrirExpansionPanel(bool isExpanded) async {
    print(">> buscando pagamentos modificados de ${lista.first[0]}");
    await buscarPagamentosModificado();
    if (modificados.isNotEmpty) {
      lista.first[8] = !isExpanded;
      notifyListeners();
    }
  }

  // --------------- Pagamento modificado ------------

  Future<void> buscarPagamentosModificado() async {
    await principalCtrl.formaDePagamentoCtrl
        .buscarListaPagamentosModificados(lista.first[0])
        .then((value) {
      modificados.addAll(value);
    });
    notifyListeners();
  }

  // ----------------------- Imprimir ----------------

  pagamentosParaImprimir() {
    List<Pagamento> pags = [];
    for (int i = 0; i < lista.length; i++) {
      Pagamento pag = Pagamento();
      pag.venda.data = lista[i][1];
      pag.valor = lista[i][3];
      pag.novoValor =
          (i != indexNovoValor) ? lista[i][4] : novoValorPagamentoModificado;
      pags.add(pag);
    }
    return pags;
  }

  // -------------------- limpar ---------------------

  limpar() {
    valorTotal = 0.0;
    valorTroco = 0.0;
    novoValor = 0.0;
    novoValorPagamentoModificado = 0.0;
    indexNovoValor = -1;
    novoValorDaConta = 0.0;
    valorTotalRecebido = 0.0;
    valorRecebidoEmDinheiro = 0.0;
    valorRecebidoEmDebito = 0.0;
    valorRecebidoEmCredito = 0.0;
    valorRecebidoEmPix = 0.0;
    _flagTodaCompraPaga = false;
    clienteSelecionado = Cliente();
    valorCampoCliente = "";

    pagamentoModificado = PagamentoModificado();
    modificados.clear();
    lista.clear();
    notifyListeners();
  }
}
