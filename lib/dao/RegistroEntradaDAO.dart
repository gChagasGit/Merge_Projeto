import 'package:flutter_teste_msql1/dao/Dao.dart';
import 'package:flutter_teste_msql1/modelo/Usuario.dart';
import 'package:flutter_teste_msql1/util/BancoDadosConfig.dart';
import 'package:flutter_teste_msql1/util/ConversorDataHora.dart';
import '../modelo/RegistroEntrada.dart';

const String _tabela = "registroentrada";
const String _id = "id";
const String _dataHora = "dataHora";
const String _usuario = "fkIdUsuario";

class RegistroEntradaDAO implements Dao<RegistroEntrada> {
  late MySql _db;

  RegistroEntradaDAO() {}

  @override
  Future<void> alterar(RegistroEntrada registroEntrada) async {
    var result;

    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql = 'UPDATE $_tabela SET $_dataHora=?, $_usuario=? WHERE $_id=?';
      List<Object?>? values = [
        ConversorDataHora().dataTimeDartToSQL(registroEntrada.dataHora),
        registroEntrada.usuario.id,
        registroEntrada.id
      ];
      await conn.query(sql, values).then((value) {
        result = value;
      });
      conn.close();
    });
    return result;
  }

  @override
  Future<RegistroEntrada> buscaPorId(int id) async {
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
  Future<List<RegistroEntrada>> buscarTodos() async {
    var results;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql = "SELECT * FROM $_tabela WHERE 1";
      await conn.query(sql).then((value) {
        results = toMap(value);
        return results;
      });
      // print("buscarTodos | Consulta realizada: ${results}");
      conn.close();
    });
    // print("AQUI" + results.toString());
    return results;
  }

  @override
  Future<void> excluir(RegistroEntrada registroEntrada) async {
    alterar(registroEntrada);
  }

  @override
  Future<int> salvar(RegistroEntrada registroEntrada) async {
    var result;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql = 'INSERT INTO $_tabela($_dataHora, $_usuario) VALUES (?,?)';
      List<Object?>? values = [
        ConversorDataHora().dataTimeDartToSQL(registroEntrada.dataHora),
        registroEntrada.usuario.id
      ];
      await conn.query(sql, values).then((value) {
        result = value.insertId;
      });
      conn.close();
    });
    return result;
  }

  List<RegistroEntrada> toMap(var value) {
    List<RegistroEntrada> registros = [];
    for (var v in value) {
      Usuario user = Usuario();
      user.id = v[2];
      // user.nome = v[3];
      RegistroEntrada re = RegistroEntrada.DAO(v[0], v[1], user);
      registros.add(re);
    }
    return registros;
  }
}
