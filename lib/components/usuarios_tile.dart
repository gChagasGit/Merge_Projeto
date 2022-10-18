// VERSAO FUNCIONAL -- ADICIONAR(ENXUTA)
//TELA MOSTRAR CLIENTES

// ignore_for_file: prefer_const_constructors, avoid_print, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_teste_msql1/components/procurarUsuario.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/controle/UsuarioCtrl.dart';
import 'package:flutter_teste_msql1/modelo/Usuario.dart';
import 'package:flutter_teste_msql1/provider/usuarioProvider.dart';
import 'package:provider/provider.dart';
import 'package:number_paginator/number_paginator.dart';

class UsuarioTile extends StatefulWidget {
  // const ({ Key? key }) : super(key: key);
  PrincipalCtrl principalCtrl;
  late UsuarioCtrl _usuarioCtrl;
  UsuarioTile(this._usuarioCtrl, this.principalCtrl);

  @override
  State<UsuarioTile> createState() => _UsuarioTileState(principalCtrl);
}

class _UsuarioTileState extends State<UsuarioTile> {
  final NumberPaginatorController numberPaginatorController =
      NumberPaginatorController();
  UsuarioProvider? usuarioProvider;
  PrincipalCtrl principalCtrl;
  _UsuarioTileState(this.principalCtrl) {
    usuarioProvider = UsuarioProvider(principalCtrl);
  }

  @override
  Widget build(BuildContext context) {
    usuarioProvider!.contaQuantidadeDeUsuarios();
    final avatar = CircleAvatar(child: Icon(Icons.shopping_cart));
    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: FloatingActionButton(
          onPressed: () async {
            await principalCtrl.routeCadastrarUsuarios(context);
            setState(() {});
          },
          child: const Icon(Icons.add),
        ),
      ),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 110),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Usuários",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.right,
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(left: 900),
              child: IconButton(
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: ProcurarUsuario(principalCtrl));
                },
                color: Colors.white,
                icon: const Icon(Icons.search),
                iconSize: 30,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        // future: UsuarioProvider(principalCtrl).loadUsuarios(),
        future: usuarioProvider!.BuscarListaUsuarios(),
        builder: (BuildContext context, AsyncSnapshot<List<Usuario>> snapshot) {
          // List<Widget> children;
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.yellow.shade400,
              ),
            );
          }
          return Container(
            color: Colors.grey.shade300,
            margin: EdgeInsets.fromLTRB(80, 10, 80, 10), // externo
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
                      leading: avatar,
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
                                if (snapshot.data!.length != 2) {
                                  UsuarioProvider(principalCtrl)
                                      .remover(usuario.id);
                                  setState(() {});
                                } else {
                                  createAlertDialogUltimoUsuario(context);
                                }
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
        },
      ),
      bottomNavigationBar: Card(
        margin: EdgeInsets.fromLTRB(80, 0, 80, 0),
        // color: Colors.,
        child: NumberPaginator(
          controller: numberPaginatorController,
          config: NumberPaginatorUIConfig(
            height: 50,
            buttonSelectedForegroundColor: Colors.lightBlue,
            buttonUnselectedForegroundColor: Colors.lightBlue,
            buttonSelectedBackgroundColor: Colors.amber.shade300,
          ),
          // numberPages:
          // (usuarioProvider == null) ? usuarioProvider!.numPages : 1,
          numberPages: 1,
          // numberPages: 1,
          onPageChange: (int index) {
            usuarioProvider!.currentPage = index;
            setState(() {});
          },
        ),
      ),
    );
  }

  createAlertDialogUltimoUsuario(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              children: const [
                Text(
                    "Você não pode excluir quando tem apenas um usuário cadastrado!",
                    textAlign: TextAlign.center),
                Divider(),
                Text(
                  "*Clique fora da borda branca para fechar",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        });
  }
}
