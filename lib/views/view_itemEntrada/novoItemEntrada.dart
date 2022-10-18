// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, no_leading_underscores_for_local_identifiers

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_teste_msql1/components/produtos_especificacao_pdv.dart';
import 'package:flutter_teste_msql1/components/snackBar_custom.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/controle/UsuarioCtrl.dart';
import 'package:flutter_teste_msql1/dao/ItemInventarioDAO.dart';
import 'package:flutter_teste_msql1/dao/ProdutoDAO.dart';
import 'package:flutter_teste_msql1/modelo/Inventario.dart';
import 'package:flutter_teste_msql1/modelo/ItemEntrada.dart';
import 'package:flutter_teste_msql1/modelo/Produto.dart';
import 'package:flutter_teste_msql1/modelo/RegistroEntrada.dart';
import 'package:flutter_teste_msql1/modelo/Usuario.dart';
import 'package:flutter_teste_msql1/provider/itemEntrada/ItensEntradaProvider.dart';
import 'package:flutter_teste_msql1/provider/itemEntrada/registroEntradaProvider.dart';
import 'package:flutter_teste_msql1/provider/produtoProvider.dart';
import 'package:flutter_teste_msql1/provider/usuarioProvider.dart';
import 'package:flutter_teste_msql1/views/view_pdv/frente_caixa.dart';
import 'package:provider/provider.dart';

class NovoItemEntrada extends StatefulWidget {
  PrincipalCtrl principalCtrl;

  NovoItemEntrada(this.principalCtrl);

  @override
  State<NovoItemEntrada> createState() => _NovoItemEntradaState(principalCtrl);
}

//-----------------------------------
late ItensEntradaProvider itensEntradaProvider;
late ProdutoProvider produtosProvider;
// late InventarioProvider inventarioProvider;
late RegistroEntradaProvider registroEntradaProvider;
RegistroEntrada registroEntradaNovo = RegistroEntrada();
late Usuario usuario;
// List<ItemInventario> itemInventarioNovo = [];
List<ItemEntrada> itemEntradaNovo = [];
bool temProduto = false;
final _pesquisaProdutoController = TextEditingController();

//---------------------------------------------
class _NovoItemEntradaState extends State<NovoItemEntrada> {
  PrincipalCtrl principalCtrl;

  _NovoItemEntradaState(this.principalCtrl);
  // const HomeInventario({super.key});

