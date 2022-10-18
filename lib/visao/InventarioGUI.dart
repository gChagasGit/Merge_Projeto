import 'package:flutter_teste_msql1/controle/InventarioCtrl.dart';
import 'package:flutter_teste_msql1/controle/UsuarioCtrl.dart';
import 'package:flutter_teste_msql1/modelo/Inventario.dart';

class InventarioGUI{

  late InventarioCtrl _inventarioCtrl;
  late UsuarioCtrl _usuarioCtrl;

  InventarioGUI(InventarioCtrl inventarioCtrl, UsuarioCtrl usuarioCtrl){
    _inventarioCtrl = inventarioCtrl;
    _usuarioCtrl = usuarioCtrl;
  }

  Future<void> simulaRealizacaoInventario() async {
    Inventario iv = Inventario();

    iv.dataHora = DateTime.now();

    //await _usuarioCtrl.simularAutenticacaoDeUsuario();
    iv.usuario = _usuarioCtrl.usuarioLogado;
    print("simulaRealizacaoInventario | iv.usuario: ${iv.usuario}");
    _inventarioCtrl.inventario = iv;

    //await _inventarioCtrl.salvarInventario();
    print("simulaRealizacaoInventario | ${_inventarioCtrl.inventario}");
  }
}