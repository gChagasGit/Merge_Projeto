import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../modelo/Cliente.dart';
import '../../provider/clientes.dart';

class FormularioCliente extends StatelessWidget {
  // const ({ Key? key }) : super(key: key);

  final _form = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _cpf = TextEditingController();
  final _cnpj = TextEditingController();
  final _end = TextEditingController();
  final _bairro = TextEditingController();
  final _cep = TextEditingController();
  final _cidade = TextEditingController();
  final _estado = TextEditingController();
  final _tel = TextEditingController();
  final _prevP = TextEditingController();
  //MAP
  final Map<String, Object> _formData = {};

  Widget fieldName() {
    return TextFormField(
      controller: _nome,
      style: TextStyle(fontSize: 17),
      keyboardType: TextInputType.name,
      // inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
      validator: (value) {
        if (value!.trim().isEmpty || value == null) {
          return "Informe o nome";
        }
        if (value.trim().length <= 3) {
          return "Nome muito pequeno. No min 3 letras";
        }
        return null;
      },
      onSaved: (value) => _formData['name'] = value.toString(),
      decoration: const InputDecoration(
        labelText: "Nome:",
        hintText: "Tomate",
        // prefixIcon: Icon(Icons.food_bank_outlined),
        border: OutlineInputBorder(),
      ),
    );
  }

  //Fazer mascara
  Widget fieldCpf() {
    return TextFormField(
      controller: _cpf,
      style: TextStyle(fontSize: 17),
      keyboardType: TextInputType.number,
      // inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
      validator: (value) {
        if (value!.isEmpty) {
          return "Informe o cpf";
        }
        return null;
      },
      onSaved: (value) => _formData['cpf'] = value.toString(),
      decoration: const InputDecoration(
        labelText: "CPF:",
        hintText: "Tomate",
        // prefixIcon: Icon(Icons.food_bank_outlined),
        border: OutlineInputBorder(),
      ),
    );
  }

  // Widget fieldCnpj() {
  //   return TextFormField(
  //     controller: _cnpj,
  //     style: TextStyle(fontSize: 17),
  //     keyboardType: TextInputType.number,
  //     // inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
  //     validator: (value) {
  //       if (value!.isEmpty) {
  //         return "Informe o nome do produto";
  //       }
  //       return null;
  //     },
  //     onSaved: (value) => _formData['cnpj'] = value.toString(),
  //     decoration: InputDecoration(
  //       labelText: "CNPJ:",
  //       hintText: "Tomate",
  //       // prefixIcon: Icon(Icons.food_bank_outlined),
  //       border: OutlineInputBorder(),
  //     ),
  //   );
  // }

  // Widget fieldEnd() {
  //   return TextFormField(
  //     controller: _end,
  //     style: TextStyle(fontSize: 17),
  //     keyboardType: TextInputType.name,
  //     // inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
  //     validator: (value) {
  //       if (value!.isEmpty) {
  //         return "Informe o nome do produto";
  //       }
  //       return null;
  //     },
  //     onSaved: (value) => _formData['end'] = value.toString(),
  //     decoration: InputDecoration(
  //       labelText: "Endereço:",
  //       hintText: "Tomate",
  //       // prefixIcon: Icon(Icons.food_bank_outlined),
  //       border: OutlineInputBorder(),
  //     ),
  //   );
  // }

  // Widget fieldBairro() {
  //   return TextFormField(
  //     controller: _bairro,
  //     style: TextStyle(fontSize: 17),
  //     keyboardType: TextInputType.name,
  //     // inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
  //     validator: (value) {
  //       if (value!.isEmpty) {
  //         return "Informe o nome do produto";
  //       }
  //       return null;
  //     },
  //     onSaved: (value) => _formData['bairro'] = value.toString(),
  //     decoration: InputDecoration(
  //       labelText: "Bairro:",
  //       hintText: "Tomate",
  //       // prefixIcon: Icon(Icons.food_bank_outlined),
  //       border: OutlineInputBorder(),
  //     ),
  //   );
  // }

  // Widget fieldCep() {
  //   return TextFormField(
  //     controller: _cep,
  //     style: TextStyle(fontSize: 17),
  //     keyboardType: TextInputType.name,
  //     // inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
  //     validator: (value) {
  //       if (value!.isEmpty) {
  //         return "Informe o nome do produto";
  //       }
  //       return null;
  //     },
  //     onSaved: (value) => _formData['cep'] = value.toString(),
  //     decoration: InputDecoration(
  //       labelText: "CEP:",
  //       hintText: "Tomate",
  //       // prefixIcon: Icon(Icons.food_bank_outlined),
  //       border: OutlineInputBorder(),
  //     ),
  //   );
  // }

