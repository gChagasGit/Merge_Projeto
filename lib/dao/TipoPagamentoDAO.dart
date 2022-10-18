import 'package:flutter_teste_msql1/dao/Dao.dart';
import 'package:flutter_teste_msql1/modelo/Pagamento.dart';
import 'package:flutter_teste_msql1/modelo/TipoPagamento.dart';
import 'package:flutter_teste_msql1/util/BancoDadosConfig.dart';

  const String _tabela = "tipopagamento";
  const String _id = "id";
  const String _descricao = "descricao";

class TipoPagamentoDAO implements Dao<TipoPagamento>{

  late MySql _db;

  TipoPagamentoDAO(){}

  @override
  Future<void> alterar(TipoPagamento tipoPagamento) async {
    var result;
    _db = MySql();
    
    _db.BancoDadosConfig().then((conn) async {
      String sql =
          'UPDATE $_tabela SET $_descricao=? WHERE $_id=?';
      List<Object?>? values = [
        tipoPagamento.descricao,
        tipoPagamento.id
      ];
      await conn.query(sql, values).then((value) {
        result = value;
        print('Result UP --> ${value.insertId}');
        //return result;
      });
      conn.close();
    });
    return result;
  }

  @override
  Future<TipoPagamento> buscaPorId(int id) async {
    var result;
    _db = MySql();
    
    await _db.BancoDadosConfig().then((conn) async {
      String sql = "SELECT * FROM $_tabela WHERE $_id = ?";
      await conn.query(sql, [id]).then((value) {
        result = toMap(value).first;
        return result;
      });
      conn.close();
    });
    return result;
  }

  @override
  Future<List<TipoPagamento>> buscarTodos() async {
    
    var results;
    _db = MySql();
    
    await _db.BancoDadosConfig().then((conn) async {
      String sql = "SELECT * FROM $_tabela WHERE 1";
      await conn.query(sql).then((value) {
        results = toMap(value);
        return results;
      });
      conn.close();
    });
    return results;
  }

  @override
  Future<void> excluir(TipoPagamento tipoPagamento) async {
    alterar(tipoPagamento);
  }

  @override
  Future<int> salvar(TipoPagamento tipoPagamento) async {
    var result;
    _db = MySql();
    
    await _db.BancoDadosConfig().then((conn) async {
      String sql =
          'INSERT INTO $_tabela($_id) VALUES (?)';
      List<Object?>? values = [
        tipoPagamento.id
      ];
      await conn.query(sql, values).then((value) {
        result = value.insertId;
      });
      conn.close();
    });
    return result;
  }
  
  List<TipoPagamento> toMap(var value){
    List<TipoPagamento> tipoPagamentos = [];
    for (var v in value) {
      // int id, String descricao
      TipoPagamento tp = TipoPagamento.DAO(v[0], v[1]);
      tipoPagamentos.add(tp);
    }
    return tipoPagamentos;
  }

}