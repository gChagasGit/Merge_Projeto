// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_teste_msql1/components/snackBar_custom.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/controle/UsuarioCtrl.dart';
import 'package:flutter_teste_msql1/dao/ItemInventarioDAO.dart';
import 'package:flutter_teste_msql1/dao/ProdutoDAO.dart';
import 'package:flutter_teste_msql1/modelo/Inventario.dart';
import 'package:flutter_teste_msql1/modelo/ItemInventario.dart';
import 'package:flutter_teste_msql1/modelo/Usuario.dart';
import 'package:flutter_teste_msql1/provider/inventario/inventarioProvider.dart';
import 'package:flutter_teste_msql1/provider/inventario/itensInventarioProvider.dart';
import 'package:flutter_teste_msql1/provider/pdv/itensVendidosProvider.dart';
import 'package:flutter_teste_msql1/provider/produtoProvider.dart';
import 'package:flutter_teste_msql1/provider/usuarioProvider.dart';
import 'package:provider/provider.dart';

class NovoInventario extends StatefulWidget {
  PrincipalCtrl principalCtrl;

  NovoInventario(this.principalCtrl);

  @override
  State<NovoInventario> createState() => _NovoInventarioState(principalCtrl);
}

//-----------------------------------
late ItensInventarioProvider itensInventarioProvider;
late ProdutoProvider produtosProvider;
late InventarioProvider inventarioProvider;
late Inventario inventarioNovo = Inventario();
late Usuario usuario;
// List<ItemInventario> itemInventarioNovo = [];
bool temProduto = false;
final _pesquisaProdutoController = TextEditingController();

//---------------------------------------------
class _NovoInventarioState extends State<NovoInventario> {
  PrincipalCtrl principalCtrl;

  _NovoInventarioState(this.principalCtrl);
  // const HomeInventario({super.key});

