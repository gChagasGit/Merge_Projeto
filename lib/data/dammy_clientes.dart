import '../modelo/Cliente.dart';

//final ou const
final DUMMY_CLIENTES = {
  '1': Cliente.novo(
      id: 1,
      nome: "Gustavo",
      telefone: "8574963614",
      cpf: "12345698745",
      diaPrevPag: 1,
      status: true)
};
