// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

//--------------------------------------CADASTRAR CLIENTE-----------------------------------------

import 'dart:ffi';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/services.dart';
import 'package:flutter_teste_msql1/components/snackBar_custom.dart';
import 'package:flutter_teste_msql1/controle/UsuarioCtrl.dart';
import 'package:flutter_teste_msql1/modelo/Usuario.dart';
import 'package:flutter_teste_msql1/provider/usuarioProvider.dart';
import 'package:brasil_fields/brasil_fields.dart';

import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

class CadastrarUsuario extends StatefulWidget {
  // final Cliente clienteTeste = Cliente.c();
  late UsuarioCtrl? _usuarioCtrl;
  CadastrarUsuario({UsuarioCtrl? usuarioCtrl}) {
    _usuarioCtrl = usuarioCtrl;
  }

  @override
  State<CadastrarUsuario> createState() => _CadastrarUsuarioState();
}

class _CadastrarUsuarioState extends State<CadastrarUsuario> {
  // late UsuarioProvider usuarioProvider;
  final _form = GlobalKey<FormState>();
  final _id = TextEditingController();
  final _nome = TextEditingController();
  final _senha = TextEditingController();
  final _senhaConfirmacao = TextEditingController();
  final _cpf = TextEditingController();
  final _status = TextEditingController();

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

  Widget fieldSenha() {
    return TextFormField(
      // Adicionar Mascaras, FAZER ISSO
      controller: _senha,
      obscureText: true,
      style: const TextStyle(fontSize: 17),
      keyboardType: TextInputType.visiblePassword, //Verificar Se mostra a senha
      // inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
      validator: (value) {
        if (value!.isEmpty) {
          return "Senha está vazia";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Senha:",
        hintText: "Abcd123",
        prefixIcon: Icon(Icons.password),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget fieldSenhaConf() {
    return TextFormField(
      // Adicionar Mascaras, FAZER ISSO
      controller: _senhaConfirmacao,
      obscureText: true,
      style: const TextStyle(fontSize: 17),
      keyboardType: TextInputType.visiblePassword, //Verificar Se mostra a senha
      // inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
      validator: (value) {
        if (value!.isEmpty) {
          return "Senha está vazia";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Confirme sua senha:",
        hintText: "Abcd123",
        prefixIcon: Icon(Icons.password),
        border: OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var snackBar;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cadastro Usuário",
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
                  height: 50,
                  width: 350,
                  margin: EdgeInsets.fromLTRB(370, 140, 0, 0),
                  child: fieldName(),
                ),
                Container(
                  height: 50,
                  width: 200,
                  margin: EdgeInsets.fromLTRB(20, 140, 0, 0),
                  child: fieldCpf(),
                ),
              ],
            ),
            Row(children: [
              Container(
                height: 50,
                width: 250,
                margin: EdgeInsets.fromLTRB(370, 40, 0, 0),
                child: fieldSenha(),
              ),
              Container(
                height: 50,
                width: 250,
                margin: EdgeInsets.fromLTRB(50, 40, 0, 0),
                child: fieldSenhaConf(),
              ),
            ]),
            Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 200,
                  margin: EdgeInsets.fromLTRB(410, 50, 100, 0),
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
                  margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: ElevatedButton(
                    onPressed: () async {
                      final isValid = _form.currentState!.validate();
                      if (isValid && (_senha.text == _senhaConfirmacao.text)) {
                        print(_senha.text);
                        print(_senhaConfirmacao.text);
                        _form.currentState!.save();
                        Usuario novo = Usuario();
                        novo.nome = _nome.text;
                        novo.senha = _senha.text;
                        novo.cpf = _cpf.text;
                        novo.status = true;
                        int flag = await Provider.of<UsuarioProvider>(context,
                                listen: false)
                            .salvar(novo, context);
                        if (flag == 0) {
                          showCustomSnackbar(
                              context: context,
                              text: "Usuário cadastrado",
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
    );
  }
}
