import 'package:flutter/material.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:provider/provider.dart';

import '../../components/produtos_tile.dart';
import '../../provider/produtos.dart';

class ListarProdutos extends StatelessWidget {
  // const ({ Key? key }) : super(key: key);

  PrincipalCtrl principalCtrl;
  ListarProdutos(this.principalCtrl);

  @override
  Widget build(BuildContext context) {
    final Produtos produtos = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Produtos",
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/cad_produto");
            },
            color: Colors.white,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: ListView.builder(
          itemCount: produtos.count,
          itemBuilder: (context, i) => Container(),//ProdutoTile(principalCtrl),
        ),
      ),
    );
  }
}
