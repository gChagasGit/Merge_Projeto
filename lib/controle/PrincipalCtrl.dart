// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_teste_msql1/controle/AutenticacaoCtrl.dart';
import 'package:flutter_teste_msql1/controle/CaixaCtrl.dart';
import 'package:flutter_teste_msql1/controle/ClienteCtrl.dart';
import 'package:flutter_teste_msql1/controle/FicharioClienteCtrl.dart';
import 'package:flutter_teste_msql1/controle/FormaDePagamentoCtrl.dart';
import 'package:flutter_teste_msql1/controle/InventarioCtrl.dart';
import 'package:flutter_teste_msql1/controle/ItemEntradaCtrl.dart';
import 'package:flutter_teste_msql1/controle/ItemInventarioCtrl.dart';
import 'package:flutter_teste_msql1/controle/ItemVendaCtrl.dart';
import 'package:flutter_teste_msql1/controle/OpValoresCaixaCtrl.dart';
import 'package:flutter_teste_msql1/controle/ProdutoCtrl.dart';
import 'package:flutter_teste_msql1/controle/UsuarioCtrl.dart';
import 'package:flutter_teste_msql1/controle/RegistroEntradaCtrl.dart';
import 'package:flutter_teste_msql1/controle/VendaCtrl.dart';
import 'package:flutter_teste_msql1/views/view_Cliente/pagamentos_a_prazo_page.dart';
import 'package:flutter_teste_msql1/views/view_caixa/OperacoesDeCaixaPage.dart';
import 'package:flutter_teste_msql1/views/view_clientes/cadastrarCliente.dart';
import 'package:flutter_teste_msql1/views/view_clientes/editarCliente.dart';
import 'package:flutter_teste_msql1/views/view_inventario/homeInventario.dart';
import 'package:flutter_teste_msql1/views/view_pdv/abrir_caixa.dart';
import 'package:flutter_teste_msql1/views/view_pdv/frente_caixa.dart';
import 'package:flutter_teste_msql1/views/view_vendas/vendas_clientes_page.dart';
import 'package:flutter_teste_msql1/views/view_vendas/vendas_page.dart';
import 'package:flutter_teste_msql1/visao/AberturaCaixaGUI.dart';
import 'package:flutter_teste_msql1/visao/AporteCaixaGUI.dart';
import 'package:flutter_teste_msql1/visao/CaixaGUI.dart';
import 'package:flutter_teste_msql1/visao/ClienteGUI.dart';
import 'package:flutter_teste_msql1/visao/EstoqueGUI.dart';
import 'package:flutter_teste_msql1/visao/FechamentoCaixaGUI.dart';
import 'package:flutter_teste_msql1/visao/FicharioClienteGUI.dart';
import 'package:flutter_teste_msql1/visao/FormaDePagamentoGUI.dart';
import 'package:flutter_teste_msql1/visao/InventarioGUI.dart';
import 'package:flutter_teste_msql1/visao/ItemEntradaGUI.dart';
import 'package:flutter_teste_msql1/visao/ItemInventarioGUI.dart';
import 'package:flutter_teste_msql1/visao/ItemVendaGUI.dart';
import 'package:flutter_teste_msql1/visao/ProdutoGUI.dart';
import 'package:flutter_teste_msql1/visao/RegistroEntradaGUI.dart';
import 'package:flutter_teste_msql1/visao/SangriaCaixaGUI.dart';
import 'package:flutter_teste_msql1/visao/UsuarioGUI.dart';
import 'package:flutter_teste_msql1/visao/loginGUI.dart';

import '../components/clientes_pdv.dart';
import '../components/clientes_tile.dart';
import '../components/produtos_tile.dart';
import '../components/usuarios_tile.dart';
import '../modelo/Cliente.dart';
import '../modelo/Inventario.dart';
import '../modelo/Produto.dart';
import '../modelo/RegistroEntrada.dart';
import '../modelo/Usuario.dart';
import '../util/PDF/gera_comprovante_pagamento.dart';
import '../util/PDF/gera_cupom.dart';
import '../util/PDF/modelo_pdf/client.dart';
import '../util/PDF/modelo_pdf/invoice.dart';
import '../util/PDF/modelo_pdf/product.dart';
import '../views/home_page.dart';
import '../views/login_page.dart';
import '../views/view_inventario/acessarInventario.dart';
import '../views/view_inventario/novoInventario.dart';
import '../views/view_itemEntrada/acessarRegistroEntrada.dart';
import '../views/view_itemEntrada/homeRegistroEntrada.dart';
import '../views/view_itemEntrada/novoItemEntrada.dart';
import '../views/view_produtos/cadastrarProduto.dart';
import '../views/view_produtos/editarProduto.dart';
import '../views/view_usuarios/cadastrarUsuario.dart';
import '../views/view_usuarios/editarUsuario.dart';
import '../visao/VendaGUI.dart';

