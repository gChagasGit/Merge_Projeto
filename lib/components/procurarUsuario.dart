// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/controle/UsuarioCtrl.dart';
import 'package:flutter_teste_msql1/modelo/Usuario.dart';
import 'package:flutter_teste_msql1/provider/usuarioProvider.dart';

class ProcurarUsuario extends SearchDelegate {
  PrincipalCtrl principalCtrl;

  ProcurarUsuario(this.principalCtrl) : super(searchFieldLabel: "Procurar");

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
      future: UsuarioProvider(principalCtrl).loadUsuarios(nome: query),
      builder: (BuildContext context, AsyncSnapshot<List<Usuario>> snapshot) {
        List<Widget> children;
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
            width: 1100,
            color: Colors.grey.shade300,
            margin: EdgeInsets.fromLTRB(80, 20, 0, 0),
            padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
            child: SizedBox(
              // width: MediaQuery.of(context).size.width * 0.5,
              width: double.infinity,
              height: double.infinity,
              child: ListView.builder(
                shrinkWrap: true,
                // itemCount: clientes.count,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, i) {
                  final Usuario usuario = snapshot.data![i];
                  if (usuario.status) {
                    return ListTile(
                      leading: CircleAvatar(child: Icon(Icons.shopping_cart)),
                      title: Row(
                        children: [
                          Text(
                            "${usuario.nome} | ",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text("CPF: ${usuario.cpf}",
                              style: TextStyle(fontSize: 14)),
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
                                  await principalCtrl.routeEditarUsuarios(
                                      context, usuario);

                                  setState(() {});
                                },
                                icon: const Icon(Icons.edit),
                                color: Colors.orange,
                                iconSize: 28),
                            IconButton(
                              onPressed: () {
                                UsuarioProvider(principalCtrl)
                                    .remover(usuario.id);
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
