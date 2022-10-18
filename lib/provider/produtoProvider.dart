// ignore_for_file: iterable_contains_unrelated_type, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_teste_msql1/components/snackBar_custom.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/controle/ProdutoCtrl.dart';
import 'package:flutter_teste_msql1/dao/ProdutoDAO.dart';
import 'package:flutter_teste_msql1/modelo/Produto.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ProdutoProvider with ChangeNotifier {
  List<Produto> listaDeProdutos = [];
  Produto produtoSelecionado = Produto();

  int numPages = 7;
  int currentPage = 0;
  int limite = 8;

  PrincipalCtrl principalCtrl;
  ProdutoCtrl produtoCtrl = ProdutoCtrl();

  ProdutoProvider(this.principalCtrl);

  Future<List<Produto>> BuscarListaProdutos() async {
    limpar();
    print("TAMANHO LISTA " + listaDeProdutos.length.toString());
    print("PAGINA ATUAL " + currentPage.toString());
    contaQuantidadeDeProdutos();

    await principalCtrl.produtoCtrl
        .buscarTodosProdutos(
            ativo: true, limite: limite, offset: (currentPage * limite))
        .then(
      (value) {
        listaDeProdutos.addAll(value);
      },
    );
    // listaDeProdutos.forEach((element) async {
    //   await principalCtrl.
    //  }
    //  )
    print("QUANTIDADE " + listaDeProdutos.length.toString());
    notifyListeners();
    return listaDeProdutos;
  }

  limpar() {
    produtoSelecionado = Produto();
    listaDeProdutos.clear();
    notifyListeners();
  }

  contaQuantidadeDeProdutos() async {
    int quant =
        await principalCtrl.produtoCtrl.produtoDAO.contaQuantidadeDeProdutos();
    numPages = (quant / limite).ceil();
    if (numPages == 0) {
      numPages = 1;
    }
  }

  Future<List<Produto>> loadProdutos({String? descricao}) async {
    if (descricao == null || descricao.isEmpty) {
      listaDeProdutos =
          await principalCtrl.produtoCtrl.buscarTodosProdutos(ativo: true);
    } else {
      listaDeProdutos =
          await principalCtrl.produtoCtrl.buscarProduto(descricao: descricao);
    }
    notifyListeners();
    return listaDeProdutos;
  }

  List<Produto> get produtos => listaDeProdutos;

  Future<int> salvar(Produto produto, BuildContext context) async {
    listaDeProdutos = await principalCtrl.produtoCtrl.buscarTodosProdutos();
    var contains = listaDeProdutos.where((element) => element.id == produto.id);
    var contemCodigo =
        listaDeProdutos.where((element) => element.cod == produto.cod);
    //Editar
    // var contemMudanca = _items.where((element) =>
    //     (element.descricao != produto.descricao ||
    //         element.quantidadeAtual != produto.quantidadeAtual ||
    //         element.quantidadeMinima != produto.quantidadeMinima ||
    //         element.unidade != produto.unidade ||
    //         element.valorCompra != produto.valorCompra ||
    //         element.valorVenda != produto.valorVenda));
    //Novo
    if (contains.isEmpty && contemCodigo.isEmpty) {
      print("NAO CONTEM");
      await ProdutoDAO().salvar(produto);
      return 0;
      //Editar
    } else if (contains.isNotEmpty &&
        contemCodigo.isNotEmpty &&
        (listaDeProdutos.contains(produto) ||
            contemCodigo.first.cod == produto.cod)) {
      print("CONTEM");
      print("${contemCodigo.first.cod} E ${produto.cod}");
      await principalCtrl.produtoCtrl.alterarProduto(produto);
      return 0;
      //nao tem id, tem codigo(NOVO com codigo repetido)
    } else if (contains.isEmpty && contemCodigo.isNotEmpty) {
      print("codigo repetido");
      showCustomSnackbar(
          context: context,
          text: "Já possui produto com esse código cadastrado",
          color: Colors.lightBlue);
      return 1;
      //Edicao(), id,
    } else if (contains.isNotEmpty && contemCodigo.isEmpty) {
      print("codsa");
      await principalCtrl.produtoCtrl.alterarProduto(produto);
      return 0;
    }
    print(contemCodigo.length);
    showCustomSnackbar(
        context: context,
        text: "Já possui produto com esdasse código cadastrado",
        color: Colors.lightBlue);
    return 1;
  }

  notifyListeners();

  void remover(int id) async {
    Produto produto =
        (await principalCtrl.produtoCtrl.buscarProduto(id: id)).first;
    principalCtrl.produtoCtrl.excluirProduto(produto);
    notifyListeners();
  }

  Future<void> atualizaProdutoSelecionado(Produto produto) async {
    produtoSelecionado = produto;
    notifyListeners();
  }
}
