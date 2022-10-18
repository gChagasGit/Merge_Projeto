// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

//--------------------------------------CADASTRAR CLIENTE-----------------------------------------

import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter_teste_msql1/components/snackBar_custom.dart';
import 'package:flutter_teste_msql1/controle/ClienteCtrl.dart';
import 'package:flutter_teste_msql1/modelo/Cliente.dart';
import 'package:flutter_teste_msql1/provider/clienteProvider.dart';
import 'package:flutter_teste_msql1/util/ConversorDataHora.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:brasil_fields/brasil_fields.dart';

import 'package:flutter/material.dart';

class CadastrarCliente extends StatefulWidget {
  // final Cliente clienteTeste = Cliente.c();
  late ClienteCtrl? _clienteCtrl;
  CadastrarCliente({ClienteCtrl? clienteCtrl}) {
    _clienteCtrl = clienteCtrl;
  }

  @override
  State<CadastrarCliente> createState() => _CadastrarClienteState();
}

class _CadastrarClienteState extends State<CadastrarCliente> {
  late ClienteProvider clienteProvider;
  final _form = GlobalKey<FormState>();
  final _id = TextEditingController();
  final _nome = TextEditingController();
  final _cpf = TextEditingController();
  final _tel = TextEditingController();
  final _prevP = TextEditingController();
  final _status = TextEditingController();

  // DateTime prevP = DateTime.now();

  // @override
  // void initState() {
  //   super.initState();
  //   // _nome.text = widget.clienteTeste.nome;
  //   clienteProvider = Provider.of<ClienteProvider>(context, listen: false);
  // }

  Widget fieldName() {
    return TextFormField(
      autofocus: false,
      controller: _nome,
      style: TextStyle(fontSize: 17),
      // keyboardType: TextInputType.name,
      //MASCARA PARA TEXTO
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z ]*$'))
      ],
      validator: (value) {
        if (value!.trim().isEmpty || value == null) {
          return "Informe o nome";
        }
        if (value.trim().length <= 3) {
          return "Nome muito pequeno. No min 3 letras";
        }
        return null;
      },
      // onSaved: (value) => _formData['nome'] = value.toString(),
      decoration: const InputDecoration(
        labelText: "Nome:",
        hintText: "Fulano da Silva",
        // prefixIcon: Icon(Icons.food_bank_outlined),
        border: OutlineInputBorder(),
      ),
    );
  }

  //MUDAR O VAR PARA 14 NO BANCO
  //Fazer mascara
  Widget fieldCpf() {
    return TextFormField(
      controller: _cpf,
      style: TextStyle(fontSize: 17),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CpfInputFormatter()
      ],
      validator: (value) {
        if (value!.isEmpty) {
          return "Informe o cpf";
        }

        if (value.length != 14) {
          return "Cpf inválido";
        }
        return null;
      },
      // onSaved: (value) => _formData['cpf'] = value.toString(),
      decoration: const InputDecoration(
        labelText: "CPF:",
        hintText: "099.999.999.99",
        // prefixIcon: Icon(Icons.food_bank_outlined),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget fieldTel() {
    return TextFormField(
      controller: _tel,
      style: TextStyle(fontSize: 17),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        TelefoneInputFormatter()
      ],
      //MUDAR O VAR PARA 15 NO BANCO
      validator: (value) {
        if (value!.isEmpty) {
          return "Informe o telefone";
        }

        if (value.length != 15) {
          return "Telefone inválido";
        }

        return null;
      },
      // onSaved: (value) => _formData['tel'] = value.toString(),
      decoration: InputDecoration(
        labelText: "Telefone:",

        hintText: "(42)98869-4493",
        // prefixIcon: Icon(Icons.food_bank_outlined),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget fieldPrevP() {
    return TextFormField(
      controller: _prevP,
      style: TextStyle(fontSize: 17),
      // keyboardType: TextInputType.datetime,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value!.isEmpty) {
          return "Informe o dia do pagamento";
        }

        if (int.parse(value) > 30 || int.parse(value) < 0) {
          return "Dia inválido";
        }
        return null;
      },
      // onSaved: (value) => _formDataD[prevP] = value.toString(),
      decoration: InputDecoration(
        labelText: "Dia do pagamento",
        hintText: "01",
        // prefixIcon: Icon(Icons.food_bank_outlined),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget build(BuildContext context) {
    var snackBar;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          // clienteM.nome,
          "Cadastro Cliente",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _form,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  Container(
                    height: 80,
                    width: 300,
                    margin: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.22, 80, 20, 0),
                    child: fieldName(),
                  ),
                  Container(
                    height: 80,
                    width: 200,
                    margin: EdgeInsets.fromLTRB(0, 80, 20, 0),
                    child: fieldCpf(),
                  ),
                  Container(
                    height: 80,
                    width: 200,
                    margin: EdgeInsets.fromLTRB(0, 80, 20, 0),
                    child: fieldTel(),
                  ),
                  // Container(
                ],
              ),
              Row(
                children: [
                  Container(
                    height: 80,
                    width: 300,
                    margin: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.22, 10, 20, 0),
                    child: fieldPrevP(),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 80,
                    width: 200,
                    margin: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.3, 80, 100, 0),
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
                    height: 80,
                    width: 200,
                    margin: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                    child: ElevatedButton(
                      onPressed: () async {
                        final isValid = _form.currentState!.validate();
                        if (isValid) {
                          _form.currentState!.save();
                          Cliente novo = Cliente();
                          novo.nome = _nome.text;
                          // novo.cpf = _formData['cpf'].toString();
                          novo.cpf = _cpf.text;
                          novo.telefone = _tel.text;
                          novo.diaPrevPag = int.parse(_prevP.text);
                          novo.status = true;
                          int flag = await Provider.of<ClienteProvider>(context,
                                  listen: false)
                              .salvar(novo, context);

                          if (flag == 0) {
                            showCustomSnackbar(
                                context: context,
                                text: "Cliente cadastrado",
                                color: Colors.blue);
                            Navigator.pop(context);
                          }
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
      ),
    );
  }
}
