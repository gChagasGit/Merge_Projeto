import 'package:flutter_teste_msql1/dao/VendaDAO.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../modelo/Venda.dart';

class VendaCtrl{

  late Venda _venda;
  late List<Venda> _vendas;
  late VendaDAO _vendaDAO;

  VendaCtrl(){
    _venda = Venda();
    _vendas = [];
    _vendaDAO = VendaDAO();
  }

  void set venda(Venda venda){
    _venda = venda;
  }

  Venda get venda => _venda;

  void set vendas(List<Venda> vendas){
    _vendas.clear();
    _vendas.addAll(vendas);
  }

  List<Venda> get vendas => _vendas;

  Future<void> salvarVenda() async {
    _venda.id = await _vendaDAO.salvar(_venda);
    print(">> Venda salva | $_venda");
  }

  Future<void> buscaVendaPorId(int id) async {
    _venda = await _vendaDAO.buscaPorId(id);
  }

  Future<List<Venda>> buscarListaDeVendas({PickerDateRange? range}) async {
    _vendas = await _vendaDAO.buscarTodos(range: range);
    return _vendas;
  }

  Future<List<Venda>> buscarListaVendasPorCliente(int fkIdCliente, {PickerDateRange? range}) async {
    _vendas = await _vendaDAO.buscarTodos(fkIdCliente: fkIdCliente, range: range);
    return _vendas;
  }

  Future<void> excluirVenda() async {
    await _vendaDAO.excluir(_venda);
  }

  Future<void> alterarDescontoDaVenda(double desconto, int idVenda)async {
    await _vendaDAO.alterarDescontoDaVenda(desconto, idVenda);
  }

  Future<void> alterarClienteDaVenda(int idVenda)async {
    await _vendaDAO.alterarClienteDaVenda(venda.cliente.id, idVenda);
  }


}