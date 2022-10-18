import 'package:flutter_teste_msql1/controle/ItemEntradaCtrl.dart';
import 'package:flutter_teste_msql1/controle/ProdutoCtrl.dart';
import 'package:flutter_teste_msql1/controle/RegistroEntradaCtrl.dart';
import 'package:flutter_teste_msql1/modelo/ItemEntrada.dart';

class ItemEntradaGUI {
  late ItemEntradaCtrl _itemEntradaCtrl;
  late RegistroEntradaCtrl _registroEntradaCtrl;
  late ProdutoCtrl _produtoCtrl;

  ItemEntradaGUI(ItemEntradaCtrl itemEntradaCtrl,
      RegistroEntradaCtrl registroEntradaCtrl, ProdutoCtrl produtoCtrl) {
    _itemEntradaCtrl = itemEntradaCtrl;
    _registroEntradaCtrl = registroEntradaCtrl;
    _produtoCtrl = produtoCtrl;
  }

  Future<void> simulaSalvarItemEntrada() async {
    ItemEntrada ie = ItemEntrada();

    await _produtoCtrl.buscarProduto(id: 10);
    ie.produto = _produtoCtrl.produto;

    ie.registroEntrada = _registroEntradaCtrl.registroEntrada;

    ie.quantidade = 6;

    _itemEntradaCtrl.itemEntrada = ie;

    // await _itemEntradaCtrl.salvaItemEntrada();
  }

  Future<void> buscarTodosOsItensEntrada() async {
    //implementar depois para selecionar o ultimo
    await _itemEntradaCtrl.buscarListaTodosOsItensEntrada().then((value) {
      print("> buscarTodosOsItensEntrada: ");

      for (ItemEntrada it in _itemEntradaCtrl.itensEntrada) {
        print(it);
      }
    });
  }
}
