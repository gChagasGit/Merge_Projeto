import 'package:flutter/cupertino.dart';
import 'package:flutter_teste_msql1/modelo/ItemVenda.dart';

import '../../controle/PrincipalCtrl.dart';

class ItensVendidosProvider with ChangeNotifier{

  late PrincipalCtrl principalCtrl;
  
  List<ItemVenda> listaItensVendidos = [];

  ItensVendidosProvider(this.principalCtrl);

}