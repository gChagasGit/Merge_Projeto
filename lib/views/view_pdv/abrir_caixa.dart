// Abertura do caixa, data atual e valor no caixa

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:flutter_teste_msql1/controle/OpValoresCaixaCtrl.dart';
import 'package:flutter_teste_msql1/modelo/Caixa.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';

import '../../main.dart';

class AbrirCaixa extends StatelessWidget {
  // const ({ Key? key }) : super(key: key);

  AbrirCaixa(this.principalCtrl);

  PrincipalCtrl principalCtrl;

  final _valorAoAbrirCaixa = TextEditingController();
  // final _valorAoFecharCaixa = TextEditingController();
  // final _justificativaController = TextEditingController();

  bool _caixaEstaAberto = false;

  @override
  Widget build(BuildContext context) {
    _caixaEstaAberto = (principalCtrl.caixaCrtl.caixa.id != 0);
    print(">> build | $_caixaEstaAberto");
    if(_caixaEstaAberto){
      setState(){}
    }
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            margin: EdgeInsets.all(5),
            color: const Color.fromARGB(255, 209, 209, 209),
            child: SizedBox(
              height: 70,
              width: 400,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                    child: (!_caixaEstaAberto)
                        ? Text(
                            "Realize a abertura do caixa, insira o valor para o caixa ser aberto e clique no botão 'Confirmar'")
                        : Text(
                            "Caixa já aberto! Clique no botão 'Prosseguir'")),
              ),
            ),
          ),
          Container(
            width: 400,
            height: 300,
            color: const Color.fromARGB(255, 209, 209, 209),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 280,
                  height: 100,
                  child: Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      "Caixa ${_caixaEstaAberto ? "Aberto" : "Fechado"} \n${DateFormat("dd/MM/yyyy").format(DateTime.now())}",
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  width: 280,
                  height: 50,
                  child: TextFormField(
                    controller: _valorAoAbrirCaixa,
                    enabled: !_caixaEstaAberto,
                    autofocus: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CentavosInputFormatter()
                    ],
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefix: Text('R\$'),
                        hintText: (_caixaEstaAberto)? "":"  Valor para abrir o caixa",
                        prefixIcon: Icon(Icons.money)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        width: 120,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_caixaEstaAberto) {
                              principalCtrl.routeAbrirTela_FrenteCaixa(context);
                            } else if (_valorAoAbrirCaixa.text.isNotEmpty) {
                              double valor = double.parse(GetUtils.numericOnly(
                                      _valorAoAbrirCaixa.text)) /
                                  100;
                              // valor = _converterTextoEmDouble(_valorAoAbrirCaixa.text);
    
                              bool caixaFoiAberto = false;
                              caixaFoiAberto = await principalCtrl
                                  .aberturaCaixaGUI
                                  .abrirCaixa(valor: valor);
                              if (caixaFoiAberto) {
                                _caixaEstaAberto = true;
                                limpar();
                                principalCtrl
                                    .routeAbrirTela_FrenteCaixa(context);
                              }
                            }else{
                              await createAlertDialogValorVazio(context);
                            }
                          },
                          child: Text(
                            _caixaEstaAberto ? "Prosseguir" : "Confirmar",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        width: 120,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            limpar();
                          },
                          // style:, VERIFICAR
                          child: const Text(
                            "Cancelar",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  double _converterTextoEmDouble(String texto) {
    //String texto = _valorController.text;
    if (texto.isNotEmpty) {
      if (texto.contains('.') || texto.contains(',')) {
        texto = texto.replaceAll('.', ',').replaceAll(',', '.');
      } else {
        return double.parse(texto);
      }
      return double.parse(texto);
    }
    return 0;
  }

  createAlertDialogValorVazio(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              children: [
                const Text("Valor inserido está vazio!",
                    textAlign: TextAlign.center),
                Divider(),
                const Text(
                  "*Clique fora da borda branca para fechar",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        });
  }

  limpar() {
    _valorAoAbrirCaixa.clear();
  }
}
