import 'package:flutter/cupertino.dart';
import 'package:flutter_teste_msql1/controle/InventarioCtrl.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/controle/UsuarioCtrl.dart';
import 'package:flutter_teste_msql1/modelo/Inventario.dart';
import 'package:flutter_teste_msql1/modelo/RegistroEntrada.dart';

class RegistroEntradaProvider extends ChangeNotifier {
  PrincipalCtrl principalCtrl;
  List<RegistroEntrada> registrosEntrada = [];

  RegistroEntradaProvider(this.principalCtrl);

  Future<List<RegistroEntrada>> listarRegistrosEntrada() async {
    registrosEntrada =
        await principalCtrl.registroEntradaCtrl.buscarListaRegistroEntrada();
    notifyListeners();
    return registrosEntrada;
  }

  add(RegistroEntrada registroEntrada) {
    registrosEntrada.add(registroEntrada);
    print(registrosEntrada);
    notifyListeners();
  }

  remove(RegistroEntrada registroEntrada) {
    registrosEntrada.remove(registroEntrada);
    notifyListeners();
  }

  Future<RegistroEntrada> lastRegistroEntrada() async {
    registrosEntrada =
        await principalCtrl.registroEntradaCtrl.buscarListaRegistroEntrada();
    return registrosEntrada.last;
  }

  Future<void> salvar(RegistroEntrada registroEntrada) async {
    registrosEntrada =
        await principalCtrl.registroEntradaCtrl.buscarListaRegistroEntrada();
    var contains = registrosEntrada.where(
        (element) => element.id == registroEntrada.id); //VERIFICAR EXISTENCIA
    if (contains.isEmpty) {
      print("REGISTRO ENTRADA - NAO CONTEM");
      await principalCtrl.registroEntradaCtrl
          // registroEntrada.id,
          //   principalCtrl.usuarioCtrl.usuarioLogado,
          //   DateTime.now()
          .salvarRegistroEntrada(RegistroEntrada.DAO(registroEntrada.id,
              DateTime.now(), principalCtrl.usuarioCtrl.usuarioLogado));
    } else {
      print("REGISTRO ENTRADA - NAO CONTEM");
    }
    notifyListeners();
  }
}
