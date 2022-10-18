import 'package:flutter/cupertino.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../modelo/Venda.dart';

class VendasProvider with ChangeNotifier {
  late PrincipalCtrl principalCtrl;

  Venda vendaSelecionada = Venda();
  List<Venda> listaVendas = [];

  VendasProvider(this.principalCtrl);

  Future<List<Venda>> carregarListaDeVendas({int? idCliente, PickerDateRange? range}) async {
    listaVendas.clear();
    if (idCliente == null) {
      listaVendas = await principalCtrl.vendaCtrl.buscarListaDeVendas(range: range);
    } else {
      listaVendas =
          await principalCtrl.vendaCtrl.buscarListaVendasPorCliente(idCliente, range: range);
    }
    notifyListeners();
    return listaVendas;
  }

  limpar() {
    vendaSelecionada = Venda();
    listaVendas.clear();
    notifyListeners();
  }
}
