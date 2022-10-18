// ignore_for_file: unnecessary_getters_setters, avoid_return_types_on_setters, file_names

class Cliente {
  late int id;
  late String nome;
  late String telefone;
  late String cpf;
  late int diaPrevPag;
  late bool status;

  Cliente() {
    id = 0;
    nome = "";
    telefone = "";
    cpf = "";
    diaPrevPag = 1;
    status = false;
  }

  Cliente.DAO(
    this.id, this.nome, this.telefone, this.cpf, this.diaPrevPag, this.status
  );

  Cliente.novo(
      {required int id,
      required String nome,
      required String telefone,
      required String cpf,
      required int diaPrevPag,
      required bool status});

  @override
  String toString() {
    return "Cliente: Nome $nome, CPF: $cpf, Previsão Pagamento: $diaPrevPag, Status: $status";
  }
}
