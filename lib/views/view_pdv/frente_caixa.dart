import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_teste_msql1/components/produtos_especificacao_pdv.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/modelo/ItemVenda.dart';
import 'package:flutter_teste_msql1/provider/pdv/clientesPdvProvider.dart';
import 'package:flutter_teste_msql1/provider/pdv/formasDePagamentoProvider.dart';
import 'package:flutter_teste_msql1/provider/pdv/itensVendidosProvider.dart';
import 'package:flutter_teste_msql1/provider/produtoProvider.dart';
import 'package:flutter_teste_msql1/util/ConversorMoeda.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../modelo/Produto.dart';
import '../../widgets/formasDePagamentoSubPag.dart';

Color pad = const Color.fromARGB(255, 44, 99, 127);

class FrenteCaixa extends StatefulWidget {
  FrenteCaixa(this.principalCtrl);

  PrincipalCtrl principalCtrl;

  @override
  State<FrenteCaixa> createState() => _FrenteCaixaState(principalCtrl);
}

//VERIFICAR OS VALUE, FALTA FAZER MUDANCA SANGRIA
class _FrenteCaixaState extends State<FrenteCaixa> {
  _FrenteCaixaState(this.principalCtrl);

  PrincipalCtrl principalCtrl;

  final _pesquisaProdutoController = TextEditingController();
  final _valorController = TextEditingController();
  final _justificativaController = TextEditingController();

  FocusNode _pesquisarProdutoFocusNode = FocusNode();

  //--------------------

  late ItensVendidosProvider itensVendidosProvider;
  late FormasDePagamentoProvider formasDePagamentoProvider;
  late ClientePdvProvider clientesPdvProvider;
  late ProdutoProvider produtosProvider;
  //late ItemVenda itemVenda;

  double valorItemVendido = 0;
  String cod_peso = '';

  //-------- varios
  int value = 0;
  //double height = 700;
  bool selectedContinuar = true;
  int _value = 1;

  void mudaTela() {
    setState(() {
      selectedContinuar = !selectedContinuar;
    });
  }

