// ignore_for_file: unused_import, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/controle/UsuarioCtrl.dart';
import 'package:flutter_teste_msql1/dao/InventarioDAO.dart';
import 'package:flutter_teste_msql1/dao/UsuarioDAO.dart';
import 'package:flutter_teste_msql1/modelo/Usuario.dart';
import 'package:flutter_teste_msql1/provider/clienteProvider.dart';
import 'package:flutter_teste_msql1/provider/clientes.dart';
import 'package:flutter_teste_msql1/provider/inventario/inventarioProvider.dart';
import 'package:flutter_teste_msql1/provider/inventario/itensInventarioProvider.dart';
import 'package:flutter_teste_msql1/provider/pagamento_a_prazo/pagamentoProvider.dart';
import 'package:flutter_teste_msql1/provider/pdv/clientesPdvProvider.dart';
import 'package:flutter_teste_msql1/provider/pdv/formasDePagamentoProvider.dart';
import 'package:flutter_teste_msql1/provider/pdv/itensVendidosProvider.dart';
import 'package:flutter_teste_msql1/provider/produtoProvider.dart';
import 'package:flutter_teste_msql1/provider/usuarioProvider.dart';
import 'package:flutter_teste_msql1/provider/venda_relatorio/vendasProvider.dart';
import 'package:flutter_teste_msql1/util/BancoDadosConfig.dart';
import 'package:flutter_teste_msql1/views/login_page.dart';
import 'package:flutter_teste_msql1/views/view_Cliente/pagamentos_a_prazo_page.dart';
import 'package:flutter_teste_msql1/views/view_pdv/abrir_caixa.dart';
import 'package:flutter_teste_msql1/visao/ClienteGUI.dart';
import 'package:flutter_teste_msql1/visao/UsuarioGUI.dart';
import 'package:mysql1/mysql1.dart';

import 'package:provider/provider.dart';

Future<void> main() async {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MyApp(); // --> Tá funcionando
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
  MyApp({Key? key}) : super(key: key);

  final PrincipalCtrl _principalCtrl = PrincipalCtrl();

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
        ListenableProvider<Clientes>(create: (context) => Clientes()),
        ListenableProvider<ItensVendidosProvider>(
            create: (context) => ItensVendidosProvider(_principalCtrl)),
        ListenableProvider<ItensInventarioProvider>(
            create: (context) => ItensInventarioProvider(_principalCtrl)),
        ListenableProvider<InventarioProvider>(
            create: (context) => InventarioProvider(_principalCtrl)),
        ListenableProvider<FormasDePagamentoProvider>(
          create: (context) => FormasDePagamentoProvider(),
        )
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
