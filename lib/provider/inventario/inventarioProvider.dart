import 'package:flutter/cupertino.dart';
import 'package:flutter_teste_msql1/controle/InventarioCtrl.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/controle/UsuarioCtrl.dart';
import 'package:flutter_teste_msql1/modelo/Inventario.dart';

class InventarioProvider extends ChangeNotifier {
  PrincipalCtrl principalCtrl;
  List<Inventario> inventarios = [];

  InventarioProvider(this.principalCtrl);

  Future<List<Inventario>> listarInventarios() async {
    inventarios = await principalCtrl.inventarioCtrl.buscarListaInventarios();
    notifyListeners();
    return inventarios;
  }

  add(Inventario inventario) {
    inventarios.add(inventario);
    print(inventarios);
    notifyListeners();
  }

  remove(Inventario inventario) {
    inventarios.remove(inventario);
    notifyListeners();
  }

  Future<Inventario> lastInventario() async {
    inventarios = await principalCtrl.inventarioCtrl.buscarListaInventarios();
    return inventarios.last;
  }

  // salvar(InventarioCtrl inventarioCtrl) async {
  //   for (var element in inventarios) {
  //     await inventarioCtrl.salvarInventario(element);
  //   }
  // }

  Future<void> salvar(Inventario inventario) async {
    inventarios = await principalCtrl.inventarioCtrl.buscarListaInventarios();
    var contains = inventarios
        .where((element) => element.id == inventario.id); //VERIFICAR EXISTENCIA
    if (contains.isEmpty) {
      print("INVENTARIO - NAO CONTEM");
      await principalCtrl.inventarioCtrl.salvarInventario(Inventario.DAO(
        inventario.id,
        DateTime.now(),
        principalCtrl.usuarioCtrl.usuarioLogado,
      ));
    } else {
      print("INVENTARIO REPETIDO");
    }
    notifyListeners();
  }
}
