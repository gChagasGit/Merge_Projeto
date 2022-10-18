import 'package:flutter_teste_msql1/dao/Dao.dart';
import 'package:flutter_teste_msql1/modelo/Inventario.dart';
import 'package:flutter_teste_msql1/modelo/Usuario.dart';

import '../util/BancoDadosConfig.dart';
import '../util/ConversorDataHora.dart';

  const String _tabela = "inventario";
  const String _id = "id";
  const String _dataHora = "dataHora";
  const String _usuario = "fkIdUsuario";

class InventarioDAO implements Dao<Inventario>{

  late MySql _db;

  InventarioDAO(){}

  @override
  Future<void> alterar(Inventario inventario) async {
    var result;
    _db = MySql();
    
    await _db.BancoDadosConfig().then((conn) async {
      String sql =
          'UPDATE $_tabela SET $_dataHora=?, $_usuario=? WHERE $_id=?';
      List<Object?>? values = [
        ConversorDataHora().dataTimeDartToSQL(inventario.dataHora),
        inventario.usuario.id,
        inventario.id
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
  Future<Inventario> buscaPorId(int id) async {
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
  Future<List<Inventario>> buscarTodos() async {
    var results;
    _db = MySql();
    
    await _db.BancoDadosConfig().then((conn) async {
      String sql = "SELECT * FROM $_tabela WHERE 1 ORDER BY $_dataHora DESC";
      await conn.query(sql).then((value) {
        results = toMap(value);
        return results;
      });
      print("buscarTodos | Consulta realizada: ${results}");
      conn.close();
    });
    return results;
  }

  @override
  Future<void> excluir(Inventario inventario) async {
    await alterar(inventario);
  }

  @override
  Future<int> salvar(Inventario inventario) async {
    var result;
    _db = MySql();
    
    await _db.BancoDadosConfig().then((conn) async {
      String sql =
          'INSERT INTO $_tabela($_dataHora, $_usuario) VALUES (?,?)';
      List<Object?>? values = [
        ConversorDataHora().dataTimeDartToSQL(inventario.dataHora),
        inventario.usuario.id
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

  List<Inventario> toMap(var value){
    List<Inventario> inventarios = [];
    for (var v in value) {
      //int id, DateTime dataHota, Usuario usuario, List<ItemInventario> itensInventariados
      Inventario iv = Inventario();
      iv.id = v[0];
      iv.dataHora = v[1];

      Usuario usuario = Usuario();
      usuario.id = v[2];

      inventarios.add(iv);
    }
    return inventarios;
  }

}