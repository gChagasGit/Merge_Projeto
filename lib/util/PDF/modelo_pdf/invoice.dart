import 'package:flutter_teste_msql1/modelo/ItemVenda.dart';

import '../../../modelo/Pagamento.dart';
import '../../../modelo/PagamentoModificado.dart';
import 'client.dart';
import 'product.dart';

class Invoice {
  int id = 0;
  DateTime date = DateTime.now();
  Client client = Client(name: "", cpf: "");
  double total = 0.0;
  double troco = 0.0;
  // ---------------------- Venda ----------
  List<ItemVenda> itensVendidos = [];
  List<Pagamento> pagamentos = [];

  // ---------------------- A prazo -------- 
  //List<dynamic> pagamentosPrazo = [];
  PagamentoModificado pagamentoModificado = PagamentoModificado();
  double valorTotalAntigo = 0.0;

  Invoice({id, date, client, troco, itensVendidos, pagamentos, pagamentoModificado, valorTotalAntigo, total});
  
  @override
  String toString() {
    // TODO: implement toString
    return "Invoice | id: $id, Data: ${date.toString()}, Total: ${total.toStringAsFixed(2)}, itens: [${itensVendidos.length}], pagamentos: [${pagamentos.length}], [$pagamentoModificado]";
  }
}
