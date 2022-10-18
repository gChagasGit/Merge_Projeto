import 'package:flutter_teste_msql1/modelo/OpValoresCaixa.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../modelo/Caixa.dart';
import '../util/BancoDadosConfig.dart';
import 'Dao.dart';

const String _tabela = "caixa";
const String _id = "id";

const String _valorTotalDinheiro = "valorTotalDinheiro";
const String _valorTotalPrazo = "valorTotalPrazo";
const String _valorTotalPix = "valorTotalPix";
const String _valorTotalCredito = "valorTotalCredito";
const String _valorTotalDebito = "valorTotalDebito";

class CaixaDAO implements Dao<Caixa> {
  late MySql _db;

  CaixaDAO() {}

  @override
  Future<void> alterar(Caixa caixa) async {
    var result;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql =
          'UPDATE $_tabela SET $_valorTotalDinheiro=?, $_valorTotalPrazo=?, $_valorTotalPix=?, $_valorTotalCredito=?, $_valorTotalDebito=? WHERE $_id=?';
      List<Object?>? values = [
        caixa.valorTotalDinheiro,
        caixa.valorTotalPrazo,
        caixa.valorTotalPix,
        caixa.valorTotalCredito,
        caixa.valorTotalDebito,
        caixa.id
      ];
      await conn.query(sql, values).then((value) {
        result = value;
      });
      conn.close();
    });
    return result;
  }

  @override
  Future<Caixa> buscaPorId(int id) async {
    var result;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql = "SELECT * FROM $_tabela WHERE $_id = ?";
      await conn.query(sql, [id]).then((value) {
        result = value.first;
        return result;
      });
      conn.close();
    });
    return result;
  }

  @override
  Future<List<Caixa>> buscarTodos(
      {PickerDateRange? range, int? limite = 10, int? offset = 0}) async {
    String where = "1";

    if (range != null) {
      String start = range.startDate!.toString().split(' ').first;
      String end = range.endDate!.toString().split(' ').first;
      where = "op.dataHora between '$start 00:00:00' AND '$end 23:59:59'";
    }

    var results;
    _db = MySql();

    String sql =
        "SELECT * FROM `caixa` ORDER BY `id` DESC LIMIT $limite OFFSET $offset";

    await _db.BancoDadosConfig().then((conn) async {
      sql =
          "SELECT c.id, c.valorTotalDinheiro, c.valorTotalPrazo, c.valorTotalPix, c.valorTotalCredito, c.valorTotalDebito FROM caixa as c, opvalorescaixa as op WHERE op.fkIdCaixa = c.id AND op.tipo = 'ABERTURA' AND $where ORDER BY op.dataHora DESC LIMIT $limite OFFSET $offset";
      await conn.query(sql).then((value) {
        results = toMap(value);
        return results;
      });
      conn.close();
    });
    return results;
  }

  @override
  Future<void> excluir(Caixa caixa) async {
    await alterar(caixa);
  }

  @override
  Future<int> salvar(Caixa caixa) async {
    var result = 0;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql =
          'INSERT INTO $_tabela($_valorTotalDinheiro, $_valorTotalPrazo, $_valorTotalPix, $_valorTotalCredito, $_valorTotalDebito) VALUES (?,?,?,?,?)';
      await conn.query(sql, [
        caixa.valorTotalDinheiro,
        caixa.valorTotalPrazo,
        caixa.valorTotalPix,
        caixa.valorTotalCredito,
        caixa.valorTotalDebito,
      ]).then((value) {
        result = value.insertId!;
        print('salvar | Result --> ${value.insertId}');
        conn.close();
        return result;
      });
    });
    return result;
  }

  Future<int> contaQuantidadeDeRegistrosCaixa({PickerDateRange? range, String? condicao = '1'}) async {
    
    String sql = "SELECT COUNT(id) FROM $_tabela";

    if (range != null) {
      String start = range.startDate!.toString().split(' ').first;
      String end = range.endDate!.toString().split(' ').first;
      sql = "SELECT COUNT(c.id) FROM $_tabela as c, opvalorescaixa as op WHERE op.fkIdCaixa = c.id AND op.tipo = 'ABERTURA' AND op.dataHora between '$start 00:00:00' AND '$end 23:59:59'";
    }
    
    var result = 0;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      await conn.query(sql).then((value) {
        result = int.parse(value.toString().split(':').last.split('}').first);
        print("CaixaDAO | contaQuantidadeDeRegistrosCaixa: $result");
        conn.close();
        return result;
      });
    });
    return result;
  }

  List<Caixa> toMap(var value) {
    List<Caixa> caixas = [];
    for (var v in value) {
      Caixa c = Caixa.DAO(v[0], v[1], v[2], v[3], v[4], v[5]);
      caixas.add(c);
    }
    return caixas;
  }
}
