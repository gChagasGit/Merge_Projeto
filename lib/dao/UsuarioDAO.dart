import 'package:flutter_teste_msql1/dao/InventarioDAO.dart';
import 'package:mysql1/mysql1.dart';

import '../modelo/Usuario.dart';
import '../util/BancoDadosConfig.dart';
import 'Dao.dart';

const String _tabela = "usuario";
const String _id = "id";
const String _nome = "nome";
const String _senha = "senha";
const String _cpf = "cpf";
const String _status = "status";

class UsuarioDAO implements Dao<Usuario> {
  late MySql _db;

  UsuarioDAO();

  @override
  Future<void> alterar(Usuario usuario) async {
    var result;

    _db = MySql();

    _db.BancoDadosConfig().then((conn) async {
      String sql =
          'UPDATE $_tabela SET $_nome=?, $_senha=?, $_cpf=?, $_status=? WHERE $_id=?';
      List<Object?>? values = [
        usuario.nome,
        usuario.senha,
        usuario.cpf,
        usuario.status,
        usuario.id
      ];
      await conn.query(sql, values).then((value) {
        result = value;
      });
      conn.close();
    });
    return result;
  }

  @override
  Future<List<Usuario>> buscarTodos(
      {int? limite = 10, int? offset = 0, bool? ativo}) async {
    String where = "1";
    if (ativo != null && ativo) {
      where = "$_status = 1";
    }

    var results;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql =
          "SELECT * FROM $_tabela WHERE $where ORDER BY 'id' DESC LIMIT $limite OFFSET $offset";
      await conn.query(sql).then((value) {
        results = toMap(value);
        return results;
      });
      conn.close();
    });
    return results;
  }

  Future<List<Usuario>> buscarPorEspecificacao(
      {String? nome, String? cpf}) async {
    String sql = "";
    if (nome == null && cpf != null) {
      sql = "SELECT * FROM $_tabela WHERE $_cpf = $cpf";
    }
    if (cpf == null && nome != null) {
      sql = "SELECT * FROM $_tabela WHERE $_nome LIKE '%$nome%'";
    }
    var results;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      await conn.query(sql).then((value) {
        results = toMap(value);
        print("UsuarioDAO | buscarPorEspecificacao | $results");
        return results;
      });
      conn.close();
    });
    return results;
  }

  @override
  Future<void> excluir(Usuario usuario) async {
    usuario.status = false;
    alterar(usuario);
  }

  @override
  Future<Usuario> buscaPorId(int id) async {
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
  Future<int> salvar(Usuario usuario) async {
    var result;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      String sql =
          'INSERT INTO $_tabela($_nome, $_senha, $_cpf, $_status) VALUES (?,?,?,?)';
      List<Object?>? values = [
        usuario.nome,
        usuario.senha,
        usuario.cpf,
        usuario.status
      ];
      await conn.query(sql, values).then((value) {
        result = value.insertId;
      });
      conn.close();
    });
    return result;
  }

  Future<int> contaQuantidadeDeUsuarios({String? condicao = '1'}) async {
    String sql = "SELECT COUNT(id) FROM $_tabela";

    var result = 0;
    _db = MySql();

    await _db.BancoDadosConfig().then((conn) async {
      await conn.query(sql).then((value) {
        result = int.parse(value.toString().split(':').last.split('}').first);
        print("UsuarioDAO | contaQuantidadeDeClientes: $result");
        conn.close();
        return result;
      });
    });
    return result;
  }

  List<Usuario> toMap(var value) {
    List<Usuario> users = [];
    for (var v in value) {
      bool s = (v[4].toString().contains("1"));
      Usuario u = Usuario.DAO(v[0], v[1], v[2], v[3], s);
      users.add(u);
    }
    return users;
  }
}
