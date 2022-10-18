import 'package:flutter_teste_msql1/modelo/Produto.dart';

import '../controle/ProdutoCtrl.dart';

class EstoqueGUI{

  late ProdutoCtrl _produtoCtrl;

  EstoqueGUI(ProdutoCtrl produtoCtrl){
    _produtoCtrl = produtoCtrl;
  }

  Future<void> simulaBuscarTodosProdutosAtivos() async {
    await _produtoCtrl.buscarTodosProdutos(ativo: true); //true para ativos
    _produtoCtrl.produtos.forEach((element) {
      print("> ${element}");
    });
  }

  Future<void> simulaBuscarPorEspecificacao(
      {int? id, String? cod, String? descricao}) async {
    await _produtoCtrl.buscarProduto(id: id, cod: cod, descricao: descricao);
  }

}