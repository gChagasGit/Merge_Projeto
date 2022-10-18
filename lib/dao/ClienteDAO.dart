import 'package:flutter_teste_msql1/util/ConversorDataHora.dart';

import '../modelo/Cliente.dart';
import '../util/BancoDadosConfig.dart';
import 'Dao.dart';

const String _tabela = "cliente";
const String _id = "id";
const String _nome = "nome";
const String _telefone = "telefone";
const String _cpf = "cpf";
const String _diaPrevPag = "diaPrevPag";
const String _status = "status";

class ClienteDAO implements Dao<Cliente> {
  late MySql _db;

  ClienteDAO() {}

  @override
  Future<void> alterar(Cliente cliente) async {
    var result;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql =
          'UPDATE $_tabela SET $_nome=?, $_telefone=?, $_cpf=?, $_diaPrevPag=?, $_status=? WHERE $_id=?';
      List<Object?>? values = [
        cliente.nome,
        cliente.telefone,
        cliente.cpf,
        cliente.diaPrevPag,
        cliente.status,
        cliente.id
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
  Future<Cliente> buscaPorId(int id) async {
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
  Future<List<Cliente>> buscarTodos(
      {int? limite = 10, int? offset = 0, bool? ativo}) async {
    String where = "1";
    if (ativo != null && ativo) {
      where = "$_status = 1";
    }

    var results;
    _db = MySql();

    String sql =
        "SELECT * FROM 'cliente' ORDER BY 'id' DESC LIMIT $limite OFFSET $offset";

    await _db.BancoDadosConfig().then((conn) async {
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

  @override
  Future<void> excluir(Cliente cliente) async {
    cliente.status = false;
    alterar(cliente);
  }

  @override
  Future<int> salvar(Cliente cliente) async {
    var result;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql =
          'INSERT INTO $_tabela($_nome, $_telefone, $_cpf, $_diaPrevPag, $_status) VALUES (?,?,?,?,?)';
      List<Object?>? values = [
        cliente.nome,
        cliente.telefone,
        cliente.cpf,
        cliente.diaPrevPag,
        cliente.status
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

  Future<List<Cliente>> buscarPorEspecificacao({String? nome}) async {
    var results;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql =
          "SELECT * FROM $_tabela WHERE $_nome LIKE '%$nome%' OR $_cpf LIKE '%$nome%'";
      await conn.query(sql).then((value) {
        results = toMap(value);
        return results;
      });
      print("buscarPorEspecificacao | Consulta realizada: ${results}");
      conn.close();
    });
    return results;
  }

  Future<int> contaQuantidadeDeClientes({String? condicao = '1'}) async {
    String sql = "SELECT COUNT(id) FROM $_tabela";

    var result = 0;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      await conn.query(sql).then((value) {
        result = int.parse(value.toString().split(':').last.split('}').first);
        print("ClienteDAO | contaQuantidadeDeClientes: $result");
        conn.close();
        return result;
      });
    });
    return result;
  }

  List<Cliente> toMap(var value) {
    List<Cliente> clientes = [];
    for (var v in value) {
      bool s = (v[5].toString().contains("1"));
      //(int id, String nome, String telefone, String cpf, DateTime dataPrevPag, bool status)
      Cliente c = Cliente.DAO(v[0], v[1], v[2], v[3], v[4], s);
      clientes.add(c);
    }
    return clientes;
  }
}
