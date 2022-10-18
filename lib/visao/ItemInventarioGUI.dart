import 'package:flutter_teste_msql1/controle/InventarioCtrl.dart';
import 'package:flutter_teste_msql1/controle/ItemInventarioCtrl.dart';
import 'package:flutter_teste_msql1/controle/ProdutoCtrl.dart';
import 'package:flutter_teste_msql1/modelo/ItemInventario.dart';
import 'package:flutter_teste_msql1/modelo/Produto.dart';

class ItemInventarioGUI {
  late InventarioCtrl _inventarioCtrl;
  late ItemInventarioCtrl _itemInventarioCtrl;
  late ProdutoCtrl _produtoCtrl;

  ItemInventarioGUI(InventarioCtrl inventarioCtrl,
      ItemInventarioCtrl itemInventarioCtrl, ProdutoCtrl produtoCtrl) {
    _inventarioCtrl = inventarioCtrl;
    _itemInventarioCtrl = itemInventarioCtrl;
    _produtoCtrl = produtoCtrl;
  }

  Future<void> simulaSalvarItemInventario() async {
    await _produtoCtrl.buscarProduto(id: 9);

    ItemInventario it = ItemInventario();

    it.inventario = _inventarioCtrl.inventario;
    it.produto = _produtoCtrl.produto;
    it.quantidade = 13;

    _itemInventarioCtrl.itemInventario = it;

    //await _itemInventarioCtrl.salvarItemInventario();
    print(
        "_simulaSalvarItemInventario | ${_itemInventarioCtrl.itemInventario}");
  }

  Future<void> simulaBuscaItensInventariados() async {
    await _itemInventarioCtrl.buscarListaDeTodosOsItensInventariados();

    for (ItemInventario it in _itemInventarioCtrl.itensInventariados) {
      await _inventarioCtrl.buscarInventarioPorId(it.inventario.id);

      it.inventario = _inventarioCtrl.inventario;

      await _produtoCtrl.buscarProduto(id: it.produto.id);

      it.produto = _produtoCtrl.produto;
    }

    _itemInventarioCtrl.itensInventariados.forEach((element) {
      print(element);
    });
  }
}
