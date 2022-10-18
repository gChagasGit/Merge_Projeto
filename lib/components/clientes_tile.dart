// VERSAO FUNCIONAL -- ADICIONAR(ENXUTA)
//TELA MOSTRAR CLIENTES

// ignore_for_file: prefer_const_constructors, avoid_print, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_teste_msql1/components/procurarCliente.dart';
import 'package:flutter_teste_msql1/controle/ClienteCtrl.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/modelo/Cliente.dart';
import 'package:flutter_teste_msql1/provider/clienteProvider.dart';
import 'package:flutter_teste_msql1/views/view_clientes/editarCliente.dart';
import 'package:provider/provider.dart';
import 'package:number_paginator/number_paginator.dart';

class ClienteTile extends StatefulWidget {
  // const ({ Key? key }) : super(key: key);
  PrincipalCtrl principalCtrl;
  ClienteTile(this.principalCtrl);

  @override
  State<ClienteTile> createState() => _ClienteTileState(principalCtrl);
}

class _ClienteTileState extends State<ClienteTile> {
  final NumberPaginatorController numberPaginatorController =
      NumberPaginatorController();

  ClienteProvider? clienteProvider;

  PrincipalCtrl principalCtrl;
  _ClienteTileState(this.principalCtrl) {
    clienteProvider = ClienteProvider(principalCtrl);
  }

  @override
  Widget build(BuildContext context) {
    // ClienteProvider clientes = Provider.of(context);
    clienteProvider!.contaQuantidadeDeClientes();
    final avatar = CircleAvatar(child: Icon(Icons.person));
    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: FloatingActionButton(
          onPressed: () async {
            await principalCtrl.routeCadastrarClientes(context);
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
                "Clientes",
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
                      delegate: ProcurarCliente(principalCtrl));
                  setState(() {});
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
        // future: ClienteProvider(principalCtrl).loadClientes(),
        future: clienteProvider!.BuscarListaClientes(),
        builder: (BuildContext context, AsyncSnapshot<List<Cliente>> snapshot) {
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
            padding: EdgeInsets.fromLTRB(30, 20, 0, 0), // interno
            child: SizedBox(
              // width: MediaQuery.of(context).size.width * 0.5,
              width: double.infinity,
              height: double.infinity,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, i) {
                  final Cliente cliente = snapshot.data![i];
                  if (cliente.id != 1) {
                    return ListTile(
                      leading: avatar,
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
                                  // await Navigator.of(context).pushNamed(
                                  //     '/editarCliente',
                                  //     arguments: cliente);

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
          numberPages:
              (clienteProvider == null) ? clienteProvider!.numPages : 1,
          // numberPages: 1,
          onPageChange: (int index) {
            clienteProvider!.currentPage = index;
            setState(() {});
          },
        ),
      ),
    );
  }
}