  @override
  Widget build(BuildContext context) {
    itensEntradaProvider = Provider.of<ItensEntradaProvider>(context);
    produtosProvider = Provider.of<ProdutoProvider>(context);
    registroEntradaProvider = Provider.of<RegistroEntradaProvider>(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
        // child: (itemInventarioNovo.isEmpty)
        //       ? Container()
        //       : ListViewComOsItensEscolhidos(valueProvider.itensInventario))
        child: (!temProduto)
            ? Container()
            : FloatingActionButton(
                onPressed: () async {
                  registroEntradaNovo.usuario =
                      principalCtrl.usuarioCtrl.usuarioLogado;
                  await registroEntradaProvider.salvar(
                      registroEntradaNovo); //MUDAR PARA O REGISTRO DE ENTRADA PROVIDER
                  //VERIFICAR AQUI
                  await itensEntradaProvider.salvarItensEntradaNoBanco(
                      principalCtrl.itemEntradaCtrl, registroEntradaNovo);

                  setState(() {});
                  _pesquisaProdutoController.clear();
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.check),
              ),
      ),
      appBar: AppBar(
        title: Text("Registro de entrada "),
      ),
      body: Center(
        child: Container(
          // width: 1200,
          width: double.infinity,
          height: 600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // FloatingActionButton(child: ("")onPressed: (){}),
              cabecalhoBuscaDoProduto(),
              cabecalhoListaProdutosAtuais(),
              listaProdutosAtuais(),
            ],
          ),
        ),
      ),
    );
  }

  cabecalhoListaProdutosAtuais() {
    return Material(
      elevation: 5.0,
      child: Container(
        padding: const EdgeInsets.all(8),
        color: Colors.black45,
        child: Row(
          children: const [
            SizedBox(width: 80),
            SizedBox(
                width: 500,
                child: Text('Descrição do produto',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.bold))),
            SizedBox(
                width: 40,
                child: Text('UN',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontWeight: FontWeight.bold))),
            SizedBox(
                width: 150,
                child: Text('CUSTO UN',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontWeight: FontWeight.bold))),
            SizedBox(
                width: 200,
                child: Text('Quantidade Mínima',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontWeight: FontWeight.bold))),
            SizedBox(
                width: 200,
                child: Text(
                    'Quantidade Entrada', //CUSTO E PREÇO DE VENDA, MUDAR BANCO
                    textAlign: TextAlign.end,
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }

  listaProdutosAtuais() {
    return Consumer<ItensEntradaProvider>(builder: (BuildContext context,
        ItensEntradaProvider valueProvider, Widget? child) {
      itensEntradaProvider = valueProvider;
      // itemInventarioNovo = valueProvider.itensInventario;
      return Expanded(
          child: (valueProvider.itensEntrada.isEmpty) //NUNCA TA FICANDO FALSO
              ? const Center(
                  child: Text(
                  "Nenhum produto adicionado!",
                  style: TextStyle(fontSize: 30),
                ))
              : ListViewComOsItensEscolhidos(valueProvider.itensEntrada));
      // : Container());
    });
  }

  ListViewComOsItensEscolhidos(List<ItemEntrada> itensEscolhidos) {
    var snackBar;
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: itensEscolhidos.length,
      itemBuilder: (BuildContext context, int index) {
        // final _valorVendidoController = TextEditingController();
        final _quantidadeEntrada =
            TextEditingController(); //QUANTIDADE Q FOI CONTADA
        ItemEntrada itemEntrada = itensEscolhidos.elementAt(index);
        return Container(
          height: 60,
          color: (index % 2 == 0) ? Colors.grey[300] : Colors.white24,
          //COMEÇO LINHA COM OS DADOS DO PRODUTO PUXADO
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //CAMPO ID
              const SizedBox(width: 20),
              SizedBox(width: 20, child: Text('${index + 1}')),
              //CAMPO DESCRICAO
              const SizedBox(width: 20),
              SizedBox(
                  width: 500,
                  child: ListTile(
                    title: Text(itemEntrada.produto.descricao),
                    subtitle: Text("Cod.: ${itemEntrada.produto.cod}"),
                  )),
              const SizedBox(width: 30),
              //CAMPO UNIDADE
              SizedBox(child: Text(itemEntrada.produto.unidade)),
              // const SizedBox(width: 5),
              // const SizedBox(width: 40, child: Text('UN')),
              const SizedBox(width: 100),
              //CAMPO QUANTIDADE ANTERIOR
              SizedBox(
                child: Text(
                  "R\$${itemEntrada.produto.valorCompra.toString()}",
                  textAlign: TextAlign.end,
                ),
              ),
              const SizedBox(width: 30),
              //CAMPO QUANTIDADE SOFTWARE(PRODUTO.QNTDATUAL)
              SizedBox(
                width: 120,
                child: Text(
                  (itemEntrada.produto.quantidadeAtual -
                          itemEntrada.produto.quantidadeMinima)
                      .toString(),
                  textAlign: TextAlign.end,
                ),
              ),
              const SizedBox(width: 120),
              //CAMPO QUANTIDADE REAL- itemInventario.quantidade
              SizedBox(
                width: 88,
                child: TextFormField(
                  controller: _quantidadeEntrada,
                  onEditingComplete: () async {
                    // PEGANDO REGISTRO ENTRADA
                    itemEntrada.registroEntrada =
                        principalCtrl.registroEntradaCtrl.registroEntrada;
                    // itemEntrada.registroEntrada.usuario = principalCtrl
                    //     .usuarioCtrl
                    //     .usuarioLogado; //VERIFICAR SE BUSCA CERTO(getInventario)
                    //Pegando a quantidade real
                    itemEntrada.quantidade =
                        double.parse(_quantidadeEntrada.text);

                    itemEntrada.produto.quantidadeAtual =
                        itemEntrada.produto.quantidadeAtual +
                            itemEntrada.quantidade;

                    // showCustomSnackbar(
                    //     context: context,
                    //     text:
                    //         "Quantidade do ${itemEntrada.produto.descricao} foi alterado de ${itemInventario.produto.quantidadeInventario} para ${itemInventario.produto.quantidadeAtual}.",
                    //     color: Colors.lightBlue);
                    setState(() {});
                    temProduto = true;
                    _quantidadeEntrada.clear();
                    await produtosProvider.salvar(itemEntrada.produto, context);
                  },
                ),
              ),
              const SizedBox(width: 80),
              IconButton(
                  onPressed: () {
                    itensEntradaProvider.removeObjeto(itemEntrada);
                  },
                  icon: const Icon(Icons.delete)),
            ],
          ),
        );
      },
    );
  }

  cabecalhoBuscaDoProduto() {
    return Container(
        margin: const EdgeInsets.only(right: 8),
        child: Row(
          children: [
            SizedBox(width: 20),
            Expanded(child: fieldPesquisaDoProduto()),
            SizedBox(height: 40, width: 250, child: botaoBuscarProduto()),
          ],
        ));
  }

  fieldPesquisaDoProduto() {
    return TextFormField(
      controller: _pesquisaProdutoController,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        labelText: "Digite o código do produto",
        prefixIcon: Icon(Icons.search),
        border: InputBorder.none,
      ),
      onEditingComplete: () async {
        String codigoDigitado = _pesquisaProdutoController.text;
        if (codigoDigitado.isNotEmpty) {
          await itensEntradaProvider.construirItemEntrada(principalCtrl,
              codigo: codigoDigitado);
        }
        _pesquisaProdutoController.clear();
      },
    );
  }

  buscarProdutoEspecificoPDV(
      BuildContext context, ProdutoProvider produtosProvider) async {
    await produtosProvider.loadProdutos();
    produtosProvider.produtoSelecionado = Produto();
    return await produtosEspecificacaoPDV(
        context, produtosProvider, Text("Identificar produto"));
  }

  botaoBuscarProduto() {
    //garente que vai atrelar a uma venda
    // if (principalCtrl.vendaCtrl.venda.id == 0) {
    //   criarObjetoDaVenda();
    // }

    return ElevatedButton.icon(
      icon: Icon(Icons.search),
      onPressed: () async {
        // String descricaoDigitada = _pesquisaProdutoController.text;
        await buscarProdutoEspecificoPDV(context, produtosProvider);
        if (produtosProvider.produtoSelecionado.id != 0) {
          await itensEntradaProvider.construirItemEntrada(principalCtrl,
              produtoSelecionado: produtosProvider.produtoSelecionado);
        }
        // if (descricaoDigitada.isNotEmpty) {
        //   await itensEntradaProvider.construirItemEntrada(principalCtrl,
        //       descricao: descricaoDigitada);
        // }
        // _limparControllersDosTextsFields();
      },
      label: const Text(
        "Buscar pelo nome",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}