  // Widget fieldCidade() {
  //   return TextFormField(
  //     controller: _cidade,
  //     style: TextStyle(fontSize: 17),
  //     keyboardType: TextInputType.name,
  //     // inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
  //     validator: (value) {
  //       if (value!.isEmpty) {
  //         return "Informe o nome do produto";
  //       }
  //       return null;
  //     },
  //     onSaved: (value) => _formData['cidade'] = value.toString(),
  //     decoration: InputDecoration(
  //       labelText: "Cidade:",
  //       hintText: "Tomate",
  //       // prefixIcon: Icon(Icons.food_bank_outlined),
  //       border: OutlineInputBorder(),
  //     ),
  //   );
  // }

  // Widget fieldEstado() {
  //   return TextFormField(
  //     controller: _estado,
  //     style: TextStyle(fontSize: 17),
  //     keyboardType: TextInputType.name,
  //     // inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
  //     validator: (value) {
  //       if (value!.isEmpty) {
  //         return "Informe o nome do produto";
  //       }
  //       return null;
  //     },
  //     onSaved: (value) => _formData['estado'] = value.toString(),
  //     decoration: InputDecoration(
  //       labelText: "Estado:",
  //       hintText: "Tomate",
  //       // prefixIcon: Icon(Icons.food_bank_outlined),
  //       border: OutlineInputBorder(),
  //     ),
  //   );
  // }

  Widget fieldTel() {
    return TextFormField(
      controller: _tel,
      style: TextStyle(fontSize: 17),
      keyboardType: TextInputType.number,
      // inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
      validator: (value) {
        if (value!.isEmpty) {
          return "Informe o telefone";
        }
        return null;
      },
      onSaved: (value) => _formData['tel'] = value.toString(),
      decoration: InputDecoration(
        labelText: "Telefone:",
        hintText: "Tomate",
        // prefixIcon: Icon(Icons.food_bank_outlined),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget fieldPrevP() {
    return TextFormField(
      controller: _prevP,
      style: TextStyle(fontSize: 17),
      keyboardType: TextInputType.datetime,
      // inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
      validator: (value) {
        if (value!.isEmpty) {
          return "Informe uma previsão de pagamento";
        }
        return null;
      },
      onSaved: (value) => _formData['prevP'] = value.toString(),
      decoration: InputDecoration(
        labelText: "Previsão de pagamento",
        hintText: "01-12-2022",
        // prefixIcon: Icon(Icons.food_bank_outlined),
        border: OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cliente =
        ModalRoute.of(context)?.settings.arguments! as Cliente;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
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
                  //   height: 50,
                  //   width: 200,
                  //   margin: EdgeInsets.fromLTRB(0, 80, 20, 0),
                  //   child: fieldCnpj(),
                  // ),
                ],
              ),
              // Row(
              //   // mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       height: 50,
              //       width: 400,
              //       margin: EdgeInsets.fromLTRB(200, 20, 20, 0),
              //       child: fieldEnd(),
              //     ),
              //     Container(
              //       height: 50,
              //       width: 200,
              //       margin: EdgeInsets.fromLTRB(0, 20, 20, 0),
              //       child: fieldBairro(),
              //     ),
              //     Container(
              //       height: 50,
              //       width: 150,
              //       margin: EdgeInsets.fromLTRB(0, 20, 20, 0),
              //       child: fieldCep(),
              //     ),
              //   ],
              // ),
              // Row(
              //   children: [
              //     Container(
              //       height: 50,
              //       width: 400,
              //       margin: EdgeInsets.fromLTRB(200, 20, 20, 0),
              //       child: fieldCidade(),
              //     ),
              //     Container(
              //       height: 50,
              //       width: 300,
              //       margin: EdgeInsets.fromLTRB(0, 20, 20, 0),
              //       child: fieldEstado(),
              //     ),
              //   ],
              // ),
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
                      onPressed: () {
                        final isValid = _form.currentState!.validate();

                        if (isValid) {
                          _form.currentState!.save();
                          Provider.of<Clientes>(context, listen: false).put(
                            Cliente.novo(
                              id: int.parse(_formData['id'].toString()),
                              nome: _formData['name'].toString(),
                              cpf: _formData['cpf'].toString(),
                              telefone: _formData['telefone'].toString(),
                              diaPrevPag: int.parse(_formData['prevP'].toString()),
                              status: (_formData['status'].toString() == '1')
                            ),
                          );
                          Navigator.of(context).pop();
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
