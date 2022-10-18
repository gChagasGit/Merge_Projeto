import 'package:flutter_teste_msql1/dao/ProdutoDAO.dart';

import '../modelo/Produto.dart';

class ProdutoCtrl {
  late Produto _produto;
  late List<Produto> _produtos;
  late ProdutoDAO _produtoDAO;

  ProdutoCtrl() {
    _produto = Produto();
    _produtos = [];
    _produtoDAO = ProdutoDAO();
  }

  void set produto(Produto produto) {
    _produto = produto;
  }

  Produto get produto => _produto;

  ProdutoDAO get produtoDAO => _produtoDAO;

  void set produtos(List<Produto> produtos) {
    _produtos.clear();
    _produtos.addAll(produtos);
  }

  List<Produto> get produtos => _produtos;

  void cadastrarProduto() {
    _produtoDAO.salvar(_produto);
  }

  Future<void> alterarProduto(Produto produto) async {
    _produto = produto;
    await _produtoDAO.alterar(produto);
  }

  Future<List<Produto>> buscarProduto(
      {int? id, String? cod, String? descricao}) async {
    if (id != null) {
      await _produtoDAO.buscaPorId(id).then((prod) {
        _produto = prod;
      });
      return [_produto];
    }
    if (cod != null || descricao != null) {
      print("buscarProduto | cod: $cod, descrição: $descricao");
      await _produtoDAO
          .buscarPorEspecificacao(cod: cod, descricao: descricao)
          .then((prods) {
        _produtos.clear();
        _produtos.addAll(prods);
      });
      (_produtos.isNotEmpty) ? _produto = _produtos.first : null;
    }
    return _produtos;
  }

  Future<List<Produto>> buscarTodosProdutos(
      {int? limite = 10, int? offset = 0, bool? ativo}) async {
    await _produtoDAO
        .buscarTodos(limite: limite, offset: offset, ativo: ativo)
        .then((value) {
      _produtos.clear();
      _produtos.addAll(value);
    });
    return _produtos;
  }

  Future<void> excluirProduto(Produto produto) async {
    _produto = produto;
    await _produtoDAO.excluir(produto);
  }
}
