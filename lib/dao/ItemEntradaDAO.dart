import 'package:flutter_teste_msql1/dao/Dao.dart';
import 'package:flutter_teste_msql1/modelo/ItemEntrada.dart';
import 'package:flutter_teste_msql1/modelo/Produto.dart';
import 'package:flutter_teste_msql1/modelo/RegistroEntrada.dart';
import 'package:flutter_teste_msql1/util/BancoDadosConfig.dart';

const String _tabela = "itementrada";
const String _id = "id";
const String _quantidade = "quantidade";
const String _registroEntrada = "fkIdRegistroEntrada";
const String _produto = "fkIdProduto";

class ItemEntradaDAO implements Dao<ItemEntrada> {
  late MySql _db;

  ItemEntradaDAO() {}

  @override
  Future<void> alterar(ItemEntrada itemEntrada) async {
    var result;

    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql =
          'UPDATE $_tabela SET $_quantidade=?, $_registroEntrada=?, $_produto=? WHERE $_id=?';
      List<Object?>? values = [
        itemEntrada.quantidade,
        itemEntrada.registroEntrada.id,
        itemEntrada.produto.id,
        itemEntrada.id
      ];
      await conn.query(sql, values).then((value) {
        result = value;
      });
      conn.close();
    });
    return result;
  }

  @override
  Future<ItemEntrada> buscaPorId(int id) async {
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
  Future<List<ItemEntrada>> buscarTodos({int? fkIdRegistroEntrada}) async {
    String where = "1";

    if (fkIdRegistroEntrada != null) {
      where = "$_registroEntrada = $fkIdRegistroEntrada";
    }

    var results;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      // String sql = "SELECT * FROM $_tabela WHERE $where";
      String sql =
          "select it.id, it.quantidade, re.id, p.id, p.cod, p.descricao, p.valorCompra, p.quantidadeAtual from itementrada as it, produto as p, registroentrada as re WHERE $where and p.id = it.fkIdProduto and it.fkIdRegistroEntrada = re.id";
      await conn.query(sql).then((value) {
        results = toMap(value);
        return results;
      });
      // print("BUSCA PERSONALIZADA" + results.toString());
      conn.close();
    });
    return results;
  }

  @override
  Future<void> excluir(ItemEntrada itemEntrada) async {
    alterar(itemEntrada);
  }

  @override
  Future<int> salvar(ItemEntrada itemEntrada) async {
    var result;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql =
          'INSERT INTO $_tabela($_quantidade, $_registroEntrada, $_produto) VALUES (?,?,?)';
      List<Object?>? values = [
        itemEntrada.quantidade,
        itemEntrada.registroEntrada.id,
        itemEntrada.produto.id
      ];
      await conn.query(sql, values).then((value) {
        result = value.insertId;
      });
      conn.close();
    });
    return result;
  }

  List<ItemEntrada> toMap(var value) {
    List<ItemEntrada> itens = [];
    for (var v in value) {
      RegistroEntrada re = RegistroEntrada();
      re.id = v[2];
      Produto p = Produto();
      p.id = v[3];
      p.cod = v[4];
      p.descricao = v[5];
      p.valorCompra = v[6];
      p.quantidadeAtual = v[7];
      ItemEntrada iten = ItemEntrada.DAO(v[0], v[1], re, p);
      itens.add(iten);
    }
    // print("object" + itens.toString());
    return itens;
  }
}
