import 'package:flutter_teste_msql1/modelo/Caixa.dart';
import 'package:flutter_teste_msql1/modelo/TipoPagamento.dart';
import 'package:flutter_teste_msql1/modelo/Venda.dart';
import 'package:flutter_teste_msql1/util/BancoDadosConfig.dart';
import 'package:flutter_teste_msql1/util/ConversorDataHora.dart';

import '../modelo/Pagamento.dart';
import 'Dao.dart';

const String _tabela = "pagamento";
const String _id = "id";
const String _valor = "valor";
const String _novoValor = "novoValor";
const String _numParcelas = "numParcelas";
const String _dataPagamento = "dataPagamento";
const String _venda = "fkIdVenda";
const String _tipoPagamento = "fkIdTipoPagamento";

class PagamentoDAO implements Dao<Pagamento> {
  late MySql _db;

  Future<List<dynamic>> buscarPagamentosPrazoAberto({int? fkIdCliente}) async {
    //SELECT v.data, u.nome, p.valor, c.nome, c.diaPrevPag FROM venda as v, usuario as u, pagamento as p, cliente as c WHERE v.fkIdCliente = c.id AND c.status = 1 AND v.fkIdUsuario = u.id AND v.id = p.fkIdVenda AND p.dataPagamento = '2000-01-01 00:00:00' AND p.fkIdTipoPagamento = 2
    String where = "1";

    if (fkIdCliente != null) {
      where = "c.id = $fkIdCliente";
    }

    var results = [];
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql =
          "SELECT p.id, v.data, u.nome, p.valor, p.novoValor, c.nome, c.diaPrevPag "+
          "FROM venda as v, usuario as u, pagamento as p, cliente as c "+ 
          "WHERE v.fkIdCliente = c.id AND c.status = 1 AND v.fkIdUsuario = u.id "+
          "AND v.id = p.fkIdVenda AND p.dataPagamento = '2000-01-01 00:00:00' "+
          "AND p.fkIdTipoPagamento = 2 AND $where ORDER BY v.data ASC";
      await conn.query(sql).then((value) {
        value.forEach((element) {
          var result = element.toList();
          results.add(result);
        });
        return results;
      });
      conn.close();
    });
    return results;
  }

  @override
  Future<void> alterar(Pagamento pagamento) async {
    var result;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql =
          'UPDATE $_tabela SET $_valor=?, $_novoValor=?, $_numParcelas=?, $_dataPagamento=?, $_venda=? $_tipoPagamento=? WHERE $_id=?';
      List<Object?>? values = [
        pagamento.valor,
        pagamento.novoValor,
        pagamento.numParcelas,
        pagamento.dataPagamento,
        pagamento.venda.id,
        pagamento.tipoPagamento.id,
        pagamento.id
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

  Future<void> alterarConfirmacaoDePagamento(Pagamento pagamento) async {
    var result;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql = 'UPDATE $_tabela SET $_dataPagamento=? WHERE $_id=?';
      List<Object?>? values = [
        ConversorDataHora().dataTimeDartToSQL(pagamento.dataPagamento),
        pagamento.id
      ];
      await conn.query(sql, values).then((value) {
        result = value;
      });
      conn.close();
    });
    return result;
  }

  @override
  Future<Pagamento> buscaPorId(int id) async {
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
  Future<List<Pagamento>> buscarTodos({int? fkIdVenda}) async {
    String where = "1";

    if (fkIdVenda != null) {
      where = "$_venda = $fkIdVenda";
    }

    var results;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql = "SELECT * FROM $_tabela WHERE $where";
      await conn.query(sql).then((value) {
        results = toMap(value);
        return results;
      });
      conn.close();
    });
    return results;
  }

  @override
  Future<void> excluir(Pagamento pagamento) async {
    alterar(pagamento);
  }

  @override
  Future<int> salvar(Pagamento pagamento) async {
    var result;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql =
          'INSERT INTO $_tabela($_valor, $_novoValor, $_numParcelas, $_dataPagamento, $_venda, $_tipoPagamento) VALUES (?,?,?,?,?,?)';
      List<Object?>? values = [
        pagamento.valor,
        pagamento.novoValor,
        pagamento.numParcelas,
        ConversorDataHora().dataTimeDartToSQL(pagamento.dataPagamento),
        pagamento.venda.id,
        pagamento.tipoPagamento.id
      ];
      await conn.query(sql, values).then((value) {
        result = value.insertId;
      });
      conn.close();
    });
    return result;
  }

  List<Pagamento> toMap(var value) {
    List<Pagamento> pagamentos = [];
    for (var v in value) {
      // int id, double valor, double novoValor, int numParcelas, DateTime dataPagamento, Venda venda, TipoPagamento tipoPagamento
      Pagamento pag = Pagamento();
      pag.id = v[0];
      pag.valor = v[1];
      pag.novoValor = v[2];
      pag.numParcelas = v[3];
      pag.dataPagamento = v[4];

      Venda venda = Venda();
      venda.id = v[4];
      pag.venda = venda;

      TipoPagamento tipo = TipoPagamento();
      tipo.id = v[6];
      pag.tipoPagamento = tipo;

      pagamentos.add(pag);
    }
    return pagamentos;
  }
}
