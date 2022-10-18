import '../controle/ClienteCtrl.dart';
import '../modelo/Cliente.dart';

class ClienteGUI {
  
  late ClienteCtrl _clienteCtrl;

  ClienteGUI(ClienteCtrl clienteCtrl) {
    _clienteCtrl = clienteCtrl;
  }

  void simulaCadastroCliente() {

    _clienteCtrl.cliente.nome = "Cliente5";
    _clienteCtrl.cliente.telefone = "42999112233";
    _clienteCtrl.cliente.diaPrevPag = 5;
    _clienteCtrl.cliente.status = false;
    _clienteCtrl.cadastrarCliente(_clienteCtrl.cliente);
  }

  Future<void> simulaAlteracaoCliente() async {
    int i = _clienteCtrl.clientes.length;
    if (i == 0) {
      await _clienteCtrl.buscarTodosClientes();
    }
    i = _clienteCtrl.clientes.length - 1;
    _clienteCtrl.cliente = _clienteCtrl.clientes.elementAt(i);
    _clienteCtrl.cliente.status = false;
    //print("Usuário a ser atulizado: ${clienteCtrl.cliente}");
    _clienteCtrl.alterarCliente(_clienteCtrl.cliente);
  }

  Future<void> simulaBuscarTodosClientesAtivos() async {
    await _clienteCtrl.buscarTodosClientes();
    _clienteCtrl.clientes.forEach((element) {
      print(element);
    });
  }

  Future<void> simulaBuscarPorEspecificacao({int? id, String? nome}) async {
    await _clienteCtrl.buscarCliente(id: id, nome: nome);
  }
}