class PrincipalCtrl {
  // View's
  late LoginGUI loginGUI;
  late AberturaCaixaGUI aberturaCaixaGUI;
  late AporteCaixaGUI aporteCaixaGUI;
  late CaixaGUI caixaGUI;
  late ClienteGUI clienteGUI;
  late EstoqueGUI estoqueGUI;
  late FechamentoCaixaGUI fechamentoCaixaGUI;
  late InventarioGUI inventarioGUI;
  late ItemEntradaGUI itemEntradaGUI;
  late ItemInventarioGUI itemInventarioGUI;
  late ItemVendaGUI itemVendaGUI;
  late ProdutoGUI produtoGUI;
  late RegistroEntradaGUI registroEntradaGUI;
  late SangriaCaixaGUI sangriaCaixaGUI;
  late UsuarioGUI usuarioGUI;
  late VendaGUI vendaGUI;
  late FormaDePagamentoGUI formaDePagamentoGUI;
  late FicharioClienteGUI ficharioClienteGUI;

  //Controles
  late AutenticacaoCtrl autenticacaoCtrl;
  late CaixaCrtl caixaCrtl;
  late ClienteCtrl clienteCtrl;
  late InventarioCtrl inventarioCtrl;
  late ItemEntradaCtrl itemEntradaCtrl;
  late ItemInventarioCtrl itemInventarioCtrl;
  late ItemVendaCtrl itemVendaCtrl;
  late OpValoresCaixaCrtl opValoresCaixaCrtl;
  late ProdutoCtrl produtoCtrl;
  late RegistroEntradaCtrl registroEntradaCtrl;
  late UsuarioCtrl usuarioCtrl;
  late VendaCtrl vendaCtrl;
  late FormaDePagamentoCtrl formaDePagamentoCtrl;
  late FicharioClienteCtrl ficharioClienteCtrl;

  PrincipalCtrl() {
    // Inicializando Controles
    usuarioCtrl = UsuarioCtrl();
    autenticacaoCtrl = AutenticacaoCtrl(usuarioCtrl);
    caixaCrtl = CaixaCrtl();
    clienteCtrl = ClienteCtrl();
    inventarioCtrl = InventarioCtrl();
    itemEntradaCtrl = ItemEntradaCtrl();
    itemInventarioCtrl = ItemInventarioCtrl();
    itemVendaCtrl = ItemVendaCtrl();
    opValoresCaixaCrtl = OpValoresCaixaCrtl();
    produtoCtrl = ProdutoCtrl();
    registroEntradaCtrl = RegistroEntradaCtrl();
    vendaCtrl = VendaCtrl();
    formaDePagamentoCtrl = FormaDePagamentoCtrl(vendaCtrl);
    ficharioClienteCtrl = FicharioClienteCtrl(
        vendaCtrl, itemVendaCtrl, usuarioCtrl, produtoCtrl, clienteCtrl);

    // Inicializando View's
    usuarioGUI = UsuarioGUI(usuarioCtrl);
    loginGUI = LoginGUI(autenticacaoCtrl);
    clienteGUI = ClienteGUI(clienteCtrl);
    produtoGUI = ProdutoGUI(produtoCtrl);

    estoqueGUI = EstoqueGUI(produtoCtrl);

    caixaGUI = CaixaGUI(caixaCrtl, opValoresCaixaCrtl, usuarioCtrl);
    aberturaCaixaGUI = AberturaCaixaGUI(
        caixaCrtl, opValoresCaixaCrtl, usuarioCtrl, autenticacaoCtrl);
    aporteCaixaGUI = AporteCaixaGUI(caixaCrtl, opValoresCaixaCrtl, usuarioCtrl);
    sangriaCaixaGUI =
        SangriaCaixaGUI(caixaCrtl, opValoresCaixaCrtl, usuarioCtrl);
    fechamentoCaixaGUI =
        FechamentoCaixaGUI(caixaCrtl, opValoresCaixaCrtl, usuarioCtrl);

    itemInventarioGUI =
        ItemInventarioGUI(inventarioCtrl, itemInventarioCtrl, produtoCtrl);
    inventarioGUI = InventarioGUI(inventarioCtrl, usuarioCtrl);

    registroEntradaGUI = RegistroEntradaGUI(registroEntradaCtrl, usuarioCtrl);
    itemEntradaGUI =
        ItemEntradaGUI(itemEntradaCtrl, registroEntradaCtrl, produtoCtrl);

    itemVendaGUI = ItemVendaGUI();
    vendaGUI = VendaGUI(vendaCtrl, clienteCtrl, usuarioCtrl, itemVendaCtrl,
        caixaCrtl, produtoCtrl);
    formaDePagamentoGUI = FormaDePagamentoGUI(formaDePagamentoCtrl);
    ficharioClienteGUI = FicharioClienteGUI(ficharioClienteCtrl);
  }

//------------------- ROTAS PARA TELAS E SUAS FUNÇÕES -----------------------

