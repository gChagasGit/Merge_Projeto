import 'package:flutter_teste_msql1/dao/ItemVendaDAO.dart';
import 'package:flutter_teste_msql1/modelo/ItemVenda.dart';

class ItemVendaCtrl {
  late ItemVenda _itemVenda;
  late List<ItemVenda> _itensVendidos;
  late ItemVendaDAO _itemVendaDAO;

  ItemVendaCtrl() {
    _itemVenda = ItemVenda();
    _itensVendidos = [];
    _itemVendaDAO = ItemVendaDAO();
  }

  void set itemVenda(ItemVenda itemVenda) {
    _itemVenda = itemVenda;
  }

  ItemVenda get itemVenda => _itemVenda;

  void set itensVendidos(List<ItemVenda> itensVendidos) {
    _itensVendidos.clear();
    _itensVendidos.addAll(itensVendidos);
  }

  List<ItemVenda> get itensVendidos => _itensVendidos;

  Future<void> salvaItemVenda(ItemVenda itemVenda) async {
    _itemVenda.id = await _itemVendaDAO.salvar(itemVenda);
    itemVenda.id = _itemVenda.id;
  }

  Future<void> buscarListaDeTodosOsItensVendidos() async {
    await _itemVendaDAO.buscarTodos().then((value) {
      _itensVendidos.clear();
      _itensVendidos.addAll(value);
    });
  }

  Future<List<ItemVenda>> buscarListaDeItensVendidosPorVenda(int fkIdVenda) async {
    await _itemVendaDAO.buscarTodos(fkIdVenda: fkIdVenda).then((value) {
      _itensVendidos.clear();
      _itensVendidos.addAll(value); 
    });
    return _itensVendidos;
  }

  Future<void> buscaItemVendaPorId(int id) async {
    _itemVenda = await _itemVendaDAO.buscaPorId(id);
  }
}
