import 'package:flutter/material.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:provider/provider.dart';

import '../../components/clientes_tile.dart';
import '../../provider/clientes.dart';

//SEMPRE VERIFICAR MODELS CLIENT.DART, ou models Cliente.dart
class ListarClientes extends StatelessWidget {
  // const ({ Key? key }) : super(key: key);

  PrincipalCtrl principalCtrl;
  ListarClientes(this.principalCtrl);

  @override
  Widget build(BuildContext context) {
    final Clientes clientes = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Clientes",
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(
            onPressed: () {
              //  showSearch(context: context, delegate: SearchDelegate())
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
          itemCount: clientes.count,
          itemBuilder: (context, i) => ClienteTile(principalCtrl),
        ),
      ),
    );
  }
}
