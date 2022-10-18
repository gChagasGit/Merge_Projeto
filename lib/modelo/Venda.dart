// ignore_for_file: avoid_return_types_on_setters, file_names, unnecessary_getters_setters

import 'Caixa.dart';
import 'Cliente.dart';
import 'Usuario.dart';

class Venda {
  late int id;
  late double valor;
  late double desconto;
  late DateTime data;
  late Cliente cliente;
  late Usuario usuario;
  late Caixa caixa;

  Venda() {
    id = 0;
    valor = 0.0;
    desconto = 0.0;
    data = DateTime.now();
    cliente = Cliente();
    usuario = Usuario();
    caixa = Caixa();
  }

  Venda.DAO(this.id, this.valor, this.desconto, this.data, this.cliente, this.usuario, this.caixa);

  Venda.novo(
      {required int id,
      required double valor,
      required double desconto,
      required DateTime data,
      required Cliente cliente,
      required Usuario usuario,
      required Caixa caixa});

  @override
  String toString() {
    // TODO: implement toString
    return "Venda: Id: $id Valor: $valor, Desconto: $desconto, Data: ${data}, Usuário: ${usuario.nome}, Cliente: ${cliente.nome}, Caixa: ${caixa.id}";
  }
}
