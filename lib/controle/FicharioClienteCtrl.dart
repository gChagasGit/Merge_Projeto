import 'package:flutter_teste_msql1/controle/ClienteCtrl.dart';
import 'package:flutter_teste_msql1/controle/ItemVendaCtrl.dart';
import 'package:flutter_teste_msql1/controle/ProdutoCtrl.dart';
import 'package:flutter_teste_msql1/controle/UsuarioCtrl.dart';
import 'package:flutter_teste_msql1/controle/VendaCtrl.dart';

class FicharioClienteCtrl {
  late VendaCtrl _vendaCtrl;
  late ItemVendaCtrl _itemVendaCtrl;
  late UsuarioCtrl _usuarioCtrl;
  late ProdutoCtrl _produtoCtrl;
  late ClienteCtrl _clienteCtrl;

  FicharioClienteCtrl(
      VendaCtrl vendaCtrl,
      ItemVendaCtrl itemVendaCtrl,
      UsuarioCtrl usuarioCtrl,
      ProdutoCtrl produtoCtrl,
      ClienteCtrl clienteCtrl) {
    _vendaCtrl = vendaCtrl;
    _itemVendaCtrl = itemVendaCtrl;
    _usuarioCtrl = usuarioCtrl;
    _produtoCtrl = produtoCtrl;
    _clienteCtrl = clienteCtrl;
  }

  Future<void> buscarListaVendasPorCliente() async {
    _vendaCtrl.venda.cliente = _clienteCtrl.cliente;
    await _vendaCtrl.buscarListaVendasPorCliente(_clienteCtrl.cliente.id);

    for (var venda in _vendaCtrl.vendas) {
      await _usuarioCtrl.buscarUsuario(id: venda.usuario.id);
      venda.usuario = _usuarioCtrl.usuario;
      venda.cliente = _clienteCtrl.cliente;
    }
  }

  Future<void> buscarListaDeItensVendidosPorVenda() async {
    await _itemVendaCtrl
        .buscarListaDeItensVendidosPorVenda(_vendaCtrl.vendas.first.id);

    for (var item in _itemVendaCtrl.itensVendidos) {
      await _produtoCtrl.buscarProduto(id: item.produto.id);
      item.produto = _produtoCtrl.produto;
    }
  }

  void imprimirVendasDoCliente() {
    for (var venda in _vendaCtrl.vendas) {
      print("> $venda");
    }
  }

  void imprimirItensVendidosDeUmaVendaDoCliente() {
    for (var item in _itemVendaCtrl.itensVendidos) {
      print("> $item");
    }
  }
}
