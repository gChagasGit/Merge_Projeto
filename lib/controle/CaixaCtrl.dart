import 'package:flutter_teste_msql1/dao/CaixaDAO.dart';
import 'package:flutter_teste_msql1/modelo/Caixa.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CaixaCrtl {
  
  late Caixa _caixa;
  late List<Caixa> _caixas;
  late CaixaDAO _caixaDAO;

  CaixaCrtl() {
    _caixa = Caixa();
    _caixas = [];
    _caixaDAO = CaixaDAO();
  }

  void set caixa(Caixa caixa) {
    _caixa = caixa;
  }

  Caixa get caixa => _caixa;

  List<Caixa> get caixas => _caixas;

  CaixaDAO get caixaDAO => _caixaDAO;

  fechamentoDoCaixa(){
    _caixa = Caixa();
    _caixas.clear();
  }

  Future<void> salvarCaixa(Caixa caixa) async {
    _caixa = caixa;
    _caixa.id = await _caixaDAO.salvar(caixa);
    print("CaixaCtrl | caixaDAO.salvar | id: ${_caixa.id} | ${DateTime.now()}");
  }

  void alterarCaixa() {
    _caixaDAO.alterar(_caixa);
  }

  Future<void> buscarCaixa(int id) async {
    await _caixaDAO.buscaPorId(id).then((value) {
      _caixa = value;
    });
  }

  Future<List<Caixa>> buscarTodosOsCaixas({PickerDateRange? range, int? limite = 10, int? offset = 0}) async {
    await _caixaDAO.buscarTodos(range: range, limite: limite, offset: offset).then((value) {
      _caixas.clear();
      _caixas.addAll(value);
    });
    return _caixas;
  }

  // Future<int> buscarUltimoCaixaAberto() async {
  //   return await _caixaDAO.buscarUltimoCaixaAberto();
  // }

  bool isCaixaAberto() => (caixa.id != 0);
}
