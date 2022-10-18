// ignore_for_file: avoid_return_types_on_setters, unnecessary_getters_setters, file_names

class Produto {
  late int id;
  late String cod;
  late String descricao;
  late double valorCompra;
  late double valorVenda;
  late double quantidadeAtual;
  late double quantidadeMinima;
  late double quantidadeInventario;
  late String unidade;
  late bool status;
  late bool selecionado = false;
  // late int indice = 0;

  Produto() {
    id = 0;
    cod = "";
    descricao = "";
    valorCompra = 0.0;
    valorVenda = 0.0;
    quantidadeAtual = 0.0;
    quantidadeMinima = 0.0;
    quantidadeInventario = 0.0;
    unidade = "";
    status = false;
  }

  Produto.DAO(
      this.id,
      this.cod,
      this.descricao,
      this.valorCompra,
      this.valorVenda,
      this.quantidadeAtual,
      this.quantidadeMinima,
      this.quantidadeInventario,
      this.unidade,
      this.status);

  Produto.novo(
      {required int id,
      required String cod,
      required String descricao,
      required double valorCompra,
      required double valorVenda,
      required double quantidadeAtual,
      required double quantidadeMinima,
      double? quantidadeInventario = 0,
      required String unidade,
      required bool status});

  @override
  String toString() {
    // TODO: implement toString
    return "Produto: Cod.: $cod, Descrição: $descricao, Valor Venda: $valorVenda, Quant. Atual: $quantidadeAtual, Quant. Inventario: $quantidadeInventario";
  }
}
