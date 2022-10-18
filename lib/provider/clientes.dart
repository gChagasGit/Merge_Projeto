import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../data/dammy_clientes.dart';
import '../modelo/Cliente.dart';

class Clientes with ChangeNotifier {
  final Map<String, Cliente> _items = {...DUMMY_CLIENTES};

  List<Cliente> get all {
    return [..._items.values];
  }

  int get count {
    return _items.length;
  }

  Cliente byIndex(int i) {
    return _items.values.elementAt(i);
  }

  //Metodo criar ou atualizar cliente
  void put(Cliente cliente) {
    if (cliente == null) {
      return;
    }

    if (cliente.id != null &&
        cliente.id.isNaN &&
        _items.containsKey(cliente.id)) {
      _items.update(cliente.id.toString(),
          (_) => cliente); //VERIFICAR SE NAO PRECISA CRIAR NOVO CLIENTE
    } else {
      //Adiciona o usuario
      final id = Random().nextDouble().toString();
      _items.putIfAbsent(
        id,
        () => Cliente.novo(
            id: 7,
            nome: "João",
            telefone: "1425369685",
            cpf: "95147863251025",
            diaPrevPag: 4,
            status: true),
      );
    }
    notifyListeners();
  } //fim do put

  void remove(Cliente cliente) {
    if (cliente != null && cliente.id != null) {
      _items.remove(cliente.id);
      notifyListeners();
    }
  }
}
