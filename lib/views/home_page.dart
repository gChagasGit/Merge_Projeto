import 'package:flutter/material.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/views/view_pdv/abrir_caixa.dart';

import '../main.dart';

class HomePage extends StatelessWidget {
  final String title;
  PrincipalCtrl principalCtrl;

  HomePage(this.title, this.principalCtrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.red,
          onPressed: () async {
            createAlertDialogTrocarUsuario(context, principalCtrl);
          },
          label: const Text("TROCAR USUÁRIO"),
          icon: const Icon(Icons.logout),
        ),
      ),
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.255,
        child: ListView(
          children: [
            // ignore: prefer_const_constructors
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white10, Colors.lightBlue],
                ),
              ),
              child: Container(
                child: Column(
                  children: [
                    Material(
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Image.asset(
                          'lib/assets/images/logo.PNG',
                          width: 98,
                          height: 98,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        "Mercado Carneiro",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CustomListTile(Icons.groups, "Clientes",
                () => {principalCtrl.routeClientes(context)}),
            CustomListTile(Icons.free_breakfast_rounded, "Produtos",
                () => {principalCtrl.routeProdutos(context)}),
            CustomListTile(Icons.people_rounded, "Usuários",
                () => {principalCtrl.routeUsuarios(context)}),
            CustomListTile(Icons.shopping_bag_rounded, "Vendas",
                () => {principalCtrl.routeVendasClientes(context)}),
            CustomListTile(Icons.monetization_on_sharp, "Pagamentos",
                () => {principalCtrl.routePagamentosPrazoPage(context)}),
            CustomListTile(Icons.inventory, "Inventário",
                () => {principalCtrl.routeHomeInventario(context)}),
            CustomListTile(Icons.calculate, "Caixa",
                () => {principalCtrl.routeAbrirTela_OperacoesCaixa(context)}),
            CustomListTile(Icons.add_shopping_cart_sharp, "R. Entrada",
                () => {principalCtrl.routeHomeRegistroEntrada(context)}),
          ],
        ),
      ),
      body: SizedBox(
        // size: Size(double.infinity, double.infinity),
        width: double.infinity,
        height: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            AbrirCaixa(principalCtrl),
          ],
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  IconData? icon;
  String text = "";
  void Function()? onTap;

  CustomListTile(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade400),
          ),
        ),
        child: InkWell(
          splashColor: Colors.red,
          onTap: onTap,
          // ignore: sized_box_for_whitespace
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon),
                //Texto
                Padding(
                  padding: const EdgeInsets.only(right: 170),
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

createAlertDialogTrocarUsuario(
    BuildContext context, PrincipalCtrl principalCtrl) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          alignment: Alignment.center,
          actionsAlignment: MainAxisAlignment.center,
          title: const Text("Relamente deseja trocar de usuário?"),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
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
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  principalCtrl.routeAbrirTela_LoginPage(context);
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