  @override
  Widget build(BuildContext context) {
    itensInventarioProvider = Provider.of<ItensInventarioProvider>(context);
    produtosProvider = Provider.of<ProdutoProvider>(context);
    inventarioProvider = Provider.of<InventarioProvider>(context);
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
                  await inventarioProvider.salvar(inventarioNovo);
                  //VERIFICAR AQUI
                  await itensInventarioProvider.salvarItensInventarioNoBanco(
                      principalCtrl.itemInventarioCtrl, inventarioNovo);
                },
                child: const Icon(Icons.check),
              ),
      ),
      appBar: AppBar(
        title: Text("Cadastrar inventário"),
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
                width: 450,
                child: Text('Descrição do produto',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.bold))),
            SizedBox(
                width: 100,
                child: Text('UN',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontWeight: FontWeight.bold))),
            SizedBox(
                width: 160,
                child: Text('Quant. Anterior',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontWeight: FontWeight.bold))),
            SizedBox(
                width: 150,
                child: Text('Quant. Software',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontWeight: FontWeight.bold))),
            SizedBox(
                width: 150,
                child: Text('Quant. Real',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }

  listaProdutosAtuais() {
    return Consumer<ItensInventarioProvider>(builder: (BuildContext context,
        ItensInventarioProvider valueProvider, Widget? child) {
      itensInventarioProvider = valueProvider;
      // itemInventarioNovo = valueProvider.itensInventario;
      return Expanded(
          child: (valueProvider
                  .itensInventario.isEmpty) //NUNCA TA FICANDO FALSO
              ? const Center(
                  child: Text(
                  "Nenhum produto adicionado!",
                  style: TextStyle(fontSize: 30),
                ))
              : ListViewComOsItensEscolhidos(valueProvider.itensInventario));
      // : Container());
    });
  }

  ListViewComOsItensEscolhidos(List<ItemInventario> itensEscolhidos) {
    var snackBar;
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: itensEscolhidos.length,
      itemBuilder: (BuildContext context, int index) {
        // final _valorVendidoController = TextEditingController();
        final _quantidadeRealController =
            TextEditingController(); //QUANTIDADE Q FOI CONTADA
        ItemInventario itemInventario = itensEscolhidos.elementAt(index);
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
                  width: 450,
                  child: ListTile(
                    title: Text(itemInventario.produto.descricao),
                    subtitle: Text("Cod.: ${itemInventario.produto.cod}"),
                  )),
              const SizedBox(width: 100),
              //CAMPO UNIDADE
              SizedBox(child: Text(itemInventario.produto.unidade)),
              // const SizedBox(width: 5),
              // const SizedBox(width: 40, child: Text('UN')),
              const SizedBox(width: 100),
              //CAMPO QUANTIDADE ANTERIOR
              SizedBox(
                child: Text(
                    itemInventario.produto.quantidadeInventario.toString()),
              ),
              const SizedBox(width: 105),
              //CAMPO QUANTIDADE SOFTWARE(PRODUTO.QNTDATUAL)
              SizedBox(
                width: 50,
                child: Text(
                  itemInventario.produto.quantidadeAtual.toString(),
                  textAlign: TextAlign.end,
                ),
              ),
              const SizedBox(width: 110),
              //CAMPO QUANTIDADE REAL- itemInventario.quantidade
              SizedBox(
                  width: 80,
                  child: TextFormField(
                    controller: _quantidadeRealController,
                    onEditingComplete: () async {
                      // PEGANDO INVENTARIO
                      itemInventario.inventario =
                          principalCtrl.inventarioCtrl.getInventario;
                      //Pegando a quantidade real
                      itemInventario.quantidade =
                          double.parse(_quantidadeRealController.text);
                      //CRIAR VARIAVEL quantidadeInventario em produto no banco
                      //Setando a quantidade do produto no banco
                      itemInventario.produto.quantidadeInventario =
                          itemInventario.produto.quantidadeAtual;
                      itemInventario.produto.quantidadeAtual =
                          itemInventario.quantidade;

                      showCustomSnackbar(
                          context: context,
                          text:
                              "Quantidade do ${itemInventario.produto.descricao} foi alterado de ${itemInventario.produto.quantidadeInventario} para ${itemInventario.produto.quantidadeAtual}.",
                          color: Colors.lightBlue);
                      setState(() {});
                      temProduto = true;
                      await produtosProvider.salvar(
                          itemInventario.produto, context);
                    },
                  )),
              const SizedBox(width: 80),
              IconButton(
                  onPressed: () {
                    itensInventarioProvider.removeObjeto(itemInventario);
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
            SizedBox(height: 40, width: 200, child: botaoBuscarProduto()),
          ],
        ));
  }

  fieldPesquisaDoProduto() {
    return TextFormField(
      controller: _pesquisaProdutoController,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        labelText: "Pesquise o produto",
        prefixIcon: Icon(Icons.search),
        border: InputBorder.none,
      ),
    );
  }

  botaoBuscarProduto() {
    //garente que vai atrelar a uma venda
    // if (principalCtrl.vendaCtrl.venda.id == 0) {
    //   criarObjetoDaVenda();
    // }

    return ElevatedButton.icon(
      icon: Icon(Icons.search),
      onPressed: () async {
        String codigoDigitado = _pesquisaProdutoController.text;
        if (codigoDigitado.isNotEmpty) {
          await itensInventarioProvider.construirItemInventario(principalCtrl,
              codigo: codigoDigitado);
        }
        // _limparControllersDosTextsFields();
      },
      label: const Text(
        "Buscar produto",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}
// // ignore_for_file: prefer_const_constructors

// import 'dart:ffi';

// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
// import 'package:flutter_teste_msql1/dao/ItemInventarioDAO.dart';
// import 'package:flutter_teste_msql1/dao/ProdutoDAO.dart';
// import 'package:flutter_teste_msql1/modelo/Inventario.dart';
// import 'package:flutter_teste_msql1/modelo/ItemInventario.dart';
// import 'package:flutter_teste_msql1/modelo/Usuario.dart';
// import 'package:flutter_teste_msql1/provider/inventario/inventarioProvider.dart';
// import 'package:flutter_teste_msql1/provider/inventario/itensInventarioProvider.dart';
// import 'package:flutter_teste_msql1/provider/pdv/itensVendidosProvider.dart';
// import 'package:flutter_teste_msql1/provider/produtoProvider.dart';
// import 'package:flutter_teste_msql1/provider/usuarioProvider.dart';
// import 'package:provider/provider.dart';

// class NovoInventario extends StatefulWidget {
//   PrincipalCtrl principalCtrl;

//   NovoInventario(this.principalCtrl);

//   @override
//   State<NovoInventario> createState() => _NovoInventarioState(principalCtrl);
// }

// //-----------------------------------
// late ItensInventarioProvider itensInventarioProvider;
// late ProdutoProvider produtosProvider;
// late InventarioProvider inventarioProvider;
// late Inventario inventarioNovo = Inventario();
// late Usuario usuario;
// final _pesquisaProdutoController = TextEditingController();

// //---------------------------------------------
// class _NovoInventarioState extends State<NovoInventario> {
//   PrincipalCtrl principalCtrl;

//   _NovoInventarioState(this.principalCtrl);
//   // const HomeInventario({super.key});
//   @override
//   Widget build(BuildContext context) {
//     itensInventarioProvider = Provider.of<ItensInventarioProvider>(context);
//     produtosProvider = Provider.of<ProdutoProvider>(context);
//     inventarioProvider = Provider.of<InventarioProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Cadastrar inventário"),
//       ),
//       body: Container(
//         // width: 1200,
//         width: double.infinity,
//         height: 600,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             cabecalhoBuscaDoProduto(),
//             cabecalhoListaProdutosAtuais(),
//             listaProdutosAtuais(),
//           ],
//         ),
//       ),
//     );
//   }

//   cabecalhoListaProdutosAtuais() {
//     return Material(
//       elevation: 5.0,
//       child: Container(
//         padding: const EdgeInsets.all(8),
//         color: Colors.black45,
//         child: Row(
//           children: const [
//             SizedBox(width: 80),
//             SizedBox(
//                 width: 450,
//                 child: Text('Descrição do produto',
//                     textAlign: TextAlign.start,
//                     style: TextStyle(fontWeight: FontWeight.bold))),
//             SizedBox(
//                 width: 100,
//                 child: Text('UN',
//                     textAlign: TextAlign.end,
//                     style: TextStyle(fontWeight: FontWeight.bold))),
//             SizedBox(
//                 width: 160,
//                 child: Text('Quant. Anterior',
//                     textAlign: TextAlign.end,
//                     style: TextStyle(fontWeight: FontWeight.bold))),
//             SizedBox(
//                 width: 150,
//                 child: Text('Quant. Software',
//                     textAlign: TextAlign.end,
//                     style: TextStyle(fontWeight: FontWeight.bold))),
//             SizedBox(
//                 width: 150,
//                 child: Text('Quant. Real',
//                     textAlign: TextAlign.end,
//                     style: TextStyle(fontWeight: FontWeight.bold))),
//           ],
//         ),
//       ),
//     );
//   }

//   listaProdutosAtuais() {
//     return Consumer<ItensInventarioProvider>(builder: (BuildContext context,
//         ItensInventarioProvider valueProvider, Widget? child) {
//       itensInventarioProvider = valueProvider;
//       return Expanded(
//           child: (valueProvider
//                   .itensInventario.isEmpty) //NUNCA TA FICANDO FALSO
//               ? const Center(
//                   child: Text(
//                   "Nenhum produto adicionado!",
//                   style: TextStyle(fontSize: 30),
//                 ))
//               : ListViewComOsItensEscolhidos(valueProvider.itensInventario));
//       // : Container());
//     });
//   }

//   ListViewComOsItensEscolhidos(List<ItemInventario> itensEscolhidos) {
//     return ListView.builder(
//       padding: const EdgeInsets.all(8),
//       itemCount: itensEscolhidos.length,
//       itemBuilder: (BuildContext context, int index) {
//         // final _valorVendidoController = TextEditingController();
//         final _quantidadeRealController =
//             TextEditingController(); //QUANTIDADE Q FOI CONTADA
//         ItemInventario itemInventario = itensEscolhidos.elementAt(index);
//         return Container(
//           height: 60,
//           color: (index % 2 == 0) ? Colors.grey[300] : Colors.white24,
//           //COMEÇO LINHA COM OS DADOS DO PRODUTO PUXADO
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               //CAMPO ID
//               const SizedBox(width: 20),
//               SizedBox(width: 20, child: Text('${index + 1}')),
//               //CAMPO DESCRICAO
//               const SizedBox(width: 20),
//               SizedBox(
//                   width: 450,
//                   child: ListTile(
//                     title: Text(itemInventario.produto.descricao),
//                     subtitle: Text("Cod.: ${itemInventario.produto.cod}"),
//                   )),
//               const SizedBox(width: 100),
//               //CAMPO UNIDADE
//               SizedBox(child: Text(itemInventario.produto.unidade)),
//               // const SizedBox(width: 5),
//               // const SizedBox(width: 40, child: Text('UN')),
//               const SizedBox(width: 100),
//               //CAMPO QUANTIDADE ANTERIOR
//               SizedBox(
//                 child: Text("30"),
//               ),
//               const SizedBox(width: 105),
//               //CAMPO QUANTIDADE SOFTWARE(PRODUTO.QNTDATUAL)
//               SizedBox(
//                 width: 50,
//                 child: Text(
//                   itemInventario.produto.quantidadeAtual.toString(),
//                   textAlign: TextAlign.end,
//                 ),
//               ),
//               const SizedBox(width: 110),
//               //CAMPO QUANTIDADE REAL- itemInventario.quantidade
//               SizedBox(
//                   width: 80,
//                   child: TextFormField(
//                     controller: _quantidadeRealController,
//                     onEditingComplete: () async {
//                       itemInventario.inventario = inventarioNovo;
//                       itemInventario.quantidade =
//                           double.parse(_quantidadeRealController.text);
//                       itemInventario.produto.quantidadeAtual =
//                           itemInventario.quantidade;
//                       itemInventario.produto.quantidadeInventario = itemInventario
//                           .quantidade; //quantidadeInventario só atualiza nesse campo, criar no banco

//                       //VERIFICAR
//                       // await inventarioProvider.salvar(inventarioNovo);
//                       await itensInventarioProvider
//                           .salvarItensInventarioNoBanco(
//                               principalCtrl.itemInventarioCtrl, inventarioNovo);
//                       await produtosProvider
//                           .salvar(itemInventario.produto); //VERIFICAR
//                     },
//                   )),
//               const SizedBox(width: 80),
//               IconButton(
//                   onPressed: () {
//                     itensInventarioProvider.removeObjeto(itemInventario);
//                   },
//                   icon: const Icon(Icons.delete)),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   cabecalhoBuscaDoProduto() {
//     return Container(
//         margin: const EdgeInsets.only(right: 8),
//         child: Row(
//           children: [
//             SizedBox(width: 20),
//             Expanded(child: fieldPesquisaDoProduto()),
//             SizedBox(height: 40, width: 200, child: botaoBuscarProduto()),
//           ],
//         ));
//   }

//   fieldPesquisaDoProduto() {
//     return TextFormField(
//       controller: _pesquisaProdutoController,
//       keyboardType: TextInputType.text,
//       decoration: const InputDecoration(
//         labelText: "Pesquise o produto",
//         prefixIcon: Icon(Icons.search),
//         border: InputBorder.none,
//       ),
//     );
//   }

//   botaoBuscarProduto() {
//     //garente que vai atrelar a uma venda
//     // if (principalCtrl.vendaCtrl.venda.id == 0) {
//     //   criarObjetoDaVenda();
//     // }

//     return ElevatedButton.icon(
//       icon: Icon(Icons.search),
//       onPressed: () async {
//         String codigoDigitado = _pesquisaProdutoController.text;
//         if (codigoDigitado.isNotEmpty) {
//           await itensInventarioProvider.construirItemInventario(principalCtrl,
//               codigo: codigoDigitado);
//         }
//         // _limparControllersDosTextsFields();
//       },
//       label: const Text(
//         "Buscar produto",
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           fontSize: 18,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }

//   void inserirQuantidadeSoftware(
//       ItemInventario itemInventario, double quantSoftware) {
//     itemInventario.quantidade = quantSoftware;
//   }
// }
