import 'package:flutter/cupertino.dart';
import 'package:flutter_teste_msql1/controle/ItemVendaCtrl.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/modelo/ItemVenda.dart';

import '../../modelo/Produto.dart';
import '../../modelo/Venda.dart';

class ItensVendidosProvider extends ChangeNotifier {
  PrincipalCtrl principalCtrl;

  ItensVendidosProvider(this.principalCtrl);

  int idVendaSelecionada = 0;
  double valorTotalVenda = 0;
  late List<ItemVenda> itensVendidos = [];
  late Map<int, String> mapPeso = {};

  String _pesoString = '';

  Future<List<ItemVenda>> buscarListaDeItensVendidosPorVenda(
      int fkIdVenda) async {
    idVendaSelecionada = fkIdVenda;
    itensVendidos = await principalCtrl.itemVendaCtrl
        .buscarListaDeItensVendidosPorVenda(fkIdVenda);
    notifyListeners();
    return itensVendidos;
  }

  construirItemVenda(PrincipalCtrl principalCtrl,
      {String? codigo, Produto? produtoSelecionado}) async {
    Produto _produto = Produto();

    if (codigo![0] == '2') {
      codigo = _produtoPorPeso(codigo);
    }

    if (codigo != null) {
      await principalCtrl.produtoGUI
          .buscarDeProdutoPorCodigoDeBarras(codigo: codigo);
      _produto = principalCtrl.produtoCtrl.produto;
    } else {
      _produto = produtoSelecionado!;
    }
    if (principalCtrl.produtoCtrl.produtos.isNotEmpty) {
      if (_pesoString.isNotEmpty) {
        mapPeso = {_produto.id: _pesoString};
      }

      ItemVenda _itemVenda = ItemVenda();
      Venda _venda = principalCtrl.vendaCtrl.venda;
      _itemVenda.quantidadeVendida =
          (_pesoString.isEmpty) ? 1 : double.parse(mapPeso[_produto.id]!);
      _itemVenda.valorVendido = _produto.valorVenda;
      _itemVenda.produto = _produto;
      _itemVenda.venda = _venda;
      add(_itemVenda);

      _pesoString = '';
    }
  }

  String _produtoPorPeso(String cod) {
    String cod_id = cod.substring(1, 7);
    _pesoString = '${cod.substring(7, 9)}.${cod.substring(9, 12)}';
    return cod_id;
  }

  bool isProdutoJaAdicionado(String cod) {
    for (var element in itensVendidos) {
      if (element.produto.cod == cod) {
        print("> Produto já adicionado!");
        return true;
      }
    }
    return false;
  }

  add(ItemVenda itemVenda) {
    itensVendidos.add(itemVenda);
    valorTotalVenda += valorTotalDoItemVenda(itemVenda);
    print("Provider | add | ${itensVendidos.length}");
    notifyListeners();
  }

  removeObjeto(ItemVenda itemVenda) {
    valorTotalVenda -= valorTotalDoItemVenda(itemVenda);
    itensVendidos.remove(itemVenda);
    print("Provider | removeObjeto | ${itensVendidos.length}");
    notifyListeners();
  }

  atualizarItemVendido() {
    valorTotalVenda = 0;
    for (var element in itensVendidos) {
      valorTotalVenda += valorTotalDoItemVenda(element);
    }
    notifyListeners();
  }

  double valorTotalDoItemVenda(ItemVenda itemVenda) {
    return itemVenda.valorVendido * itemVenda.quantidadeVendida;
  }

  salvarItensVendidosNoBanco(ItemVendaCtrl itemVendaCtrl) async {
    for (var element in itensVendidos) {
      await itemVendaCtrl.salvaItemVenda(element);
    }
  }

  limpar() {
    idVendaSelecionada = 0;
    valorTotalVenda = 0;
    itensVendidos.clear();
    notifyListeners();
  }
}
