import 'package:flutter_teste_msql1/dao/RegistroEntradaDAO.dart';
import 'package:flutter_teste_msql1/modelo/RegistroEntrada.dart';

class RegistroEntradaCtrl {
  late RegistroEntrada _registroEntrada;
  late List<RegistroEntrada> _registrosDeEntrada;
  late RegistroEntradaDAO _registroEntradaDAO;

  RegistroEntradaCtrl() {
    _registroEntrada = RegistroEntrada();
    _registrosDeEntrada = [];
    _registroEntradaDAO = RegistroEntradaDAO();
  }

  Future<void> salvarRegistroEntrada(RegistroEntrada registroEntrada) async {
    _registroEntrada.id = await _registroEntradaDAO.salvar(registroEntrada);
    registroEntrada.id = _registroEntrada.id;
  }

  Future<void> buscarRegistroEntradaPorId(int id) async {
    _registroEntrada = await _registroEntradaDAO.buscaPorId(id);
  }

  Future<List<RegistroEntrada>> buscarListaRegistroEntrada() async {
    await _registroEntradaDAO.buscarTodos().then((value) {
      _registrosDeEntrada.clear();
      _registrosDeEntrada.addAll(value);
    });
    return _registrosDeEntrada;
  }

  // Future<List<Inventario>> buscarListaInventarios() async {
  //   await _inventarioDAO.buscarTodos().then((value) {
  //     _inventarios.clear();
  //     _inventarios.addAll(value);
  //   });
  //   return _inventarios;
  // }

  Future<void> excluirRegistroEntrada() async {
    await _registroEntradaDAO.excluir(_registroEntrada);
  }

  void set registroEntrada(RegistroEntrada registroEntrada) {
    _registroEntrada = registroEntrada;
  }

  RegistroEntrada get registroEntrada => _registroEntrada;

  void set registrosEntrada(List<RegistroEntrada> registrosDeEntrada) {
    _registrosDeEntrada = registrosDeEntrada;
  }

  List<RegistroEntrada> get registrosDeEntrada => _registrosDeEntrada;
}
