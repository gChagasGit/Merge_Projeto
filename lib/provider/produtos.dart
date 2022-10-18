import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../data/dammy_produtos.dart';
import '../modelo/Produto.dart';

class Produtos with ChangeNotifier {
  final Map<String, Produto> _items = {...DUMMY_PRODUTOS};

  List<Produto> get all {
    return [..._items.values];
  }

  int get count {
    return _items.length;
  }

  Produto byIndex(int i) {
    return _items.values.elementAt(i);
  }

  //Metodo criar ou atualizar cliente
  void put(Produto produto) {
    if (produto == null) {
      return;
    }

    if (produto.id != null && _items.containsKey(produto.id)) {
      _items.update(produto.id.toString(),
          (_) => produto); //VERIFICAR SE NAO PRECISA CRIAR NOVO CLIENTE
    } else {
      //Adiciona o usuario
      final id = Random().nextDouble().toInt();
      _items.putIfAbsent(
        id.toString(),
        () => Produto.novo(
            id: id,
            cod: produto.cod,
            descricao: produto.descricao,
            valorCompra: produto.valorCompra,
            valorVenda: produto.valorVenda,
            quantidadeAtual: produto.quantidadeAtual,
            quantidadeMinima: produto.quantidadeMinima,
            unidade: produto.unidade,
            status: produto.status),
      );
    }
    notifyListeners();
  } //fim do put

  void remove(Produto produto) {
    if (produto != null && produto.id != null) {
      _items.remove(produto.id);
      notifyListeners();
    }
  }
}
