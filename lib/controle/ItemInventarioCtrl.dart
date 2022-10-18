import 'package:flutter_teste_msql1/dao/ItemInventarioDAO.dart';
import 'package:flutter_teste_msql1/modelo/ItemInventario.dart';

class ItemInventarioCtrl {
  late ItemInventario _itemInventario;
  late List<ItemInventario> _itensInventariados;
  late ItemInventarioDAO _itemInventarioDAO;

  ItemInventarioCtrl() {
    _itemInventario = ItemInventario();
    _itensInventariados = [];
    _itemInventarioDAO = ItemInventarioDAO();
  }

  Future<void> salvarItemInventario(ItemInventario itemInventario) async {
    _itemInventario.id = await _itemInventarioDAO.salvar(itemInventario);
    itemInventario.id = _itemInventario.id;
  }

  Future<void> buscarItemInventarioPorId(int id) async {
    _itemInventario = await _itemInventarioDAO.buscaPorId(id);
  }

  Future<void> buscarListaDeTodosOsItensInventariados() async {
    await _itemInventarioDAO.buscarTodos().then((value) {
      _itensInventariados.clear();
      _itensInventariados.addAll(value);
    });
  }

  Future<List<ItemInventario>> buscarListaItensInventariadosPorInventario(
      int fkIdInventario) async {
    await _itemInventarioDAO
        .buscarTodos(fkIdInventario: fkIdInventario)
        .then((value) {
      _itensInventariados.clear();
      _itensInventariados.addAll(value);
    });
    return _itensInventariados;
  }

  Future<void> excluirItemInventario() async {
    await _itemInventarioDAO.excluir(_itemInventario);
  }

  ItemInventario get itemInventario => _itemInventario;

  void set itemInventario(ItemInventario itemInventario) {
    _itemInventario = itemInventario;
  }

  List<ItemInventario> get itensInventariados => _itensInventariados;

  void set itensInventariados(List<ItemInventario> itensInventariados) {
    _itensInventariados.clear();
    _itensInventariados.addAll(itensInventariados);
  }
}
