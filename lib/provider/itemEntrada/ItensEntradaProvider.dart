import 'package:flutter/material.dart';
import 'package:flutter_teste_msql1/controle/ItemEntradaCtrl.dart';
import 'package:flutter_teste_msql1/controle/ItemInventarioCtrl.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/controle/UsuarioCtrl.dart';
import 'package:flutter_teste_msql1/modelo/Inventario.dart';
import 'package:flutter_teste_msql1/modelo/ItemEntrada.dart';
import 'package:flutter_teste_msql1/modelo/ItemInventario.dart';
import 'package:flutter_teste_msql1/modelo/Produto.dart';
import 'package:flutter_teste_msql1/modelo/RegistroEntrada.dart';
import 'package:flutter_teste_msql1/modelo/Usuario.dart';
import 'package:flutter_teste_msql1/provider/inventario/inventarioProvider.dart';
import 'package:flutter_teste_msql1/views/view_inventario/novoInventario.dart';

class ItensEntradaProvider extends ChangeNotifier {
  PrincipalCtrl principalCtrl;
  // double valorTotalVenda = 0;
  // Inventario novoInventario;
  ItensEntradaProvider(this.principalCtrl);
  final List<ItemEntrada> itensEntrada = [];
  bool status = false;

  construirItemEntrada(PrincipalCtrl principalCtrl,
      {String? codigo, String? descricao, Produto? produtoSelecionado}) async {
    Produto _produto = Produto();
    RegistroEntrada _registroEntrada = RegistroEntrada();
    if (codigo != null) {
      await principalCtrl.produtoCtrl.buscarProduto(cod: codigo);
      _produto = principalCtrl.produtoCtrl.produto;
    } else {
      _produto = produtoSelecionado!;
    }

    if (principalCtrl.produtoCtrl.produtos.isNotEmpty) {
      ItemEntrada _itemEntrada = ItemEntrada();
      _itemEntrada.produto = _produto;
      _itemEntrada.registroEntrada = _registroEntrada;

      add(_itemEntrada);
    }
  }

  add(ItemEntrada itemEscolhido) {
    itensEntrada.add(itemEscolhido);
    // valorTotalVenda += valorTotalDoItemVenda(itemVenda);
    print("Provider | add | ${itensEntrada.length}");
    notifyListeners();
  }

  removeObjeto(ItemEntrada itemEscolhido) {
    // valorTotalVenda -= valorTotalDoItemVenda(itemVenda);
    itensEntrada.remove(itemEscolhido);
    print("Provider | removeObjeto | ${itensEntrada.length}");
    notifyListeners();
  }

  salvarItensEntradaNoBanco(ItemEntradaCtrl itemEntradaCtrl,
      RegistroEntrada novoRegistroEntrada) async {
    // novoInventario = Inventario.DAO(novoInventario.id, DateTime.now(),
    //     principalCtrl.usuarioCtrl.usuarioLogado);

    for (var element in itensEntrada) {
      await itemEntradaCtrl.salvaItemEntrada(element);
    }
  }
}
