// ignore_for_file: file_names, unnecessary_getters_setters, avoid_return_types_on_setters

class TipoPagamento {
  late int id;
  late String descricao;

  TipoPagamento() {
    id = 0;
    descricao = "";
  }

  TipoPagamento.DAO(this.id, this.descricao);

  TipoPagamento.novo({required int id, required String descricao});

  @override
  String toString() {
    // TODO: implement toString
    return "TipoPagamento: Id: $id, Descrição: $descricao";
  }
}
