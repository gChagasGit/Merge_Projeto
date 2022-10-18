import 'package:flutter_teste_msql1/controle/VendaCtrl.dart';
import 'package:flutter_teste_msql1/dao/PagamentoDAO.dart';
import 'package:flutter_teste_msql1/dao/PagamentoModificadoDAO.dart';
import 'package:flutter_teste_msql1/dao/TipoPagamentoDAO.dart';
import 'package:flutter_teste_msql1/modelo/Pagamento.dart';
import 'package:flutter_teste_msql1/modelo/PagamentoModificado.dart';
import 'package:flutter_teste_msql1/modelo/TipoPagamento.dart';

class FormaDePagamentoCtrl {
  
  static const int DINHEIRO = 1;
  static const int A_PRAZO = 2;
  static const int PIX = 3;
  static const int CREDITO = 4;
  static const int DEBITO = 5;

  static DateTime SEM_DATA_PAGAMENTO = DateTime.parse("2000-01-01");

  late VendaCtrl _vendaCtrl;

  late Pagamento _pagamento;
  late List<Pagamento> _pagamentos;
  late PagamentoDAO _pagamentoDAO;

  late TipoPagamento _tipoPagamento;
  late List<TipoPagamento> _tiposDePagamentos;
  late TipoPagamentoDAO _tipoPagamentoDAO;

  late List<PagamentoModificado> _listaPagamentosModificado;
  late PagamentoModificadoDAO _pagamentoModificadoDAO;

  FormaDePagamentoCtrl(VendaCtrl vendaCtrl) {
    _vendaCtrl = vendaCtrl;
    _pagamento = Pagamento();
    _pagamentos = [];
    _pagamentoDAO = PagamentoDAO();
    _tipoPagamento = TipoPagamento();
    _tiposDePagamentos = [];
    _tipoPagamentoDAO = TipoPagamentoDAO();
    _listaPagamentosModificado = [];
    _pagamentoModificadoDAO = PagamentoModificadoDAO();
  }

  // ----------------- A PRAZO ---------------------

  Future<List<dynamic>> buscarPagamentosPrazoAberto({int? fkIdCliente}) async {
    var lista = await _pagamentoDAO.buscarPagamentosPrazoAberto(fkIdCliente: fkIdCliente);
    print("FormaPagamentoCtrl | buscarPagamentosPrazoAberto > ${lista.length}");
    lista.forEach((element) => print(element));
    return lista;
  }

  // ----------------- Pagamento -------------------

  Future<void> salvarPagamento(Pagamento pagamento) async {
    _pagamento.id = await _pagamentoDAO.salvar(pagamento);
    pagamento.id = _pagamento.id;
    print("Ctrl | salvouPagamento > $pagamento");
  }

  Future<void> alterarConfirmacaoDePagamento(Pagamento pagamento) async {
    //Data vai funcionar como uma confirmação de pagamento
    print("FormaPagamentoCtrl | alterarConfirmacaoDePagamento > $pagamento");
    await _pagamentoDAO.alterarConfirmacaoDePagamento(pagamento);
  }

  Future<void> buscarListaPagamentosPorVenda() async {
    _pagamentos = await _pagamentoDAO.buscarTodos(fkIdVenda: _vendaCtrl.venda.id);

    for (var pagamentoAtual in _pagamentos) {
      _tipoPagamento = await _tipoPagamentoDAO.buscaPorId(pagamentoAtual.tipoPagamento.id);
      pagamentoAtual.tipoPagamento = _tipoPagamento;  
    }
  }

  // ---------- Tipo de Pagamento ------------------
  Future<void> salvarTipoDePagamento() async {
    _tipoPagamento.id = await _tipoPagamentoDAO.salvar(_tipoPagamento);
  }

  Future<TipoPagamento> buscaTipoDePagamentoPorId(int id) async {
    return await _tipoPagamentoDAO.buscaPorId(id);
    }

  void set pagamento(Pagamento pagamento){
    _pagamento = pagamento;
  }

  Pagamento get pagamento => _pagamento;

  void set pagamentos(List<Pagamento> pagamentos){
    _pagamentos.clear();
    _pagamentos.addAll(pagamentos);
  }

  List<Pagamento> get pagamentos => _pagamentos;

  void set tipoPagamento(TipoPagamento tipoPagamento){
    _tipoPagamento = tipoPagamento;
  }

  TipoPagamento get tipoPagamento => _tipoPagamento;

  void set tiposDePagamentos(List<TipoPagamento> tiposDePagamentos){
    _tiposDePagamentos.clear();
    _tiposDePagamentos.addAll(tiposDePagamentos);
  }

  VendaCtrl get vendaCtrl => _vendaCtrl;

  //-------------------------- Pagamento Modificado --------------------------

  Future<List<PagamentoModificado>> buscarListaPagamentosModificados(int fkIdPagamento) async {
    _listaPagamentosModificado.clear();
    _listaPagamentosModificado = await _pagamentoModificadoDAO.buscaListaPorPagamento(fkIdPagamento);
    print("FormaDePagamentoCtrl | buscarListaPagamentosModificados | ${_listaPagamentosModificado.length}");
    return _listaPagamentosModificado;
  }

  Future<void> salvarPagamentoModificado(PagamentoModificado pagamentoModificado) async {
    pagamentoModificado.id = await _pagamentoModificadoDAO.salvar(pagamentoModificado);
    print("FormaDePagamentoCtrl | salvarPagamentoModificado | ${pagamentoModificado.id}");
  }

}
