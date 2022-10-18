// ignore_for_file: avoid_return_types_on_setters, unnecessary_getters_setters, file_names

class Usuario {
  late int id;
  late String nome;
  late String senha;
  late String cpf;
  late bool status;

  Usuario() {
    id = 0;
    nome = "";
    senha = "";
    cpf = "";
    status = false;
  }

  Usuario.DAO(this.id, this.nome, this.senha, this.cpf, this.status);

  Usuario.novo(
      {required int id,
      required String nome,
      required String senha,
      required String cpf,
      required bool status});

  @override
  String toString() {
    return "Usuário: Id: $id Nome: $nome, CPF: $cpf, Senha: $senha Status: $status";
  }
}
