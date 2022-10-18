// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

//--------------------------------------CADASTRAR CLIENTE-----------------------------------------

import 'dart:ffi';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/services.dart';
import 'package:flutter_teste_msql1/components/snackBar_custom.dart';
import 'package:flutter_teste_msql1/controle/UsuarioCtrl.dart';
import 'package:flutter_teste_msql1/modelo/Cliente.dart';
import 'package:flutter_teste_msql1/modelo/Usuario.dart';
import 'package:flutter_teste_msql1/provider/usuarioProvider.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

class EditarUsuario extends StatefulWidget {
  // final Cliente clienteTeste = Cliente.c();
  late UsuarioCtrl? _usuarioCtrl;
  EditarUsuario({UsuarioCtrl? usuarioCtrl}) {
    _usuarioCtrl = usuarioCtrl;
  }

  @override
  State<EditarUsuario> createState() => _EditarUsuarioState();
}

class _EditarUsuarioState extends State<EditarUsuario> {
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
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(fontSize: 17),
      // keyboardType: TextInputType.name,
      //MASCARA PARA TEXTO
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z ]*$'))
      ],
      validator: (value) {
        if (value!.length < 4) {
          return "No mínimo insira 3 letras";
        }
      },
      decoration: const InputDecoration(
        labelText: "Nome:",
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
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(fontSize: 17),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CpfInputFormatter()
      ],
      validator: (value) {
        if (value!.length < 14) {
          return "Confira o CPF";
        }
        if (!GetUtils.isCpf(value)) {
          return "Confira o CPF";
        }
      },
      decoration: const InputDecoration(
        labelText: "CPF:",
        hintText: "000.000.000-00",
        // prefixIcon: Icon(Icons.food_bank_outlined),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget fieldSenha() {
    return TextFormField(
      // Adicionar Mascaras, FAZER ISSO
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: _senha,
      obscureText: true,
      style: const TextStyle(fontSize: 17),
      keyboardType: TextInputType.visiblePassword, //Verificar Se mostra a senha
      // inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
      validator: (value) {
        if (value!.length < 8) {
          return "No mínimo insira 8 digitos";
        }
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
      controller: _senhaConfirmacao,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: true,
      style: const TextStyle(fontSize: 17),
      keyboardType: TextInputType.visiblePassword, //Verificar Se mostra a senha
      // inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
      validator: (value) {
        if (value!.length < 8) {
          return "No mínimo insira 8 digitos";
        }
        if (_senha.text.compareTo(_senhaConfirmacao.text) != 0) {
          return "Senhas são diferentes";
        }
      },
      decoration: const InputDecoration(
        labelText: "Confirme sua senha:",
        hintText: "Abcd123",
        prefixIcon: Icon(Icons.password),
        border: OutlineInputBorder(),
      ),
    );
  }

  _setUsuario(Usuario usuarioM) {
    _id.text = usuarioM.id.toString();
    _nome.text = usuarioM.nome;
    _cpf.text = usuarioM.cpf;
    _senha.text = usuarioM.senha;
    _senhaConfirmacao.text = usuarioM.senha;
    _status.text = usuarioM.status.toString();
  }

  @override
  Widget build(BuildContext context) {
    var snackBar;
    Usuario usuarioM = ModalRoute.of(context)!.settings.arguments as Usuario;
    _setUsuario(usuarioM);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Editar Usuário",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Form(
        key: _form,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 80,
                  width: 350,
                  margin: EdgeInsets.fromLTRB(370, 140, 0, 0),
                  child: fieldName(),
                ),
                Container(
                  height: 80,
                  width: 200,
                  margin: EdgeInsets.fromLTRB(20, 140, 0, 0),
                  child: fieldCpf(),
                ),
              ],
            ),
            Row(children: [
              Container(
                height: 80,
                width: 250,
                margin: EdgeInsets.fromLTRB(370, 40, 0, 0),
                child: fieldSenha(),
              ),
              Container(
                height: 80,
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
                    onPressed: () {
                      _setUsuario(usuarioM);
                    },
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
                      bool isValid = false;
                      if (_form.currentState!.validate() &&
                          GetUtils.isCpf(_cpf.text)) {
                        isValid = true;
                      } else {
                        _setUsuario(usuarioM);
                        createAlertDialogCamposPreenchidosIncorretamete(
                            context);
                      }
                      if (isValid && (_senha.text == _senhaConfirmacao.text)) {
                        // print(_senha.text);
                        // print(_senhaConfirmacao.text);
                        _form.currentState!.save();
                        int flag = await Provider.of<UsuarioProvider>(context,
                                listen: false)
                            .salvar(
                                Usuario.DAO(int.parse(_id.text), _nome.text,
                                    _senha.text, _cpf.text, usuarioM.status),
                                context);

                        if (flag == 0) {
                          showCustomSnackbar(
                              context: context,
                              text: "Usuário alterado",
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

  createAlertDialogCamposPreenchidosIncorretamete(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              children: const [
                Text("Confira os campos de entrada!",
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
