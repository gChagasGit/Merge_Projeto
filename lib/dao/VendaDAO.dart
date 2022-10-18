import 'package:flutter_teste_msql1/modelo/Cliente.dart';
import 'package:flutter_teste_msql1/modelo/Usuario.dart';
import 'package:flutter_teste_msql1/util/BancoDadosConfig.dart';
import 'package:flutter_teste_msql1/util/ConversorDataHora.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../modelo/Caixa.dart';
import '../modelo/Venda.dart';
import 'Dao.dart';

const String _tabela = "venda";
const String _id = "id";
const String _valor = "valor";
const String _desconto = "desconto";
const String _data = "data";
const String _cliente = "fkIdCliente";
const String _usuario = "fkIdUsuario";
const String _caixa = "fkIdCaixa";

class VendaDAO implements Dao<Venda> {
  late MySql _db;

  VendaDAO() {}

  Future<void> alterarDescontoDaVenda(double desconto, int idVenda) async {
    var result;

    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql = 'UPDATE $_tabela SET $_desconto=? WHERE $_id=?';
      List<Object?>? values = [desconto, idVenda];
      await conn.query(sql, values).then((value) {
        result = value;
      });
      conn.close();
    });
    return result;
  }

  Future<void> alterarClienteDaVenda(int fkIdCliente, int idVenda) async {
    var result;

    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql = 'UPDATE $_tabela SET $_cliente=? WHERE $_id=?';
      List<Object?>? values = [fkIdCliente, idVenda];
      await conn.query(sql, values).then((value) {
        result = value;
      });
      conn.close();
    });
    return result;
  }

  @override
  Future<void> alterar(Venda venda) async {
    var result;

    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql =
          'UPDATE $_tabela SET $_valor=?, $_desconto=?, $_data=?, $_cliente=?, $_usuario=? $_caixa=? WHERE $_id=?';
      List<Object?>? values = [
        venda.valor,
        venda.desconto,
        ConversorDataHora().dataTimeDartToSQL(venda.data),
        venda.cliente.id,
        venda.usuario.id,
        venda.caixa.id,
        venda.id
      ];
      await conn.query(sql, values).then((value) {
        result = value;
      });
      conn.close();
    });
    return result;
  }

  @override
  Future<Venda> buscaPorId(int id) async {
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
  Future<List<Venda>> buscarTodos(
      {int? fkIdCliente, PickerDateRange? range}) async {
    String where = "1";

    if (fkIdCliente != null) {
      where = "$_cliente = $fkIdCliente";
    }

    if (range != null) {
      String start = range.startDate!.toString().split(' ').first;
      String end = range.endDate!.toString().split(' ').first;
      if (fkIdCliente != null) {
        where =
            "v.$where AND $_data between '$start 00:00:00' AND '$end 23:59:59'";
      } else {
        where =
            "v.$_data between '$start 00:00:00' AND '$end 23:59:59'";
      }
    }

    //where DataRegistro between to_date( '28/04/2014', 'dd/mm/yyyy') and to_date( '28/04/2014', 'dd/mm/yyyy')

    var results;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      //String sql = "SELECT * FROM $_tabela WHERE $where ORDER BY $_id DESC";
      String sql =
          "SELECT v.id, v.valor, v.desconto, v.data, v.$_caixa, u.nome, c.nome FROM $_tabela as v, usuario as u, cliente as c WHERE $where AND c.id = v.fkIdCliente AND u.id = v.fkIdUsuario ORDER BY v.$_id DESC";
      await conn.query(sql).then((value) {
        results = toMap(value);
        print(">> [${results.length}] >>> $sql");
        return results;
      });
      conn.close();
    });
    return results;
  }

  @override
  Future<void> excluir(Venda venda) async {
    alterar(venda);
  }

  @override
  Future<int> salvar(Venda venda) async {
    var result;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql =
          'INSERT INTO $_tabela($_valor, $_desconto, $_data, $_cliente, $_usuario, $_caixa) VALUES (?,?,?,?,?,?)';
      List<Object?>? values = [
        venda.valor,
        venda.desconto,
        ConversorDataHora().dataTimeDartToSQL(venda.data),
        venda.cliente.id,
        venda.usuario.id,
        venda.caixa.id
      ];
      await conn.query(sql, values).then((value) {
        result = value.insertId;
      });
      conn.close();
    });
    return result;
  }

  List<Venda> toMap(var value) {
    //v.id, v.valor, v.desconto, v.data, v.$_caixa, u.nome, c.nome
    List<Venda> vendas = [];
    for (var v in value) {
      Cliente cli = Cliente();
      cli.nome = v[6];
      Usuario usu = Usuario();
      usu.nome = v[5];
      Caixa caixa = Caixa();
      caixa.id = v[4];
      Venda venda = Venda.DAO(v[0], v[1], v[2], v[3], cli, usu, caixa);
      vendas.add(venda);
    }
    return vendas;
  }
}
