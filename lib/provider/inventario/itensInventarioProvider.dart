import 'package:flutter/material.dart';
import 'package:flutter_teste_msql1/controle/ItemInventarioCtrl.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/controle/UsuarioCtrl.dart';
import 'package:flutter_teste_msql1/modelo/Inventario.dart';
import 'package:flutter_teste_msql1/modelo/ItemInventario.dart';
import 'package:flutter_teste_msql1/modelo/Produto.dart';
import 'package:flutter_teste_msql1/modelo/Usuario.dart';
import 'package:flutter_teste_msql1/provider/inventario/inventarioProvider.dart';
import 'package:flutter_teste_msql1/views/view_inventario/novoInventario.dart';

class ItensInventarioProvider extends ChangeNotifier {
  PrincipalCtrl principalCtrl;
  // double valorTotalVenda = 0;
  // Inventario novoInventario;
  ItensInventarioProvider(this.principalCtrl);
  final List<ItemInventario> itensInventario = [];
  bool status = false;

  construirItemInventario(PrincipalCtrl principalCtrl,
      {String? codigo, Produto? produtoSelecionado}) async {
    Produto _produto = Produto();
    Inventario _inventario = Inventario();
    if (codigo != null) {
      await principalCtrl.produtoGUI
          .buscarDeProdutoPorCodigoDeBarras(codigo: codigo);
      _produto = principalCtrl.produtoCtrl.produto;
    }
    // else {
    //   _produto = produtoSelecionado!;
    // }

    if (principalCtrl.produtoCtrl.produtos.isNotEmpty) {
      ItemInventario _itemInventario = ItemInventario();
      // Inventario _inventario = principalCtrl.inventarioCtrl.getInventario; //VERIFICAR
      _itemInventario.produto = _produto;
      _itemInventario.inventario = _inventario;
      //VERIFICAR COMO PUXAR INVENTARIO
      // _itemInventario.quantidadeAnterior =
      //     _itemInventario.produto.quantidadeInventario;
      // _itemInventario.quantidadeAnterior =
      //    VAI TER QUE VIM DO itemInvetario.quantidadeAnterior passado
      add(_itemInventario);
    }
  }

  add(ItemInventario itemEscolhido) {
    itensInventario.add(itemEscolhido);
    // valorTotalVenda += valorTotalDoItemVenda(itemVenda);
    print("Provider | add | ${itensInventario.length}");
    notifyListeners();
  }

  removeObjeto(ItemInventario itemEscolhido) {
    // valorTotalVenda -= valorTotalDoItemVenda(itemVenda);
    itensInventario.remove(itemEscolhido);
    print("Provider | removeObjeto | ${itensInventario.length}");
    notifyListeners();
  }

  salvarItensInventarioNoBanco(
      ItemInventarioCtrl itemInventarioCtrl, Inventario novoInventario) async {
    // novoInventario = Inventario.DAO(novoInventario.id, DateTime.now(),
    //     principalCtrl.usuarioCtrl.usuarioLogado);

    for (var element in itensInventario) {
      await itemInventarioCtrl.salvarItemInventario(element);
    }
  }
}