  //WIDGET PRINCIPAL
  Widget build(BuildContext context) {
    itensVendidosProvider = Provider.of<ItensVendidosProvider>(context);
    formasDePagamentoProvider = Provider.of<FormasDePagamentoProvider>(context);
    clientesPdvProvider = Provider.of<ClientePdvProvider>(context);
    produtosProvider = Provider.of<ProdutoProvider>(context);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Visibility(
        visible: selectedContinuar,
        child: botaoFlutuanteSelecionarCliente(
            context,
            clientesPdvProvider,
            (formasDePagamentoProvider.contemVendaPrazo &&
                clientesPdvProvider.clienteDaVenda.id != 1)),
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (selectedContinuar) {
              Navigator.of(context).pop();
            } else {
              mudaTela();
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: tituloDaAppBar(),
        titleTextStyle: const TextStyle(fontSize: 18),
      ),
      body: Row(
        children: [
          Padding(padding: const EdgeInsets.all(8)), //DEIXAR AQUI RESPONSIVO
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //INICIO COLUNA DA ESQUERDA
              LimparVenda(),
              FecharCaixa(context),
              SangriaReforco(context),
              BuscarProdutoEspecifico(),
              //ACABOU COLUNA DA ESQUERDA
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //TROCAR A
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: selectedContinuar
                    ? colunaCentral()
                    : formaDePagamentoSubPage(
                        context,
                        principalCtrl,
                        formasDePagamentoProvider,
                        itensVendidosProvider,
                        clientesPdvProvider),
              ),
            ],
          ),
        ],
      ),
    );
  }

  tituloDaAppBar() {
    if (clientesPdvProvider.clienteDaVenda.id == 0) {
      return Container(
        alignment: Alignment.center,
        child: Text(
            "Ponto de Venda"),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Text("Ponto De Venda"),
        SizedBox(
            width: 200,
            child: Text("Cliente: ${clientesPdvProvider.clienteDaVenda.nome}"))
      ],
    );
  }

  colunaCentral() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.7,
      color: Colors.grey[400],
      margin: const EdgeInsets.all(70),
      child: Expanded(
        child: Column(
          children: [
            cabecalhoBuscaDoProduto(),
            const Padding(padding: const EdgeInsets.all(5)),
            cabecalhoListaProdutosAtuais(),
            listaProdutosAtuais(),
            rodape()
          ],
        ),
      ),
    );
  }

  fieldPesquisaDoProduto() {
    return TextFormField(
      controller: _pesquisaProdutoController,
      autofocus: true,
      focusNode: _pesquisarProdutoFocusNode,
      maxLength: 13,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: const InputDecoration(
        counterText: '',
        labelText: "Pesquise o produto",
        prefixIcon: Icon(Icons.search),
        border: InputBorder.none,
      ),
      onEditingComplete: () {
        print("> Pronto para pesquisar! ${_pesquisaProdutoController.text}");
        _buscarProduto();
        _pesquisarProdutoFocusNode.requestFocus();
      },
    );
  }

  _buscarProduto() async {
    String codigoDigitado = _pesquisaProdutoController.text;
    if (codigoDigitado.isNotEmpty) {
      if (!itensVendidosProvider.isProdutoJaAdicionado(codigoDigitado)) {
        await itensVendidosProvider.construirItemVenda(principalCtrl,
            codigo: codigoDigitado);
      } else {
        await _snackBar();
      }
    }
    _limparControllersDosTextsFields();
  }

  _snackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        content: Text('Produto já adicionado!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  botaoBuscarProduto() {
    return ElevatedButton.icon(
      icon: Icon(Icons.search),
      onPressed: () => _buscarProduto,
      label: const Text(
        "Buscar produto",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  cabecalhoBuscaDoProduto() {
    return Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          children: [
            SizedBox(width: 20),
            Expanded(child: fieldPesquisaDoProduto()),
            //SizedBox(height: 50, width: 200, child: botaoBuscarProduto()),
          ],
        ));
  }

  cabecalhoListaProdutosAtuais() {
    return Material(
      elevation: 5.0,
      child: Container(
        padding: const EdgeInsets.all(8),
        color: Colors.black45,
        child: Row(
          children: const [
            SizedBox(width: 60),
            SizedBox(
                width: 520,
                child: Text('Descrição do produto',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.bold))),
            SizedBox(
                width: 100,
                child: Text('Quantidade',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontWeight: FontWeight.bold))),
            SizedBox(
                width: 160,
                child: Text('Valor',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontWeight: FontWeight.bold))),
            SizedBox(
                width: 105,
                child: Text('Total',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }

  listaProdutosAtuais() {
    return Consumer<ItensVendidosProvider>(builder: (BuildContext context,
        ItensVendidosProvider valueProvider, Widget? child) {
      itensVendidosProvider = valueProvider;
      return Expanded(
          child: (valueProvider.itensVendidos.isEmpty)
              ? const Center(
                  child: Text(
                  "Nenhum produto adicionado!",
                  style: TextStyle(fontSize: 30),
                ))
              : ListViewComOsItensVendidos(valueProvider.itensVendidos));
    });
  }

  ListViewComOsItensVendidos(List<ItemVenda> itensVendidos) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: itensVendidos.length,
      itemBuilder: (BuildContext context, int index) {
        final _valorVendidoController = TextEditingController();
        final _quantidadeVendidaController = TextEditingController();
        ItemVenda itemVenda = itensVendidos.elementAt(index);
        int asFixed = (itemVenda.produto.unidade == "KG") ? 3 : 0;
        _valorVendidoController.text = ConversorMoeda.converterDoubleEmTexto(
            itemVenda.valorVendido.toStringAsFixed(2));
        _quantidadeVendidaController.text =
            ConversorMoeda.converterDoubleEmTexto(
                itemVenda.quantidadeVendida.toStringAsFixed(asFixed));
        return Container(
          height: 60,
          color: (index % 2 == 0) ? Colors.grey[300] : Colors.white24,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 20),
              SizedBox(width: 20, child: Text('${index + 1}')),
              const SizedBox(width: 20),
              SizedBox(
                  width: 500,
                  child: ListTile(
                    title: Text(itemVenda.produto.descricao),
                    subtitle: Text("Cod.: ${itemVenda.produto.cod}"),
                  )),
              const SizedBox(width: 20),
              SizedBox(
                  width: 100,
                  height: 35,
                  child: TextFormField(
                    controller: _quantidadeVendidaController,
                    textAlignVertical: TextAlignVertical.bottom,
                    textAlign: TextAlign.end,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(8),
                      FilteringTextInputFormatter.digitsOnly,
                      _mascaraQuantidadeDoProduto(itemVenda.produto.unidade)
                    ],
                    decoration: const InputDecoration(
                      hintText: "0.000",
                      border: OutlineInputBorder(),
                    ),
                    onTap: () {
                      _quantidadeVendidaController.clear();
                    },
                    onEditingComplete: () {
                      calculaValorDoItemVendido(
                          index,
                          itemVenda,
                          _quantidadeVendidaController.text,
                          _valorVendidoController.text);
                    },
                  )),
              const SizedBox(width: 5),
              SizedBox(
                  width: 40,
                  child: Text(itemVenda.produto.unidade.toUpperCase())),
              const SizedBox(width: 20),
              SizedBox(
                  width: 100,
                  height: 35,
                  child: TextFormField(
                    //valor vendido
                    controller: _valorVendidoController,
                    textAlignVertical: TextAlignVertical.bottom,
                    textAlign: TextAlign.end,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(8),
                      FilteringTextInputFormatter.digitsOnly,
                      CentavosInputFormatter()
                    ],
                    decoration: const InputDecoration(
                      hintText: "0,00",
                      prefixText: "R\$",
                      border: OutlineInputBorder(),
                    ),
                    onTap: () {
                      _valorVendidoController.clear();
                    },
                    onEditingComplete: () {
                      calculaValorDoItemVendido(
                          index,
                          itemVenda,
                          _quantidadeVendidaController.text,
                          _valorVendidoController.text);
                    },
                  )),
              const SizedBox(width: 20),
              SizedBox(
                  width: 80,
                  child: Text(
                    //valor total da linha de produtos
                    'R\$ ${ConversorMoeda.converterDoubleEmTexto(itensVendidosProvider.valorTotalDoItemVenda(itemVenda).toStringAsFixed(2))}',
                    textAlign: TextAlign.end,
                  )),
              const SizedBox(width: 40),
              IconButton(
                  onPressed: () {
                    itensVendidosProvider.removeObjeto(itemVenda);
                  },
                  icon: const Icon(Icons.delete)),
            ],
          ),
        );
      },
    );
  }

  _mascaraQuantidadeDoProduto(String unidade) {
    if (unidade != "KG") {
      return RealInputFormatter();
    } else {
      return CentavosInputFormatter();
    }
  }

  calculaValorDoItemVendido(int index, ItemVenda itemVenda,
      String quantidadeVendida, String valorVenda) {
    double qtdItem = _converterTextoEmDouble(quantidadeVendida);
    double valorVendaItem = _converterTextoEmDouble(valorVenda);

    itemVenda.quantidadeVendida = qtdItem;
    itemVenda.valorVendido = valorVendaItem;

    itensVendidosProvider.atualizarItemVendido();
  }

  rodape() {
    return Container(
        margin: const EdgeInsets.all(8),
        child: Row(
          children: [
            SizedBox(width: 20),
            Expanded(
                child: Text(
                    'Total: R\$ ${itensVendidosProvider.valorTotalVenda.toStringAsFixed(2)}',
                    textAlign: TextAlign.start,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
            SizedBox(
                height: 40, width: 200, child: botaoFinalizarVenda(context)),
          ],
        ));
  }

  botaoFinalizarVenda(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(Icons.navigate_next),
      onPressed: () async {
        if (itensVendidosProvider.itensVendidos.isEmpty) {
          createAlertDialogNenhumProdutoAdionado(context);
        } else {
          clientesPdvProvider.clienteDaVenda =
              (await principalCtrl.clienteCtrl.buscarCliente(id: 1)).first;
          mudaTela();
        }
      },
      label: const Text(
        "Finalizar Venda",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  //FUNCAO DO FECHAR CAIXA
  createAlertDialogFecharCaixa(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Você tem certeza que deseja fechar o caixa?"),
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 50, 10),
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
                padding: const EdgeInsets.fromLTRB(0, 0, 100, 10),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    createAlertDialog_FecharCaixa(context);
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

  double _converterTextoEmDouble(String texto) {
    //String texto = _valorController.text;
    if (texto.isNotEmpty) {
      if (texto.contains('.') || texto.contains(',')) {
        texto = texto.replaceAll('.', ',').replaceAll(',', '.');
        print("TEXTO replaceAll $texto");
      } else {
        return double.parse(texto);
      }
      return double.parse(texto);
    }
    return 0;
  }

  Widget fieldValor() {
    return TextFormField(
      controller: _valorController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CentavosInputFormatter()
      ],
      validator: (value) {
        if (value!.isEmpty) {
          return "Informe o valor";
        } else if (double.parse(value) > 0) {
          return "Valor não pode ser 0";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Valor:",
        prefixIcon: Icon(Icons.monetization_on),
        border: OutlineInputBorder(),
        prefixText: "R\$",
      ),
    );
  }

  Widget fieldJustificativa() {
    return TextFormField(
      controller: _justificativaController,
      style: const TextStyle(fontSize: 17),
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return "Informe a justificativa";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Justificativa:",
        hintText: "Muito dinheiro no caixa",
        prefixIcon: Icon(Icons.description),
        border: OutlineInputBorder(),
      ),
    );
  }

  void _limparControllersDosTextsFields() {
    _justificativaController.clear();
    _valorController.clear();
    _pesquisaProdutoController.clear();
  }

// --------------------- NOVA VENDA ------------------------------
  Widget LimparVenda() {
    return Container(
      // margin: EdgeInsets.fromLTRB(0, 0, 30, 20),
      width: 100,
      height: 80,
      // color: Colors.white,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(color: Colors.blue),
            ),
          ),
        ),
        onPressed: () {
          createAlertDialogNovaVenda(context);
        },
        child: const Text(
          "LIMPAR VENDA",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  //FUNCAO NOVA VENDA
  createAlertDialogNovaVenda(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            alignment: Alignment.center,
            actionsAlignment: MainAxisAlignment.center,
            title: const Text("Você tem certeza que deseja limpar os campos?"),
            actions: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
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
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: MaterialButton(
                  onPressed: () {
                    _limparControllersDosTextsFields();
                    formasDePagamentoProvider.limpar();
                    itensVendidosProvider.limpar();
                    clientesPdvProvider.limpar();
                    principalCtrl.vendaGUI.criarVenda();
                    selectedContinuar = false;
                    Navigator.of(context).pop();
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

// -----------------------------------------------------------------

// ----------------------------------------------------- FECHAR CAIXA
  Widget FecharCaixa(BuildContext context) {
    return Container(
      // margin: EdgeInsets.fromLTRB(0, 0, 30, 20),
      width: 100,
      height: 80,
      // color: Colors.white,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(color: Colors.blue),
            ),
          ),
        ),
        onPressed: () {
          createAlertDialogFecharCaixa(context);
        },
        child: const Text(
          "FECHAR CAIXA",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
        // textColor: Colors.black,
        // highlightColor: Colors.white,
      ),
    );
  }

  createAlertDialog_FecharCaixa(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Column(
                    children: [
                      Text(
                        "Fechar Caixa",
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: 50,
                        width: 320,
                        margin: const EdgeInsets.all(10),
                        child: fieldValor(),
                      ),
                      Container(
                        height: 50,
                        width: 320,
                        margin: const EdgeInsets.all(10),
                        child: fieldJustificativa(),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: 150,
                        margin: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: () {
                            _limparControllersDosTextsFields();
                            Navigator.of(context).pop();
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
                        width: 150,
                        margin: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: () async {
                            double valorDoCaixa =
                                _converterTextoEmDouble(_valorController.text);

                            await principalCtrl.fechamentoCaixaGUI.fecharCaixa(
                                valor: valorDoCaixa,
                                justificativa: _justificativaController.text);

                            _limparControllersDosTextsFields();
                            principalCtrl.routeHomePage(context);
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
          ],
        );
      },
    );
  }

// -----------------------------------------------------------------------------

// ------------------------------------------------------------ SANGRIA E REFORÇO
  Widget SangriaReforco(BuildContext context) {
    return Container(
      // margin: EdgeInsets.fromLTRB(0, 0, 30, 20),
      width: 100,
      height: 80,
      // color: Colors.white,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(color: Colors.blue),
            ),
          ),
        ),
        onPressed: () {
          // Navigator.pushNamed(context, "/sangria");
          createAlertDialog_SangriaAporte(context);
        },
        child: const Text(
          "SANGRIA/REFORÇO",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
        // textColor: Colors.black,
        // highlightColor: Colors.white,
      ),
    );
  }

  createAlertDialog_SangriaAporte(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Radio(
                            value: 1,
                            groupValue: _value,
                            onChanged: (value) {
                              _value = 1;
                              print("Radio: $_value");
                            },
                          ),
                          const Text(
                            "Sangria",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Row(
                        children: [
                          Radio(
                            value: 2,
                            groupValue: _value,
                            onChanged: (value) {
                              _value = 2;
                            },
                          ),
                          const Text(
                            "Reforço",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 50,
                        width: 320,
                        margin: const EdgeInsets.all(10),
                        child: fieldValor(),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 50,
                        width: 320,
                        margin: const EdgeInsets.all(10),
                        child: fieldJustificativa(),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: 150,
                        margin: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: () {
                            _limparControllersDosTextsFields();
                            Navigator.of(context).pop();
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
                        width: 150,
                        margin: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_value == 1) {
                              print("SANGRIA");
                              double valorDaSangria = _converterTextoEmDouble(
                                  _valorController.text);
                              await principalCtrl.sangriaCaixaGUI.sangriaCaixa(
                                  valor: valorDaSangria,
                                  justificativa: _justificativaController.text);
                            } else if (_value == 2) {
                              print("APORTE");
                              double valorDoAporte = _converterTextoEmDouble(
                                  _valorController.text);
                              await principalCtrl.aporteCaixaGUI.aporteNoCaixa(
                                  valor: valorDoAporte,
                                  justificativa: _justificativaController.text);
                            }
                            ;
                            _limparControllersDosTextsFields();
                            Navigator.of(context).pop();
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
          ],
        );
      },
    );
  }

// ----------------------------------------------------------------

  botaoFlutuanteSelecionarCliente(BuildContext context,
      ClientePdvProvider clientePdvProvider, bool aPrazo) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(40),
        ),
        border: Border.all(
          width: 5,
          color: Colors.white70,
          style: BorderStyle.solid,
        ),
      ),
      child: FloatingActionButton(
          elevation: 10,
          tooltip: "Selecionar cliente",
          child: const Icon(Icons.person_add_alt_1_sharp, size: 30),
          onPressed: () async {
            await chamaAlertListaClientesPDV(
                context, clientePdvProvider, aPrazo);
          }),
    );
  }

// ----------------------------------------------------------------

  Widget BuscarProdutoEspecifico() {
    return SizedBox(
      width: 100,
      height: 80,
      // color: Colors.white,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(color: Colors.blue),
            ),
          ),
        ),
        onPressed: () async {
          await buscarProdutoEspecificoPDV(context, produtosProvider);
          if (produtosProvider.produtoSelecionado.id != 0) {
            itensVendidosProvider.construirItemVenda(principalCtrl,
                produtoSelecionado: produtosProvider.produtoSelecionado);
          }
          _pesquisarProdutoFocusNode.requestFocus();
        },
        child: const Text(
          "BUSCAR PRODUTO",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

createAlertDialogNenhumProdutoAdionado(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Você precisa adicionar ao menos um produto!"),
        );
      });
}

buscarProdutoEspecificoPDV(
    BuildContext context, ProdutoProvider produtosProvider) async {
  await produtosProvider.loadProdutos();
  produtosProvider.produtoSelecionado = Produto();
  // ignore: use_build_context_synchronously
  return await produtosEspecificacaoPDV(
    context,
    produtosProvider,
    Text("Identificar cliente na venda"),
  );
}
