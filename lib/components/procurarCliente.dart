// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_teste_msql1/controle/ClienteCtrl.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/dao/ClienteDAO.dart';
import '../modelo/Cliente.dart';
import '../provider/clienteProvider.dart';

class ProcurarCliente extends SearchDelegate {
  PrincipalCtrl principalCtrl;

  ProcurarCliente(this.principalCtrl) : super(searchFieldLabel: "Procurar");

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null); //ou Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: ClienteProvider(principalCtrl).loadClientes(nome: query),
      builder: (BuildContext context, AsyncSnapshot<List<Cliente>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.yellow.shade400,
            ),
          );
        }
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            color: Colors.grey.shade300,
            width: 1100,
            height: 550,
            margin: EdgeInsets.fromLTRB(80, 20, 0, 0),
            padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, i) {
                  final Cliente cliente = snapshot.data![i];
                  if (cliente.status) {
                    return ListTile(
                      leading: CircleAvatar(child: Icon(Icons.person)),
                      title: Row(
                        children: [
                          Text(
                            "${cliente.nome} | ",
                            style: TextStyle(fontSize: 17),
                          ),
                          Text(" CPF: ${cliente.cpf} | "),
                          Text(" TEL: ${cliente.telefone}"),
                        ],
                      ),
                      subtitle: Row(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Text(" DIA PAGAMENTO: ${cliente.diaPrevPag}"),
                        ],
                      ),
                      // dense: true,
                      trailing: Container(
                        width: 200,
                        margin: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: <Widget>[
                            IconButton(
                                onPressed: () async {
                                  await principalCtrl.routeEditarClientes(
                                      context, cliente);

                                  setState(() {});
                                },
                                icon: const Icon(Icons.edit),
                                color: Colors.orange,
                                iconSize: 28),
                            IconButton(
                              onPressed: () {
                                ClienteProvider(principalCtrl)
                                    .remover(cliente.id);
                                setState(() {});
                              },
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              iconSize: 28,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                  // print(cliente.nome);
                },
              ),
            ),
          );
        });
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text(""),
    );
  }
}
