// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

//--------------------------------------CADASTRAR CLIENTE-----------------------------------------

// import 'dart:ffi';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/services.dart';
import 'package:flutter_teste_msql1/components/snackBar_custom.dart';
import 'package:flutter_teste_msql1/controle/ProdutoCtrl.dart';
import 'package:flutter_teste_msql1/modelo/Produto.dart';
import 'package:flutter_teste_msql1/provider/produtoProvider.dart';
import 'package:brasil_fields/brasil_fields.dart';

import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

class EditarProduto extends StatefulWidget {
  // final Cliente clienteTeste = Cliente.c();
  late ProdutoCtrl? _produtoCtrl;
  EditarProduto({ProdutoCtrl? produtoCtrl}) {
    _produtoCtrl = produtoCtrl;
  }

  @override
  State<EditarProduto> createState() => _EditarProdutoState();
}

class _EditarProdutoState extends State<EditarProduto> {
  late ProdutoProvider produtoProvider;
  final _form = GlobalKey<FormState>();
  final _id = TextEditingController();
  final _cod = TextEditingController();
  final _descricao = TextEditingController();
  final _valorCompra = TextEditingController();
  final _valorVenda = TextEditingController();
  final _quantidadeAtual = TextEditingController();
  final _quantidadeMinima = TextEditingController();
  final _unidade = TextEditingController();
  final _status = TextEditingController();
  String? unidadeProduto;

  // @override
  // void initState() {
  //   super.initState();
  //   // _nome.text = widget.clienteTeste.nome;
  //   clienteProvider = Provider.of<ClienteProvider>(context, listen: false);
  // }

