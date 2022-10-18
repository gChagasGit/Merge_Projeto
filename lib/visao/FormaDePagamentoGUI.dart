import 'package:flutter_teste_msql1/controle/FormaDePagamentoCtrl.dart';
import 'package:flutter_teste_msql1/modelo/Pagamento.dart';

class FormaDePagamentoGUI {
  late FormaDePagamentoCtrl _formaDePagamentoCtrl;

  FormaDePagamentoGUI(FormaDePagamentoCtrl formaDePagamentoCtrl) {
    _formaDePagamentoCtrl = formaDePagamentoCtrl;
  }

  Future<void> simulaSalvarPagamentoDaVenda() async {
    //simulação de pagamentos em 3 formas (tudo PIX)
    print(" - simulaSalvarPagamentoDaVenda");
    _formaDePagamentoCtrl.pagamento.venda =
        _formaDePagamentoCtrl.vendaCtrl.venda;
    for (int i = 0; i < 5; i++) {
      _formaDePagamentoCtrl.pagamento.valor = 10 * i + 10.5;
      _formaDePagamentoCtrl.tipoPagamento.id = FormaDePagamentoCtrl.DEBITO;
      _formaDePagamentoCtrl.pagamento.tipoPagamento = _formaDePagamentoCtrl.tipoPagamento;

      print(" - A ser salvo: ${_formaDePagamentoCtrl.pagamento}");
      //await _formaDePagamentoCtrl.salvarPagamento();
    }
  } 

  Future<void> simulaBuscaDePagamentos() async {
    // _formaDePagamentoCtrl.vendaCtrl.venda.id = 29;
    await _formaDePagamentoCtrl.buscarListaPagamentosPorVenda();

    for (var pagamento in _formaDePagamentoCtrl.pagamentos) {
      print("> $pagamento");
    }
  }

  Future<void> alterarConfirmacaoDePagamento() async {
    //defina qual pagamento será alterado
    _formaDePagamentoCtrl.pagamento.id = 20;
    //await _formaDePagamentoCtrl.alterarConfirmacaoDePagamento();
  }
}