  final String _LOGIN_PAGE = '/';
  final String _HOME_PAGE = '/homepage';
  final String _FRENTE_CAIXA = '/frente_caixa';
  final String _ABRIR_CAIXA = '/abrir_caixa';
  final String _CLIENTES = '/clientes';
  final String _CADASTRAR_CLIENTE = '/cadastrarCliente';
  final String _EDITAR_CLIENTE = '/editarCliente';
  final String _PRODUTOS = '/produtos';
  final String _CADASTRAR_PRODUTO = '/cadastrarProduto';
  final String _EDITAR_PRODUTO = '/editarProduto';
  final String _USUARIOS = '/usuarios';
  final String _CADASTRAR_USUARIO = '/cadastrarUsuario';
  final String _EDITAR_USUARIO = '/editarUsuario';
  final String _VENDAS = '/vendas';
  final String _VENDAS_CLIENTES = '/vendasClientes';
  final String _PAGAMENTO_PRAZO = '/pagamentosPrazo';
  final String _HOME_INVENTARIO = '/homeInventario';
  final String _ACESSAR_INVENTARIO = '/acessarInventario';
  final String _NOVO_INVENTARIO = '/novoInventario';
  final String _OPERACOES_CAIXA = '/operacoesCaixa';
  final String _HOME_REGISTRO_ENTRADA = '/homeRegistroEntrada';
  final String _ACESSAR_REGISTRO_ENTRADA = '/acessarRegistroEntrada';
  final String _NOVO_REGISTRO_ENTRADA = '/novoRegistroEntrada';

  Map<String, Widget Function(BuildContext context)> rotas(
      PrincipalCtrl principalCtrl) {
    return {
      _LOGIN_PAGE: (context) => LoginPage(principalCtrl),
      _HOME_PAGE: (context) => HomePage("Mercado Carneiro", principalCtrl),
      _FRENTE_CAIXA: (context) => FrenteCaixa(principalCtrl),
      _ABRIR_CAIXA: (context) => AbrirCaixa(principalCtrl),
      _CLIENTES: (context) => ClienteTile(principalCtrl),
      _CADASTRAR_CLIENTE: (context) =>
          CadastrarCliente(clienteCtrl: principalCtrl.clienteCtrl),
      _EDITAR_CLIENTE: (context) =>
          EditarCliente(clienteCtrl: principalCtrl.clienteCtrl),
      _PRODUTOS: (context) => ProdutoTile(principalCtrl),
      _CADASTRAR_PRODUTO: (context) =>
          CadastrarProduto(produtoCtrl: principalCtrl.produtoCtrl),
      _EDITAR_PRODUTO: (context) =>
          EditarProduto(produtoCtrl: principalCtrl.produtoCtrl),
      _USUARIOS: (context) =>
          UsuarioTile(principalCtrl.usuarioCtrl, principalCtrl),
      _CADASTRAR_USUARIO: (context) =>
          CadastrarUsuario(usuarioCtrl: principalCtrl.usuarioCtrl),
      _EDITAR_USUARIO: (context) =>
          EditarUsuario(usuarioCtrl: principalCtrl.usuarioCtrl),
      _VENDAS: (context) => VendasPage(principalCtrl),
      _VENDAS_CLIENTES: (context) => VendasClientesPage(principalCtrl),
      _PAGAMENTO_PRAZO: ((context) => PagamentosPrazoPage(principalCtrl)),
      _HOME_INVENTARIO: (context) => HomeInventario(principalCtrl),
      _ACESSAR_INVENTARIO: (context) => AcessarInventario(principalCtrl),
      _NOVO_INVENTARIO: (context) => NovoInventario(principalCtrl),
      _OPERACOES_CAIXA: ((context) => OperacoesCaixaPage(principalCtrl)),
      _HOME_REGISTRO_ENTRADA: (context) => HomeRegistroEntrada(principalCtrl),
      _ACESSAR_REGISTRO_ENTRADA: (context) =>
          AcessarRegistroEntrada(principalCtrl),
      _NOVO_REGISTRO_ENTRADA: (context) => NovoItemEntrada(principalCtrl),
    };
  }

