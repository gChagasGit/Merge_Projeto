import 'package:flutter_teste_msql1/dao/ClienteDAO.dart';
import 'package:flutter_teste_msql1/modelo/Cliente.dart';

class ClienteCtrl {
  late Cliente _cliente;
  late List<Cliente> _clientes;
  late ClienteDAO _clienteDAO;

  ClienteCtrl() {
    _cliente = Cliente();
    _clientes = [];
    _clienteDAO = ClienteDAO();
  }

  void set cliente(Cliente cliente) {
    _cliente = cliente;
  }

  Cliente get cliente => _cliente;

  List<Cliente> get clientes => _clientes;

  // Future<List<Cliente>> buscarTodosOsClientes(
  //     {int? limite = 10, int? offset = 0}) async {
  //   await _clienteDAO.buscarTodos(limite: limite, offset: offset).then((value) {
  //     _clientes.clear();
  //     _clientes.addAll(value);
  //   });
  //   return _clientes;
  // }

  Future<void> cadastrarCliente(Cliente cliente) async {
    _cliente = cliente;
    _cliente.id = await _clienteDAO.salvar(cliente);
  }

  Future<void> alterarCliente(Cliente cliente) async {
    _cliente = cliente;
    await _clienteDAO.alterar(_cliente);
  }

  Future<List<Cliente>> buscarCliente({int? id, String? nome}) async {
    if (id != null) {
      await _clienteDAO.buscaPorId(id).then((user) {
        _cliente = user;
      });
      return [_cliente];
    }
    if (nome != null) {
      await _clienteDAO.buscarPorEspecificacao(nome: nome).then((users) {
        _clientes.clear();
        _clientes.addAll(users);
      });
    }
    return _clientes;
  }

  Future<List<Cliente>> buscarTodosClientes(
      {int? limite = 10, int? offset = 0, bool? ativo}) async {
    await _clienteDAO
        .buscarTodos(limite: limite, offset: offset, ativo: ativo)
        .then((value) {
      _clientes.clear();
      _clientes.addAll(value);
    });
    return _clientes;
  }

  ClienteDAO get clienteDAO => _clienteDAO;

  void excluirCliente(Cliente cliente) async {
    _cliente = cliente;
    await _clienteDAO.excluir(cliente);
  }
}
