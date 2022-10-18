import 'package:flutter/cupertino.dart';
import 'package:flutter_teste_msql1/controle/FormaDePagamentoCtrl.dart';
import 'package:flutter_teste_msql1/modelo/Pagamento.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class FormasDePagamentoProvider extends ChangeNotifier {
  bool contemVendaPrazo = false;
  double valorTotalRecebido = 0;
  double valorRecebidoDinheiro = 0;
  double desconto = 0;
  final List<Pagamento> listaDeFormasDePagamento = [];

  add(Pagamento pagamento) {
    if(pagamento.tipoPagamento.id == FormaDePagamentoCtrl.DINHEIRO){
      valorRecebidoDinheiro += pagamento.valor;
    }
    if (pagamento.tipoPagamento.id == FormaDePagamentoCtrl.A_PRAZO &&
        !contemVendaPrazo) {
      valorTotalRecebido += pagamento.valor;
      listaDeFormasDePagamento.add(pagamento);
      contemVendaPrazo = true;
    } else if (!contemVendaPrazo) {
      valorTotalRecebido += pagamento.valor;
      listaDeFormasDePagamento.add(pagamento);
    }
    notifyListeners();
  }

  bool isFormaDePagamentoJaAdicionada(int id){
    for (var element in listaDeFormasDePagamento) {
      if(element.tipoPagamento.id == id){
        return true;
      }
    }
    return false;
  }

  remove(Pagamento pagamento) {
    if(pagamento.tipoPagamento.id == FormaDePagamentoCtrl.DINHEIRO){
      valorRecebidoDinheiro -= pagamento.valor;
    }
    if (pagamento.tipoPagamento.id == FormaDePagamentoCtrl.A_PRAZO) {
      contemVendaPrazo = false;
    }
    valorTotalRecebido -= pagamento.valor;
    listaDeFormasDePagamento.remove(pagamento);
    notifyListeners();
  }

  atualizarValor() {
    valorTotalRecebido = 0;
    valorRecebidoDinheiro = 0;
    for (var element in listaDeFormasDePagamento) {
      if(element.tipoPagamento.id == FormaDePagamentoCtrl.DINHEIRO){
      valorRecebidoDinheiro += element.valor;
      }
      valorTotalRecebido += element.valor;
    }
    notifyListeners();
  }

  salvarPagamentosNoBanco(FormaDePagamentoCtrl formaDePagamentoCtrl) async {
    for (var element in listaDeFormasDePagamento) {
      element.novoValor = element.valor;
      await formaDePagamentoCtrl.salvarPagamento(element);
    }
  }

  bool aprovarVenda(double valorVenda) {
    if (valorTotalRecebido >= (valorVenda - desconto)) {
      return true;
    }
    return false;
  }

  limpar() {
    contemVendaPrazo = false;
    desconto = 0;
    valorTotalRecebido = 0;
    valorRecebidoDinheiro = 0;
    listaDeFormasDePagamento.clear();
    notifyListeners();
  }
}