  routeNovaVendaFrenteDeCaixa(
      BuildContext context, PrincipalCtrl principalCtrl) async {
    await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => FrenteCaixa(principalCtrl)),
        (Route<dynamic> route) => false);
  }

  Future<void> routeAbrirTela_LoginPage(BuildContext context) async {
    await Navigator.pushNamed(context, _LOGIN_PAGE);
  }

  Future<void> routeHomePage(BuildContext context) async {
    await Navigator.pushNamed(context, _HOME_PAGE);
  }

  Future<void> routeAbrirTela_FrenteCaixa(BuildContext context) async {
    if (vendaCtrl.venda.id == 0) {
      vendaGUI.criarVenda();
    }
    await Navigator.pushNamed(context, _FRENTE_CAIXA);
  }

  Future<void> routeAbrirTela_AbrirCaixa(BuildContext context) async {
    await Navigator.pushNamed(context, _ABRIR_CAIXA);
  }

  Future<void> routeClientes(BuildContext context) async {
    await Navigator.pushNamed(context, _CLIENTES);
  }

  Future<void> routeCadastrarClientes(BuildContext context) async {
    await Navigator.pushNamed(context, _CADASTRAR_CLIENTE);
  }

  Future<void> routeEditarClientes(
      BuildContext context, Cliente cliente) async {
    await Navigator.pushNamed(context, _EDITAR_CLIENTE, arguments: cliente);
  }

  Future<void> routeProdutos(BuildContext context) async {
    await Navigator.pushNamed(context, _PRODUTOS);
  }

  Future<void> routeCadastrarProdutos(BuildContext context) async {
    await Navigator.pushNamed(context, _CADASTRAR_PRODUTO);
  }

  Future<void> routeEditarProdutos(
      BuildContext context, Produto produto) async {
    await Navigator.pushNamed(context, _EDITAR_PRODUTO, arguments: produto);
  }

  Future<void> routeUsuarios(BuildContext context) async {
    await Navigator.pushNamed(context, _USUARIOS);
  }

  Future<void> routeCadastrarUsuarios(BuildContext context) async {
    await Navigator.pushNamed(context, _CADASTRAR_USUARIO);
  }

  Future<void> routeEditarUsuarios(
      BuildContext context, Usuario usuario) async {
    await Navigator.pushNamed(context, _EDITAR_USUARIO, arguments: usuario);
  }

  Future<void> routeVendas(BuildContext context) async {
    await Navigator.pushNamed(context, _VENDAS);
  }

  Future<void> routeVendasClientes(BuildContext context) async {
    await Navigator.pushNamed(context, _VENDAS_CLIENTES);
  }

  Future<void> routePagamentosPrazoPage(BuildContext context) async {
    await Navigator.pushNamed(context, _PAGAMENTO_PRAZO);
  }

  Future<void> routeHomeInventario(BuildContext context) async {
    await Navigator.of(context).pushNamed(_HOME_INVENTARIO);
  }

  Future<void> routeAcessarInventario(
      BuildContext context, Inventario inventarioNovo) async {
    await Navigator.of(context)
        .pushNamed(_ACESSAR_INVENTARIO, arguments: inventarioNovo);
  }

  Future<void> routeNovoInventario(BuildContext context) async {
    await Navigator.of(context).pushNamed(_NOVO_INVENTARIO);
  }

  Future<void> routeAbrirTela_OperacoesCaixa(BuildContext context) async {
    await Navigator.of(context).pushNamed(_OPERACOES_CAIXA);
  }

  Future<void> routeHomeRegistroEntrada(BuildContext context) async {
    await Navigator.of(context).pushNamed(_HOME_REGISTRO_ENTRADA);
  }

  Future<void> routeAcessarRegistroEntrada(
      BuildContext context, RegistroEntrada registroEntradaNovo) async {
    await Navigator.of(context)
        .pushNamed(_ACESSAR_REGISTRO_ENTRADA, arguments: registroEntradaNovo);
  }

  Future<void> routeNovoRegistroEntrada(BuildContext context) async {
    await Navigator.of(context).pushNamed(_NOVO_REGISTRO_ENTRADA);
  }

  //-------------------------------------------------------- PDF --------------

  simularCriarDadosPDF(Invoice invoice, bool op) {
    if (op) {
      GenerateComprovantePDF generatePdf =
          GenerateComprovantePDF(invoice: invoice);
      generatePdf.generatePDFInvoice();
    } else {
      invoice.itensVendidos.forEach((element) {
        invoice.total += (element.valorVendido * element.quantidadeVendida);
      });
      //GeneratePDF generatePdf = GeneratePDF(invoice: invoice);
      GenerateCupomPDF generatePdf = GenerateCupomPDF(invoice: invoice);
      generatePdf.generatePDFInvoice();
    }
  }
}
