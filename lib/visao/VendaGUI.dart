import 'package:flutter_teste_msql1/controle/CaixaCtrl.dart';
import 'package:flutter_teste_msql1/controle/ClienteCtrl.dart';
import 'package:flutter_teste_msql1/controle/ItemVendaCtrl.dart';
import 'package:flutter_teste_msql1/controle/ProdutoCtrl.dart';
import 'package:flutter_teste_msql1/controle/UsuarioCtrl.dart';
import 'package:flutter_teste_msql1/controle/VendaCtrl.dart';
import 'package:flutter_teste_msql1/modelo/Cliente.dart';
import 'package:flutter_teste_msql1/modelo/ItemVenda.dart';
import 'package:flutter_teste_msql1/modelo/Venda.dart';

import '../modelo/Produto.dart';

class VendaGUI {
  late VendaCtrl _vendaCtrl;
  late ClienteCtrl _clienteCtrl;
  late UsuarioCtrl _usuarioCtrl;
  late ItemVendaCtrl _itemVendaCtrl;
  late CaixaCrtl _caixaCrtl;
  late ProdutoCtrl _produtoCtrl;

  VendaGUI(
      VendaCtrl vendaCtrl,
      ClienteCtrl clienteCtrl,
      UsuarioCtrl usuarioCtrl,
      ItemVendaCtrl itemVendaCtrl,
      CaixaCrtl caixaCrtl,
      ProdutoCtrl produtoCtrl) {
    _vendaCtrl = vendaCtrl;
    _clienteCtrl = clienteCtrl;
    _usuarioCtrl = usuarioCtrl;
    _itemVendaCtrl = itemVendaCtrl;
    _caixaCrtl = caixaCrtl;
    _produtoCtrl = produtoCtrl;
  }

  Future<void> criarVenda() async {
    Venda venda = Venda();

    venda.cliente = Cliente();

    venda.caixa = _caixaCrtl.caixa;
    venda.usuario = _usuarioCtrl.usuarioLogado;
    venda.data = DateTime.now();
    _vendaCtrl.venda = venda;
    
    await _vendaCtrl.salvarVenda();
    print("VendaGUI | criarVenda | ${venda.caixa} | ${venda.usuario}");
  }

  Future<void> _simulaCriarItensVendidos() async {
    ItemVenda iv;
    double valorFinalDaVenda = 0;

    for (int i = 0; i < 3; i++) {
      iv = ItemVenda();

      await _produtoCtrl.buscarProduto(id: 9 + i);

      iv.produto = _produtoCtrl.produto;
      iv.quantidadeVendida = 3 + i.toDouble();
      iv.valorVendido = _produtoCtrl.produto.valorVenda + (i.toDouble() / 10);
      valorFinalDaVenda += iv.valorVendido;

      iv.venda = _vendaCtrl.venda;

      _itemVendaCtrl.itemVenda = iv;
      //await _itemVendaCtrl.salvaItemVenda();
    }

    _vendaCtrl.venda.valor = valorFinalDaVenda;
    //await _vendaCtrl.atualizarVenda();
  }

  Future<void> buscarTodasAsVendas() async {
    await _vendaCtrl.buscarListaDeVendas();

    for (var venda in _vendaCtrl.vendas) {

      await _usuarioCtrl.buscarUsuario(id: venda.usuario.id);
      venda.usuario = _usuarioCtrl.usuario;

      await _clienteCtrl.buscarCliente(id: venda.cliente.id);
      venda.cliente = _clienteCtrl.cliente;
    
      print("> $venda");
    }
  }
}
