import 'package:flutter/animation.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../modelo/Produto.dart';
import '../util/BancoDadosConfig.dart';
import 'Dao.dart';

const String _tabela = "produto";
const String _id = "id";
const String _cod = "cod";
const String _descricao = "descricao";
const String _valorCompra = "valorCompra";
const String _valorVenda = "valorVenda";
const String _quantidadeAtual = "quantidadeAtual";
const String _quantidadeMinima = "quantidadeMinima";
// const String _quantidadeInventario = "quantidadeInventario";
const String _unidade = "unidade";
const String _status = "status";

class ProdutoDAO implements Dao<Produto> {
  late MySql _db;

  @override
  Future<void> alterar(Produto produto) async {
    var result;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql =
          'UPDATE $_tabela SET $_cod=?, $_descricao=?, $_valorCompra=?, $_valorVenda=?, $_quantidadeAtual=?, $_quantidadeMinima=?,$_unidade=?,$_status=? WHERE $_id=?';
      List<Object?>? values = [
        produto.cod,
        produto.descricao,
        produto.valorCompra,
        produto.valorVenda,
        produto.quantidadeAtual,
        produto.quantidadeMinima,
        produto.unidade,
        produto.status,
        produto.id
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
  Future<void> itemEntrada(Produto produto, double quantidadeAtual) async {
    produto.quantidadeAtual = quantidadeAtual;
    alterar(produto);
  }

  @override
  Future<Produto> buscaPorId(int id) async {
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
  Future<List<Produto>> buscarTodos(
      {int? limite = 10, int? offset = 0, bool? ativo}) async {
    String where = "1";

    if (ativo != null) {
      where = ativo ? "status = 1" : "status = 0";
    }

    var results;
    _db = MySql();

    String sql =
        "SELECT * FROM 'produto' ORDER BY 'id' DESC LIMIT $limite OFFSET $offset";

    await _db.BancoDadosConfig().then((conn) async {
      // String sql =
      //     "SELECT * FROM $_tabela WHERE $where ORDER BY $_descricao ASC";
      String sql =
          "SELECT * FROM $_tabela WHERE $where ORDER BY 'id' DESC LIMIT $limite OFFSET $offset";
      await conn.query(sql).then((value) {
        results = toMap(value);
        return results;
      });
      // print("buscarTodos | Consulta realizada: ${results}");
      conn.close();
    });
    return results;
  }

  // List<Produto> teste({bool? ativo}) {
  //   String where = "1";

  //   if (ativo != null) {
  //     where = ativo ? "status = 1" : "status = 0";
  //   }

  //   var results;
  //   _db = MySql();

  //   _db.BancoDadosConfig().then((conn) async {
  //     String sql = "SELECT * FROM $_tabela LIMIT 5";
  //     await conn.query(sql).then((value) {
  //       results = toMap(value);
  //       return results;
  //     });
  //     // print("buscarTodos | Consulta realizada: ${results}");
  //     // print("AQUI" + results.toString());
  //     conn.close();
  //   });
  //   return results;
  // }

  @override
  Future<void> excluir(Produto produto) async {
    produto.status = false;
    alterar(produto);
  }

  @override
  Future<int> salvar(Produto produto) async {
    var result;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql =
          'INSERT INTO $_tabela($_cod, $_descricao, $_valorCompra, $_valorVenda, $_quantidadeAtual, $_quantidadeMinima, $_unidade, $_status) VALUES (?,?,?,?,?,?,?,?)';
      List<Object?>? values = [
        produto.cod,
        produto.descricao,
        produto.valorCompra,
        produto.valorVenda,
        produto.quantidadeAtual,
        produto.quantidadeMinima,
        produto.unidade,
        produto.status
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

  Future<List<Produto>> buscarPorEspecificacao(
      {String? cod, String? descricao}) async {
    String sql = "";
    if (cod == null && descricao != null) {
      sql =
          "SELECT * FROM $_tabela WHERE $_status = 1 AND $_descricao LIKE '%$descricao%' ORDER BY $_descricao ASC";
    }
    if (descricao == null && cod != null) {
      sql = "SELECT * FROM $_tabela WHERE $_cod = $cod AND $_status = 1";
    }
    var results;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      await conn.query(sql).then((value) {
        results = toMap(value);
        return results;
      });
      print("buscarPorEspecificacao | Consulta realizada: ${results}");
      conn.close();
    });
    return results;
  }

  Future<int> contaQuantidadeDeProdutos({String? condicao = '1'}) async {
    String sql = "SELECT COUNT(id) FROM $_tabela";

    var result = 0;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      await conn.query(sql).then((value) {
        result = int.parse(value.toString().split(':').last.split('}').first);
        print("ProdutoDAO | contaQuantidadeDeProdutos: $result");
        conn.close();
        return result;
      });
    });
    return result;
  }

  List<Produto> toMap(var value) {
    List<Produto> prods = [];
    for (var v in value) {
      bool s = (v[9].toString().contains("1"));
      /*int id, String cod, String descricao, double valorCompra,
      double valorVenda, double quantidadeAtual, double quantidadeMinima, String unidade*/
      Produto p =
          Produto.DAO(v[0], v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8], s);
      prods.add(p);
    }
    return prods;
  }
}
