import 'package:flutter/cupertino.dart';
import 'package:flutter_teste_msql1/controle/PrincipalCtrl.dart';
import 'package:flutter_teste_msql1/modelo/Caixa.dart';
import 'package:flutter_teste_msql1/modelo/OpValoresCaixa.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CaixaProvider with ChangeNotifier {
  late PrincipalCtrl principalCtrl;

  int numPages = 10;
  int currentPage = 0;
  int _limite = 5;

  Caixa caixaAtual = Caixa();

  //List<OpValoresCaixa> listaDeOperacoes = [];
  List<Caixa> listaDeCaixas = [];

  CaixaProvider(this.principalCtrl);

  Future<void> buscarListaCaixas({PickerDateRange? range}) async {
    limpar();
    contaQuantidadeDeRegistrosCaixa();
    await principalCtrl.caixaCrtl
        .buscarTodosOsCaixas(
            range: range, limite: _limite, offset: (currentPage * _limite))
        .then((value) {
      listaDeCaixas.addAll(value);
    });
    listaDeCaixas.forEach((element) async {
      await principalCtrl.opValoresCaixaCrtl
          .buscarOperacaoPorCaixa(element.id)
          .then((value) {
        element.operacoes.addAll(value);
        if (listaDeCaixas.last.operacoes.isNotEmpty) {
          notifyListeners();
        }
      });
    });
  }

  contaQuantidadeDeRegistrosCaixa({PickerDateRange? range}) async {
    int quant = await principalCtrl.caixaCrtl.caixaDAO
        .contaQuantidadeDeRegistrosCaixa(range: range);
    numPages = (quant / _limite).ceil();
    if (numPages == 0) {
      numPages = 1;
    }
  }

  limpar() {
    caixaAtual = Caixa();
    listaDeCaixas.clear();
    notifyListeners();
  }
}
