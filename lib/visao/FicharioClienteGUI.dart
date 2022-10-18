import 'package:flutter_teste_msql1/controle/FicharioClienteCtrl.dart';

class FicharioClienteGUI{

  late FicharioClienteCtrl _ficharioClienteCtrl;

  FicharioClienteGUI(FicharioClienteCtrl ficharioClienteCtrl){
    _ficharioClienteCtrl = ficharioClienteCtrl;
  }

  Future<void> simulaBuscarListaVendasPorCliente() async {
    await _ficharioClienteCtrl.buscarListaVendasPorCliente();
  }

  Future<void> simulaBuscarListaDeItensVendidosPorVenda() async {
    await _ficharioClienteCtrl.buscarListaDeItensVendidosPorVenda();
  }

  void imprimirVendasDoCliente(){
    _ficharioClienteCtrl.imprimirVendasDoCliente();
  }

  void imprimirItensVendidosDeUmaVendaDoCliente(){
    _ficharioClienteCtrl.imprimirItensVendidosDeUmaVendaDoCliente();
  }

}