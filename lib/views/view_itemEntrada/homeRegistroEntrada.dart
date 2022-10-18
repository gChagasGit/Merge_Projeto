import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/dao/RegistroEntradaDAO.dart';
import 'package:flutter_teste_msql1/modelo/RegistroEntrada.dart';
import 'package:flutter_teste_msql1/provider/itemEntrada/registroEntradaProvider.dart';
import 'package:intl/intl.dart';

class HomeRegistroEntrada extends StatefulWidget {
  PrincipalCtrl principalCtrl;
  // const MyWidget({super.key});

  HomeRegistroEntrada(this.principalCtrl);

  @override
  State<HomeRegistroEntrada> createState() => _HomeRegistroEntradaState();
}

class _HomeRegistroEntradaState extends State<HomeRegistroEntrada> {
  String? dropValue;
  RegistroEntrada registroEntradaNovo = RegistroEntrada();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: FloatingActionButton.extended(
          onPressed: () async {
            await PrincipalCtrl()
                .routeNovoRegistroEntrada(context); //arrumar route
          },
          label: const Text("Novo Registro de Entrada"),
          icon: const Icon(Icons.add),
        ),
      ),
      appBar: AppBar(
        title: Text("Registro de Entrada"),
      ),
      body: FutureBuilder<List<RegistroEntrada>>(
        // future: RegistroEntradaDAO().buscarTodos(),
        future: RegistroEntradaProvider(widget.principalCtrl)
            .listarRegistrosEntrada(),
        builder: (BuildContext context,
            AsyncSnapshot<List<RegistroEntrada>> snapshot) {
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
                                (registroEntrada) => DropdownMenuItem<String>(
                                  value: registroEntrada.dataHora.toString(),
                                  onTap: () {
                                    registroEntradaNovo = registroEntrada;
                                  },
                                  child: Text(
                                      DateFormat("HH:mm dd/MM/yyyy")
                                          .format(registroEntrada.dataHora),
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
                                setState(() {});
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(100, 0, 0, 0),
                            width: 170,
                            height: 30,
                            child: ElevatedButton(
                              child: Text("Acessar Registro"),
                              onPressed: () async {
                                // print(snapshot.data!.isNotEmpty);
                                // print(inventarioNovo.dataHora);
                                setState(() {});
                                await PrincipalCtrl()
                                    .routeAcessarRegistroEntrada(
                                        context, registroEntradaNovo);
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
