import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/modelo/Inventario.dart';
import 'package:flutter_teste_msql1/provider/inventario/inventarioProvider.dart';
import 'package:intl/intl.dart';

class HomeInventario extends StatefulWidget {
  PrincipalCtrl principalCtrl;
  // const MyWidget({super.key});

  HomeInventario(this.principalCtrl);

  @override
  State<HomeInventario> createState() => _HomeInventarioState();
}

class _HomeInventarioState extends State<HomeInventario> {
  String? dropValue;
  Inventario inventarioNovo = Inventario();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: FloatingActionButton.extended(
          onPressed: () async {
            await PrincipalCtrl().routeNovoInventario(context);
          },
          label: const Text("Novo inventário"),
          icon: const Icon(Icons.add),
        ),
      ),
      appBar: AppBar(
        title: Text("Inventário"),
      ),
      body: FutureBuilder<List<Inventario>>(
        future: InventarioProvider(widget.principalCtrl).listarInventarios(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Inventario>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.yellow.shade400,
              ),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(left: 400),
                color: Colors.grey.shade500,
                width: 500,
                height: 300,
                child: Align(
                  widthFactor: double.infinity,
                  heightFactor: 10,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 200),
                        child: DropdownButton(
                          dropdownColor: Colors.white,
                          iconEnabledColor: Colors.black,
                          hint: const Text("Selecione"),
                          value: dropValue,
                          onChanged: (novo) {
                            setState(() {
                              dropValue = novo.toString();
                              // inve = novo;
                              // print(inventario);
                            });
                          },
                          items: snapshot.data!
                              .map(
                                (inventario) => DropdownMenuItem<String>(
                                  value: inventario.dataHora.toString(),
                                  onTap: () {
                                    inventarioNovo = inventario;
                                  },
                                  child: Text(
                                      DateFormat("HH:mm dd/MM/yyyy")
                                          .format(inventario.dataHora),
                                      style: TextStyle(fontSize: 20)),
                                  // child: Text(DateFormat("HH:mm dd/MM/yyyy")
                                  //     .format(inventario.dataHora)),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(50, 0, 0, 0),
                            // color: Colors.amber,
                            width: 150,
                            height: 30,
                            child: ElevatedButton(
                              child: Text("Voltar"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(100, 0, 0, 0),
                            width: 150,
                            height: 30,
                            child: ElevatedButton(
                              child: Text("Acessar inventário"),
                              onPressed: () async {
                                // print(inventarioNovo.dataHora);
                                await PrincipalCtrl().routeAcessarInventario(
                                    context, inventarioNovo);
                                //PRECISA CRIAR UMA LISTA DE ITEMINVENTARIO PARA INVENTARIO,
                                // DESSA FORMA CONSIGO PASSAR UM MODALROUTE PARA ACESSARINVENTARIO
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
