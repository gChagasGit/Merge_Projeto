import 'package:flutter_teste_msql1/modelo/Caixa.dart';
import 'package:flutter_teste_msql1/modelo/OpValoresCaixa.dart';
import 'package:flutter_teste_msql1/modelo/Usuario.dart';
import 'package:flutter_teste_msql1/util/ConversorDataHora.dart';

import '../util/BancoDadosConfig.dart';
import 'Dao.dart';

late MySql _db;

const String _tabela = "opvalorescaixa";
const String _id = "id";
const String _tipo = "tipo";
const String _valor = "valor";
const String _dataHora = "dataHora";
const String _justificativa = "justificativa";
const String _usuario = "fkIdUsuario";
const String _caixa = "fkIdCaixa";

class OpValoresCaixaDAO implements Dao<OpValoresCaixa> {
  @override
  Future<void> alterar(OpValoresCaixa opvc) async {
    var result;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql =
          'UPDATE $_tabela SET $_tipo=?, $_valor=?, $_dataHora=?, $_justificativa=?, $_usuario=?, $_caixa=? WHERE $_id=?';
      List<Object?>? values = [
        opvc.tipo,
        opvc.valor,
        ConversorDataHora().dataTimeDartToSQL(opvc.horario),
        opvc.justificativa,
        opvc.usuario.id,
        opvc.caixa.id,
        opvc.id
      ];
      await conn.query(sql, values).then((value) {
        result = value;
      });
      conn.close();
    });
    return result;
  }

  @override
  Future<OpValoresCaixa> buscaPorId(int id) async {
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
  Future<List<OpValoresCaixa>> buscarTodos() async {
    var results;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql = "SELECT * FROM $_tabela ORDER BY id DESC";
      await conn.query(sql).then((value) {
        results = toMap(value);
        return results;
      });
      conn.close();
    });
    return results;
  }

  Future<List<OpValoresCaixa>> buscarPorEspecificacao(int id) async {
    var results;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      //SELECT op.id, op.tipo, op.valor, op.dataHora, op.justificativa, u.nome FROM $tabela as op, usuario as u WHERE $_caixa = $id AND op.fkIdUsuario = u.id
      String sql =
          "SELECT op.id, op.tipo, op.valor, op.dataHora, op.justificativa, u.nome FROM $_tabela as op, usuario as u WHERE $_caixa = $id AND op.fkIdUsuario = u.id ORDER BY id DESC";
      await conn.query(sql).then((value) {
        results = toMap(value, cond: true);
        return results;
      });
      conn.close();
    });
    return results;
  }

  @override
  Future<void> excluir(OpValoresCaixa opvc) async {
    // TODO: implement excluir
  }

  @override
  Future<int> salvar(OpValoresCaixa opvc) async {
    var result;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql =
          'INSERT INTO $_tabela($_tipo, $_valor, $_dataHora, $_justificativa, $_usuario, $_caixa) VALUES (?,?,?,?,?,?)';
      List<Object?>? values = [
        opvc.tipo,
        opvc.valor,
        ConversorDataHora().dataTimeDartToSQL(opvc.horario),
        opvc.justificativa,
        opvc.usuario.id,
        opvc.caixa.id
      ];
      await conn.query(sql, values).then((value) {
        result = value.insertId;
        print('salvar | Result --> ${value.insertId}');
        //return result;
      });
      conn.close();
    });
    return result;
  }

  List<OpValoresCaixa> toMap(var value, {bool? cond}) {
    List<OpValoresCaixa> ops = [];
    for (var v in value) {
      Caixa caixa = Caixa();
      Usuario usuario = Usuario();
      if (cond != null && cond) {
        usuario.nome = v[5];
      } else {
        usuario.id = v[5];
        caixa.id = v[6];
      }
      OpValoresCaixa op =
          OpValoresCaixa.DAO(v[0], v[1], v[2], v[3], v[4], usuario, caixa);
      ops.add(op);
    }
    return ops;
  }
}
