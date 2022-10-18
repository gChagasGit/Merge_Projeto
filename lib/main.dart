// ignore_for_file: unused_import, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/controle/UsuarioCtrl.dart';
import 'package:flutter_teste_msql1/dao/InventarioDAO.dart';
import 'package:flutter_teste_msql1/dao/UsuarioDAO.dart';
import 'package:flutter_teste_msql1/modelo/Usuario.dart';
import 'package:flutter_teste_msql1/provider/caixa/caixaProvider.dart';
import 'package:flutter_teste_msql1/provider/clientes.dart';
import 'package:flutter_teste_msql1/provider/inventario/inventarioProvider.dart';
import 'package:flutter_teste_msql1/provider/inventario/itensInventarioProvider.dart';
import 'package:flutter_teste_msql1/provider/itemEntrada/ItensEntradaProvider.dart';
import 'package:flutter_teste_msql1/provider/itemEntrada/registroEntradaProvider.dart';
import 'package:flutter_teste_msql1/provider/pagamento_a_prazo/pagamentoProvider.dart';
import 'package:flutter_teste_msql1/provider/pdv/clientesPdvProvider.dart';
import 'package:flutter_teste_msql1/provider/pdv/formasDePagamentoProvider.dart';
import 'package:flutter_teste_msql1/provider/pdv/itensVendidosProvider.dart';
import 'package:flutter_teste_msql1/provider/venda_relatorio/vendasProvider.dart';
import 'package:flutter_teste_msql1/util/BancoDadosConfig.dart';
import 'package:flutter_teste_msql1/views/login_page.dart';
import 'package:flutter_teste_msql1/views/view_Cliente/pagamentos_a_prazo_page.dart';
import 'package:flutter_teste_msql1/views/view_caixa/OperacoesDeCaixaPage.dart';
import 'package:flutter_teste_msql1/views/view_pdv/abrir_caixa.dart';
import 'package:flutter_teste_msql1/visao/ClienteGUI.dart';
import 'package:flutter_teste_msql1/visao/UsuarioGUI.dart';
import 'package:mysql1/mysql1.dart';

import 'package:provider/provider.dart';

import 'components/clientes_tile.dart';
import 'components/usuarios_tile.dart';
import 'modelo/Cliente.dart';
import 'modelo/Produto.dart';
import 'provider/clienteProvider.dart';
import 'provider/produtoProvider.dart';
import 'provider/usuarioProvider.dart';
import 'views/home_page.dart';
import 'views/view_clientes/cadastrarCliente.dart';
import 'views/view_clientes/editarCliente.dart';
import 'views/view_pdv/frente_caixa.dart';
import 'views/view_produtos/cadastrarProduto.dart';
import 'views/view_produtos/editarProduto.dart';
import 'views/view_usuarios/cadastrarUsuario.dart';
import 'views/view_usuarios/editarUsuario.dart';
import 'views/view_vendas/vendas_clientes_page.dart';
import 'views/view_vendas/vendas_page.dart';

Future<void> main() async {
  PrincipalCtrl _principalCtrl = PrincipalCtrl();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MyApp(_principalCtrl); // --> Tá funcionando
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
      //home: MyApp(), --> da erro por causa de BuildContext
    ),
  );
  //runApp(MyApp()); --> Funciona, porém não usar o material app, logo fica sem PT-BR
}

class MyApp extends StatelessWidget {
  PrincipalCtrl _principalCtrl;

  MyApp(this._principalCtrl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ClienteProvider(_principalCtrl),
        ),
        ChangeNotifierProvider(
          create: (context) => ProdutoProvider(_principalCtrl),
        ),
        ChangeNotifierProvider(
          create: (context) => UsuarioProvider(_principalCtrl),
        ),
        ChangeNotifierProvider(
          create: (context) => ClientePdvProvider(_principalCtrl),
        ),
        ChangeNotifierProvider(
          create: (context) => VendasProvider(_principalCtrl),
        ),
        ChangeNotifierProvider(
          create: (context) => PagamentoProvider(_principalCtrl),
        ),
        ChangeNotifierProvider(
          create: (context) => CaixaProvider(_principalCtrl),
        ),
        ListenableProvider<Clientes>(create: (context) => Clientes()),
        ListenableProvider<ItensVendidosProvider>(
            create: (context) => ItensVendidosProvider(_principalCtrl)),
        ListenableProvider<FormasDePagamentoProvider>(
          create: (context) => FormasDePagamentoProvider(),
        ),
        ListenableProvider<ProdutoProvider>(
            create: (context) => ProdutoProvider(_principalCtrl)),
        ListenableProvider<Clientes>(create: (context) => Clientes()),
        ListenableProvider<ItensInventarioProvider>(
            create: (context) => ItensInventarioProvider(_principalCtrl)),
        ListenableProvider<ItensEntradaProvider>(
            create: (context) => ItensEntradaProvider(_principalCtrl)),
        ListenableProvider<InventarioProvider>(
            create: (context) => InventarioProvider(_principalCtrl)),
        ListenableProvider<RegistroEntradaProvider>(
            create: (context) => RegistroEntradaProvider(_principalCtrl)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: _principalCtrl.rotas(_principalCtrl),
      ),
    );
  }
}
