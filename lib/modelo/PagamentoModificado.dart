import 'package:flutter_teste_msql1/modelo/Pagamento.dart';

class PagamentoModificado {
  late int id;
  late DateTime data;
  late double novoValor;
  late double dinheiro;
  late double debito;
  late double credito;
  late double pix;
  late Pagamento pagamento;

  PagamentoModificado() {
    id = 0;
    data = DateTime(2000, 1, 1);
    novoValor = 0.0;
    dinheiro = 0.0;
    debito = 0.0;
    credito = 0.0;
    pix = 0.0;
    pagamento = Pagamento();
  }

  PagamentoModificado.DAO(this.id, this.data, this.novoValor, this.dinheiro,
      this.debito, this.credito, this.pix, this.pagamento);

  @override
  String toString() {
    return "PagamentoModificado: id: $id, data: $data, valor: ${novoValor.toStringAsFixed(2)}, dinheiro: ${dinheiro.toStringAsFixed(2)}, debito: ${debito.toStringAsFixed(2)}, credito: ${credito.toStringAsFixed(2)}, pix: ${pix.toStringAsFixed(2)}, pagamento.id: ${pagamento.id}";
  }
}