  Widget fieldDesc() {
    return TextFormField(
      controller: _descricao,
      style: TextStyle(fontSize: 17),
      keyboardType: TextInputType.name,
      // inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
      validator: (value) {
        if (value!.isEmpty) {
          return "Informe a descrição";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Descrição:",
        hintText: "Leite Tirol 1L",
        // prefixIcon: Icon(Icons.food_bank_outlined),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget fieldQtndAt() {
    final regExp = RegExp(r'[a-zA-Z ]$');
    return TextFormField(
      controller: _quantidadeAtual,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*.([0-9][0-9]?)?'))
      ],
      validator: (value) {
        if (value!.isEmpty) {
          return "Informe a quantidade no estoque";
        }

        // if (double.parse(value) < 0 || double.parse(value) > 5000) {
        //   return "Quantidade incorreta";
        // }

        if (value.toString().contains(
              regExp,
            )) {
          return "Não é permitido letra";
        }

        return null;
      },
      decoration: const InputDecoration(
        labelText: "Quantidade atual:",
        hintText: "100",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget fieldQtndMin() {
    final regExp = RegExp(r'[a-zA-Z ]$');
    return TextFormField(
      controller: _quantidadeMinima,
      keyboardType: TextInputType.number,
      // inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*.([0-9][0-9]?)?'))
      ],

      validator: (value) {
        if (value!.isEmpty) {
          return "Informe a quantidade minima";
        }

        if (value.toString().contains(
              regExp,
            )) {
          return "Não é permitido letra";
        }

        return null;
      },
      decoration: const InputDecoration(
        labelText: "Quantidade mín:",
        hintText: "100",
        border: OutlineInputBorder(),
      ),
    );
  }

  // Widget fieldUnid(BuildContext context) {
  //   return TextFormField(
  //     controller: _unidade,
  //     // keyboardType: TextInputType.number,
  //     inputFormatters: [
  //       // FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z ]*$'))
  //     ],
  //     validator: (value) {
  //       if (value!.isEmpty) {
  //         return "Informe a unidade";
  //       }
  //       // if (value.length > 4){
  //       //   return ""
  //       // }
  //       return null;
  //     },
  //     // onTap: cadastrarUnidade(context),
  //     decoration: const InputDecoration(
  //       // prefixIcon: Icon(Icons.production_quantity_limits),
  //       labelText: "UN:",
  //       hintText: "kg",
  //       border: OutlineInputBorder(),
  //     ),
  //   );
  // }

  Widget fieldCodigo() {
    return TextFormField(
      controller: _cod,
      // keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(
            r'^([0-9]?[0-9]?[0-9]?[0-9]?[0-9]?[0-9]?[0-9]?[0-9]?[0-9]?[0-9]?[0-9]?[0-9]?[0-9])'))
      ],
      validator: (value) {
        if (value!.isEmpty) {
          return "Informe o código";
        }
        if (value.length != 13) {
          return "Código incompleto";
        }

        print(value.length);
        return null;
      },
      decoration: const InputDecoration(
        // prefixIcon: Icon(Icons.production_quantity_limits),
        labelText: "Código de barras:",
        hintText: "7899999912349",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget fieldValorC() {
    final regExp = RegExp(r'[a-zA-Z ]$');
    return TextFormField(
      controller: _valorCompra,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*.([0-9][0-9]?)?'))
      ],
      validator: (value) {
        if (value!.isEmpty) {
          return "Informe o valor de compra";
        }

        if (value.toString().contains(
              regExp,
            )) {
          return "Não é permitido letra";
        }

        return null;
      },
      decoration: const InputDecoration(
        labelText: "Valor de compra:",
        hintText: "20",
        prefixIcon: Icon(Icons.monetization_on),
        border: OutlineInputBorder(),
        suffixText: "reais",
      ),
    );
  }

  Widget fieldValorV() {
    final regExp = RegExp(r'[a-zA-Z ]$');
    return TextFormField(
      controller: _valorVenda,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*.([0-9][0-9]?)?'))
      ],
      validator: (value) {
        if (value!.isEmpty) {
          return "Informe o valor de venda";
        }
        if (value.toString().contains(
              regExp,
            )) {
          return "Não é permitido letra";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Valor de venda:",
        hintText: "20",
        prefixIcon: Icon(Icons.monetization_on),
        border: OutlineInputBorder(),
        suffixText: "reais",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var snackBar;
    Produto produtoM = ModalRoute.of(context)!.settings.arguments as Produto;
    _id.text = produtoM.id.toString();
    _cod.text = produtoM.cod;
    _descricao.text = produtoM.descricao;
    _valorCompra.text = produtoM.valorCompra.toString();
    _valorVenda.text = produtoM.valorVenda.toString();
    _quantidadeAtual.text = produtoM.quantidadeAtual.toString();
    _quantidadeMinima.text = produtoM.quantidadeMinima.toString();
    _unidade.text = produtoM.unidade;
    unidadeProduto = produtoM.unidade;
    _status.text = produtoM.status.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Editar Produto",
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.help),
          )
        ],
      ),
      body: Form(
        key: _form,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 65,
                  width: 415,
                  margin: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.355, 70, 20, 20),
                  child: fieldDesc(),
                ),
              ],
            ),
            Row(children: [
              Container(
                height: 65,
                width: 150,
                margin: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.355, 10, 20, 0),
                child: fieldQtndAt(),
              ),
              Container(
                height: 65,
                width: 150,
                margin: EdgeInsets.fromLTRB(0, 10, 20, 0),
                child: fieldQtndMin(),
              ),
              Container(
                height: 65,
                width: 80,
                margin: EdgeInsets.fromLTRB(0, 10, 20, 10),
                child: cadastrarUnidade(context),
              ),
            ]),
            Row(
              children: [
                Container(
                  height: 65,
                  width: 215,
                  margin: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.355, 30, 20, 0),
                  child: fieldValorC(),
                ),
                Container(
                  height: 65,
                  width: 180,
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: fieldValorV(),
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.3,
              margin: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.010,
                  MediaQuery.of(context).size.height * 0.04,
                  0,
                  0),
              child: fieldCodigo(),
            ),
            Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 200,
                  margin: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.33, 80, 100, 0),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.cancel),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Cancelar",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 200,
                  margin: EdgeInsets.fromLTRB(0, 80, 0, 0),
                  child: ElevatedButton(
                    onPressed: () async {
                      final isValid = _form.currentState!.validate();
                      if (isValid) {
                        _form.currentState!.save();

                        int flag = await Provider.of<ProdutoProvider>(context,
                                listen: false)
                            .salvar(
                                Produto.DAO(
                                    int.parse(_id.text),
                                    _cod.text,
                                    _descricao.text,
                                    double.parse(_valorCompra.text),
                                    double.parse(_valorVenda.text),
                                    double.parse(_quantidadeAtual.text),
                                    double.parse(_quantidadeMinima.text),
                                    unidadeProduto.toString(),
                                    true),
                                context);

                        if (flag == 0) {
                          showCustomSnackbar(
                              context: context,
                              text: "Produto alterado",
                              color: Colors.lightBlue,
                              behavior: SnackBarBehavior.fixed);
                          Navigator.pop(context);
                        }

                        // snackBar = SnackBar(content: Text("Produto alterado!"));
                        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.check),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Confirmar",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget cadastrarUnidade(BuildContext context) {
    var dropValue = ValueNotifier('');
    List<String> unidades = ["UN", "KG", "PCT", "FD"];
    var flag = dropValue == null ? "UN" : unidadeProduto.toString();
    dropValue.value = flag;

    return Center(
      child: ValueListenableBuilder(
        valueListenable: dropValue,
        builder: (BuildContext context, String value, _) {
          return Container(
            width: 200,
            color: Colors.white10,
            child: DropdownButtonFormField(
                decoration: InputDecoration(
                  label: Text('UNIDADE'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                isExpanded: true,
                // icon: const Icon(Icons.pix_rounded, color: Colors.white),
                onChanged: (unidade) {
                  dropValue.value = unidade.toString();
                  unidadeProduto = dropValue.value;
                },
                hint: const Text(
                  "UN",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                value: (value.isEmpty) ? null : unidadeProduto,
                items: unidades
                    .map(
                      (unidade) => DropdownMenuItem(
                        value: unidade,
                        child: Text(
                          unidade,
                          style: const TextStyle(
                              color: Colors.black,
                              backgroundColor: Color.fromARGB(0, 253, 16, 8)),
                        ),
                      ),
                    )
                    .toList()),
          );
        },
      ),
    );
  }
}
