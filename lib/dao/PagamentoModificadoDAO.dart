import 'package:flutter_teste_msql1/dao/Dao.dart';
import 'package:flutter_teste_msql1/modelo/Pagamento.dart';
import 'package:flutter_teste_msql1/modelo/PagamentoModificado.dart';
import 'package:flutter_teste_msql1/util/ConversorDataHora.dart';

import '../util/BancoDadosConfig.dart';

const String _tabela = "pagamentomodificado";
const String _id = "id";
const String _novoValor = "novoValor";
const String _dinheiro = "dinheiro";
const String _debito = "debito";
const String _credito = "credito";
const String _pix = "pix";
const String _dataModificado = "data";
const String _pagamentoModificado = "fkIdPagamento";

class PagamentoModificadoDAO implements Dao<PagamentoModificado> {
  late MySql _db;

  Future<List<PagamentoModificado>> buscaListaPorPagamento(
      int fkIdPagamento) async {
    var result;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql = "SELECT * FROM $_tabela WHERE $_pagamentoModificado = ?";
      await conn.query(sql, [fkIdPagamento]).then((value) {
        result = toMap(value);
        return result;
      });
      conn.close();
    });
    return result;
  }

  @override
  Future<void> alterar(PagamentoModificado pagamentoModificado) {
    // TODO: implement alterar
    throw UnimplementedError();
  }

  @override
  Future<PagamentoModificado> buscaPorId(int id) async {
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
  Future<List<PagamentoModificado>> buscarTodos() async {
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
  Future<void> excluir(PagamentoModificado pagamentoModificado) {
    // TODO: implement excluir
    throw UnimplementedError();
  }

  @override
  Future<int> salvar(PagamentoModificado pagamentoModificado) async {
    var result;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql =
          'INSERT INTO $_tabela($_dataModificado, $_novoValor, $_dinheiro, $_debito, $_credito, $_pix, $_pagamentoModificado) VALUES (?,?,?,?,?,?,?)';
      List<Object?>? values = [
        ConversorDataHora().dataTimeDartToSQL(pagamentoModificado.data),
        pagamentoModificado.novoValor,
        pagamentoModificado.dinheiro,
        pagamentoModificado.debito,
        pagamentoModificado.credito,
        pagamentoModificado.pix,
        pagamentoModificado.pagamento.id,
      ];
      await conn.query(sql, values).then((value) {
        result = value.insertId;
      });
      conn.close();
    });
    return result;
  }

  List<PagamentoModificado> toMap(var value) {
    List<PagamentoModificado> listaPagamentoModificados = [];
    for (var v in value) {
      Pagamento pagamento = Pagamento();
      pagamento.id = v[7];
      PagamentoModificado pagMod = PagamentoModificado.DAO(
          v[0], v[1], v[2], v[3], v[4], v[5], v[6], pagamento);
      listaPagamentoModificados.add(pagMod);
    }
    return listaPagamentoModificados;
  }
}
