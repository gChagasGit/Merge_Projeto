import 'package:flutter_teste_msql1/dao/ItemEntradaDAO.dart';
import 'package:flutter_teste_msql1/modelo/ItemEntrada.dart';

class ItemEntradaCtrl {
  late ItemEntrada _itemEntrada;
  late List<ItemEntrada> _itensEntrada;
  late ItemEntradaDAO _itemEntradaDAO;

  ItemEntradaCtrl() {
    _itemEntrada = ItemEntrada();
    _itensEntrada = [];
    _itemEntradaDAO = ItemEntradaDAO();
  }

  Future<void> salvaItemEntrada(ItemEntrada itemEntrada) async {
    _itemEntrada.id = await _itemEntradaDAO.salvar(itemEntrada);
    itemEntrada.id = _itemEntrada.id;
  }

  Future<void> buscarItemEntradaPorId(int id) async {
    _itemEntrada = await _itemEntradaDAO.buscaPorId(id);
  }

  Future<void> buscarListaTodosOsItensEntrada() async {
    itensEntrada = await _itemEntradaDAO.buscarTodos();
  }

  Future<List<ItemEntrada>> buscarListaItensEntradaPorRegistroEntrada(
      int fkIdRegistroEntrada) async {
    await _itemEntradaDAO
        .buscarTodos(fkIdRegistroEntrada: fkIdRegistroEntrada)
        .then((value) {
      _itensEntrada.clear();
      _itensEntrada.addAll(value);
    });
    print("BUSCADO" + _itensEntrada.toString());
    return _itensEntrada;
  }

  Future<void> excluirEntrada() async {
    await _itemEntradaDAO.excluir(_itemEntrada);
  }

  void set itemEntrada(ItemEntrada itemEntrada) {
    _itemEntrada = itemEntrada;
  }

  ItemEntrada get itemEntrada => _itemEntrada;

  void set itensEntrada(List<ItemEntrada> itensEntrada) {
    _itensEntrada = itensEntrada;
  }

  List<ItemEntrada> get itensEntrada => _itensEntrada;
}
