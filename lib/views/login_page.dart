// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/visao/LoginGUI.dart';
import 'package:get/get.dart';

import '../main.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _cpf = TextEditingController();
  final _senha = TextEditingController();

  //var maskFormatterSenha = MaskTextInputFormatter(mask: '###.###.###-##', filter: { "#": RegExp(r'[0-9]') });

  String cpf = "";
  String senha = "";

  bool _isAdministrador = false;

  LoginPage(this.principalCtrl);

  PrincipalCtrl principalCtrl;

  Widget fieldcpf() {
    return TextFormField(
      // Adicionar Mascaras, FAZER ISSO
      controller: _cpf,
      onChanged: (text) {
        cpf = GetUtils.numericOnly(text);
      },
      //maxLength: 14,
      autofocus: true,
      style: TextStyle(fontSize: 17),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CpfInputFormatter()
      ],
      validator: (value) {
        if (value!.isEmpty) {
          return "Informe o CPF";
        }
        cpf = _cpf.text;
        return null;
      },
      decoration: const InputDecoration(
        labelText: "CPF:",
        hintText: "000.000.000-00",
        counterText: "",
        prefixIcon: Icon(Icons.article_rounded),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget fieldSenha() {
    return TextFormField(
      // Adicionar Mascaras, FAZER ISSO
      controller: _senha,
      onChanged: (texto) {
        senha = texto;
      },
      obscureText: true,
      style: const TextStyle(fontSize: 17),
      keyboardType: TextInputType.visiblePassword, //Verificar Se mostra a senha
      // inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
      validator: (value) {
        if (value!.isEmpty) {
          return "Senha está vazia";
        }
        senha = _senha.text;
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Senha:",
        hintText: "Sua senha",
        prefixIcon: Icon(Icons.key_sharp),
        border: OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.red,
          onPressed: () async {
            createAlertDialogEncerrarSistema(context, principalCtrl);
          },
          label: const Text(
            "Encerrar o sistema",
            style: TextStyle(fontSize: 16),
          ),
          icon: const Icon(Icons.power_settings_new_outlined),
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Tela de Autenticação",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                margin: EdgeInsets.only(bottom: 50),
                color: const Color.fromARGB(255, 209, 209, 209),
                child: SizedBox(
                  height: 70,
                  width: 400,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                        child: Text(
                            "Insira seu CPF e senha, após isso clique em 'Entrar'")),
                  ),
                ),
              ),
              Container(
                width: 400,
                height: 50,
                margin: EdgeInsets.only(bottom: 10),
                child: fieldcpf(),
              ),
              Container(
                width: 400,
                height: 50,
                margin: EdgeInsets.only(bottom: 30),
                child: fieldSenha(),
              ),
              Container(
                width: 180,
                height: 50,
                margin: EdgeInsets.only(bottom: 50),
                child: ElevatedButton(
                  onPressed: () async {
                    if (!GetUtils.isCpf(_cpf.text) || senha.isEmpty) {
                      await createAlertDialogCredenciais(context);
                    } else {
                      bool login = await _validarLogin(
                          cpf: cpf,
                          senha: senha,
                          administrador: _isAdministrador);
                      if (login) {
                        limpar();
                        principalCtrl.routeHomePage(context);
                      }
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.login),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Entrar",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 40,
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () async {
                    await createAlertDialogEsqueciMinhaSenha(
                        context, principalCtrl);
                  },
                  child: Text(
                    "Esqueci minha senha",
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _validarLogin(
      {required String cpf,
      required String senha,
      required bool administrador}) async {
    await principalCtrl.autenticacaoCtrl.autenticarUsuario(
        cpf: cpf, senha: senha, administrador: administrador);
    if (principalCtrl.autenticacaoCtrl.isUsuarioLogado) {
      print(
          ">>> Usuário logado! ${principalCtrl.hashCode} | ${DateTime.now()}");
    }
    return principalCtrl.autenticacaoCtrl.isUsuarioLogado;
  }

  createAlertDialogCredenciais(BuildContext context) {
    limpar();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              children: const [
                Text("Credenciais inválidas!", textAlign: TextAlign.center),
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

  createAlertDialogEncerrarSistema(
      BuildContext context, PrincipalCtrl principalCtrl) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            alignment: Alignment.center,
            actionsAlignment: MainAxisAlignment.center,
            title: const Text("Relamente deseja encerrar o sistema?"),
            actions: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  elevation: 5.0,
                  color: Colors.blueGrey[100],
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    "Não",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                child: MaterialButton(
                  onPressed: () {
                    exit(0);
                  },
                  elevation: 5.0,
                  color: Colors.blueGrey[100],
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    "Sim",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  createAlertDialogEsqueciMinhaSenha(
      BuildContext context, PrincipalCtrl principalCtrl) {
    _senha.clear();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            alignment: Alignment.center,
            actionsAlignment: MainAxisAlignment.center,
            title: const Text("Entre com a senha do administrador!",
                textAlign: TextAlign.center),
            actions: [
              Container(
                //width: 400,
                height: 50,
                margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: fieldSenha(),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 40),
                    child: MaterialButton(
                      onPressed: () async {
                        if (_senha.text == "admin") {
                          _isAdministrador = true;
                          bool login = await _validarLogin(
                              cpf: cpf,
                              senha: senha,
                              administrador: _isAdministrador);
                          if (login) {
                            limpar();
                            principalCtrl.routeHomePage(context);
                          }
                        } else {
                          _senha.clear();
                          Navigator.of(context).pop();
                          createAlertDialogCredenciais(context);
                        }
                      },
                      elevation: 5.0,
                      color: Colors.blueGrey[100],
                      padding: const EdgeInsets.all(10),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Continuar",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.blue[700],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 40),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      elevation: 5.0,
                      color: Colors.blueGrey[100],
                      padding: const EdgeInsets.all(10),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Cancelar",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.blue[700],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  limpar() {
    _isAdministrador = false;
    _cpf.clear();
    _senha.clear();
  }
}
