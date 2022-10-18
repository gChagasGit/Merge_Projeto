import '../controle/ProdutoCtrl.dart';
import '../modelo/Produto.dart';

class ProdutoGUI {
  late ProdutoCtrl _produtoCtrl;

  ProdutoGUI(ProdutoCtrl produtoCtrl) {
    _produtoCtrl = produtoCtrl;
  }

  void simulaCadastroProduto() {
    Produto produto = Produto();
    produto.cod = "2299925";
    produto.descricao = "Descricao produto 5 marca 7 x unidade";
    produto.valorCompra = 17.85;
    produto.valorVenda = 22.88;
    produto.quantidadeAtual = 42;
    produto.quantidadeMinima = 24;
    produto.unidade = "UND.";
    produto.status = true;
    _produtoCtrl.produto = produto;
    _produtoCtrl.cadastrarProduto();
  }

  Future<void> simulaAlteracaoProduto() async {
    int i = _produtoCtrl.produtos.length;
    if (i == 0) {
      await _produtoCtrl.buscarTodosProdutos();
    }
    i = _produtoCtrl.produtos.length - 1;
    _produtoCtrl.produto = _produtoCtrl.produtos.elementAt(i);

    _produtoCtrl.produto.descricao =
        "Outra descricao produto 99 marca 55 quant unidade";
    _produtoCtrl.alterarProduto(_produtoCtrl.produto);
  }

  Future<void> simulaBuscarTodosOsProdutosAtivos() async {
    await _produtoCtrl.buscarTodosProdutos(ativo: true);
  }

  Future<void> simulaBuscarTodosOsProdutos() async {
    await _produtoCtrl.buscarTodosProdutos();
  }

  Future<void> simulaBuscarDeProdutoPorEspecificacao() async {
    String descricao = "prod";
    await _produtoCtrl.buscarProduto(descricao: descricao);
  }

  Future<void> buscarDeProdutoPorCodigoDeBarras(
      {required String codigo}) async {
    await _produtoCtrl
        .buscarProduto(cod: codigo);
  }

  void simulaExcluirProduto() {
    _produtoCtrl.excluirProduto(_produtoCtrl.produto);
  }
}
