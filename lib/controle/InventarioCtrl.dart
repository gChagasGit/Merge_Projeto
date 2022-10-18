import 'package:flutter_teste_msql1/dao/InventarioDAO.dart';
import 'package:flutter_teste_msql1/modelo/Inventario.dart';

class InventarioCtrl {
  late Inventario _inventario;
  late List<Inventario> _inventarios;
  late InventarioDAO _inventarioDAO;

  InventarioCtrl() {
    _inventario = Inventario();
    _inventarios = [];
    _inventarioDAO = InventarioDAO();
  }

  Inventario get getInventario => _inventario;

  Future<void> salvarInventario(Inventario inventario) async {
    _inventario.id = await _inventarioDAO.salvar(inventario);
    inventario.id = _inventario.id;
  }

  Future<void> buscarInventarioPorId(int id) async {
    _inventario = await _inventarioDAO.buscaPorId(id);
  }

  Future<List<Inventario>> buscarListaInventarios() async {
    await _inventarioDAO.buscarTodos().then((value) {
      _inventarios.clear();
      _inventarios.addAll(value);
    });
    return _inventarios;
  }

  // Future<void> buscarListaInventarios() async {
  //   await _inventarioDAO.buscarTodos().then((value) {
  //     _inventarios.clear();
  //     _inventarios.addAll(value);
  //   });
  // }

  Future<void> excluirInventario() async {
    await _inventarioDAO.excluir(_inventario);
  }

  void set inventario(Inventario inventario) {
    _inventario = inventario;
  }

  Inventario get inventario => _inventario;

  void set inventarios(List<Inventario> inventarios) {
    _inventarios.addAll(inventarios);
  }

  List<Inventario> get inventarios => this._inventarios;
}
