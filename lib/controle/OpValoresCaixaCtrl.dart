import '../dao/OpValoresCaixaDAO.dart';
import '../modelo/OpValoresCaixa.dart';

class OpValoresCaixaCrtl{

  static const String ABERTURA = "ABERTURA";
  static const String FECHAMENTO = "FECHAMENTO";
  static const String APORTE = "APORTE";
  static const String SANGRIA = "SANGRIA";

  late OpValoresCaixa _opValoresCaixa;
  late List<OpValoresCaixa> _operacoesCaixa;
  late OpValoresCaixaDAO _opValoresCaixaDAO;

  OpValoresCaixaCrtl(){
    _opValoresCaixa = OpValoresCaixa();
    _operacoesCaixa = [];
    _opValoresCaixaDAO = OpValoresCaixaDAO();
  }

  void set opValoresCaixa(OpValoresCaixa opValoresCaixa){
    _opValoresCaixa = opValoresCaixa;
  }

  OpValoresCaixa get opValoresCaixa => _opValoresCaixa;

  List<OpValoresCaixa> get operacoesCaixa => _operacoesCaixa;

  OpValoresCaixaDAO get opValoresCaixaDAO => _opValoresCaixaDAO;

  void fechamentoDoCaixa(){
    _opValoresCaixa = OpValoresCaixa();
    _operacoesCaixa.clear();
  }

  Future<void> salvarOperacaoDeValoresDoCaixa() async {
    _opValoresCaixa.id = await _opValoresCaixaDAO.salvar(_opValoresCaixa);
  }

  void alterarOperacaoDeValoresDoCaixa(){
    _opValoresCaixaDAO.alterar(_opValoresCaixa);
  }

  Future<void> buscarTodasAsOperacaoDeValoresDoCaixa() async{
    await _opValoresCaixaDAO.buscarTodos().then((value) {
      _operacoesCaixa.clear();
      _operacoesCaixa.addAll(value);
    });
  }

  Future<List<OpValoresCaixa>> buscarOperacaoPorCaixa(int idCaixa) async{
    await _opValoresCaixaDAO.buscarPorEspecificacao(idCaixa).then((value) {
      _operacoesCaixa.clear();
      _operacoesCaixa.addAll(value);
    });
    return _operacoesCaixa;
  }
}