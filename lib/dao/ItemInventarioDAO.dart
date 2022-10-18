import 'package:flutter_teste_msql1/dao/Dao.dart';
import 'package:flutter_teste_msql1/modelo/Inventario.dart';
import 'package:flutter_teste_msql1/modelo/ItemInventario.dart';
import 'package:flutter_teste_msql1/modelo/Produto.dart';

import '../util/BancoDadosConfig.dart';
import '../util/ConversorDataHora.dart';

const String _tabela = "iteminventario";
const String _id = "id";
const String _quantidade = "quantidade";
const String _produto = "fkIdProduto";
const String _inventario = "fkIdInventario";

class ItemInventarioDAO implements Dao<ItemInventario> {
  late MySql _db;

  @override
  Future<void> alterar(ItemInventario itemInventario) async {
    var result;
    _db = MySql();

    _db.BancoDadosConfig().then((conn) async {
      String sql =
          'UPDATE $_tabela SET $_quantidade=?, $_produto=?, $_inventario=? WHERE $_id=?';
      List<Object?>? values = [
        itemInventario.quantidade,
        itemInventario.produto.id,
        itemInventario.inventario.id,
        itemInventario.id
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
  Future<ItemInventario> buscaPorId(int id) async {
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
  Future<List<ItemInventario>> buscarTodos({int? fkIdInventario}) async {
    String where = "1";

    if (fkIdInventario != null) {
      where = "$_inventario = $fkIdInventario";
    }

    var results;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      // String sql = "SELECT * FROM $_tabela WHERE $where";
      // "select it.id, p.id, p.cod, p.descricao, it.quantidade from $_tabela as it, produto as p where p.id == it.fkIdProduto"
      // String sql = "SELECT * FROM $_tabela WHERE $where";

      String sql =
          "select it.id, it.quantidade, i.id, p.id, p.cod, p.descricao from iteminventario as it, produto as p, inventario as i WHERE $where and p.id = it.fkIdProduto and it.fkIdInventario = i.id;";
      await conn.query(sql).then((value) {
        results = toMap(value);
        return results;
      });
      // print("buscarTodos | Consulta realizada: ${results}");
      conn.close();
    });
    return results;
  }

  @override
  Future<void> excluir(ItemInventario itemInventario) async {
    await alterar(itemInventario);
  }

  @override
  Future<int> salvar(ItemInventario itemInventario) async {
    var result;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql =
          'INSERT INTO $_tabela($_quantidade, $_inventario, $_produto) VALUES (?,?,?)';
      List<Object?>? values = [
        itemInventario.quantidade,
        itemInventario.inventario.id,
        itemInventario.produto.id
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

  List<ItemInventario> toMap(var value) {
    // it.id, it.quant,i.id, p.id, p.cod, p.desc,
    List<ItemInventario> itensInventariados = [];
    for (var v in value) {
      //int id, double quantidade, Inventario inventario, Produto produto
      Inventario inventario = Inventario();
      inventario.id = v[2];
      Produto produto = Produto();
      produto.id = v[3];
      produto.cod = v[4];
      produto.descricao = v[5];
      ItemInventario it = ItemInventario.DAO(v[0], v[1], inventario, produto);
      itensInventariados.add(it);
    }
    return itensInventariados;
  }

  // List<ItemInventario> toMap(var value) {
  //   // it.id, p.id, i.id,it.quant, p.cod, p.desc,

  //   List<ItemInventario> itensInventariados = [];
  //   for (var v in value) {
  //     //int id, double quantidade, Inventario inventario, Produto produto
  //     Inventario inventario = Inventario();
  //     inventario.id = v[2];
  //     Produto produto = Produto();
  //     produto.id = v[3];
  //     ItemInventario it = ItemInventario.DAO(v[0], v[1], inventario, produto);
  //     itensInventariados.add(it);
  //   }
  //   return itensInventariados;
  // }
}
