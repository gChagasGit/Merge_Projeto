import 'package:flutter_teste_msql1/modelo/Produto.dart';
import 'package:flutter_teste_msql1/modelo/Venda.dart';
import 'package:flutter_teste_msql1/util/BancoDadosConfig.dart';

import '../modelo/ItemVenda.dart';
import 'Dao.dart';

const String _tabela = "itemvenda";
const String _id = "id";
const String _quantidadeVendida = "quantidadeVendida";
const String _valorVendido = "valorVendido";
const String _produto = "fkIdProduto";
const String _venda = "fkIdVenda";

class ItemVendaDAO implements Dao<ItemVenda> {

  late MySql _db;

  ItemVendaDAO(){}

  @override
  Future<void> alterar(ItemVenda itemVenda) async {
    var result;

    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql =
          'UPDATE $_tabela SET $_quantidadeVendida=?, $_valorVendido=?, $_produto=?, $_venda=? WHERE $_id=?';
      List<Object?>? values = [
        itemVenda.quantidadeVendida,
        itemVenda.valorVendido,
        itemVenda.produto.id, 
        itemVenda.venda.id,
        itemVenda.id
      ];
      await conn.query(sql, values).then((value) {
        result = value;
      });
      conn.close();
    });
    return result;
  }

  @override
  Future<ItemVenda> buscaPorId(int id) async {
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
  Future<List<ItemVenda>> buscarTodos({int? fkIdVenda}) async {
    
    String where = "1";
    
    if(fkIdVenda != null){
      where = "$_venda = $fkIdVenda";
    }

    var results;
    _db = MySql();
    
    await _db.BancoDadosConfig().then((conn) async {
      // String sql = "SELECT * FROM $_tabela WHERE $where";
      String sql = "SELECT it.id, it.quantidadeVendida, it.valorVendido, p.cod, p.descricao FROM itemvenda AS it, produto AS p WHERE $where AND it.fkIdProduto = p.id ORDER BY it.id DESC";
      await conn.query(sql).then((value) {
        results = toMap(value);
        return results;
      });
      conn.close();
    });
    return results;
  }

  @override
  Future<void> excluir(ItemVenda itemVenda) async {
    alterar(itemVenda);
  }

  @override
  Future<int> salvar(ItemVenda itemVenda) async {
    var result;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql =
          'INSERT INTO $_tabela($_quantidadeVendida, $_valorVendido, $_produto, $_venda) VALUES (?,?,?,?)';
      List<Object?>? values = [
        itemVenda.quantidadeVendida,
        itemVenda.valorVendido,
        itemVenda.produto.id,
        itemVenda.venda.id
      ];
      await conn.query(sql, values).then((value) {
        result = value.insertId;
      });
      conn.close();
    });
    return result;
  }

  List<ItemVenda> toMap(var value) {
    List<ItemVenda> ivs = [];
    //it.id, it.quantidadeVendida, it.valorVendido, p.cod, p.descricao
    for (var v in value) {
      Produto prod = Produto();
      prod.cod = v[3];
      prod.descricao = v[4];
      Venda vend = Venda();
      // vend.id = v[4];
      ItemVenda iv = ItemVenda.DAO(v[0], v[1], v[2], prod, vend);
      ivs.add(iv);
    }
    return ivs;
  }
}
