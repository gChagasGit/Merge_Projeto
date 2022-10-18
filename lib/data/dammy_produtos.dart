
import '../modelo/Produto.dart';

//final ou const
final DUMMY_PRODUTOS = {
  '1': Produto.novo(
    id: 1,
    cod: "2299920",
    descricao: "Tomate",
    valorCompra: 2.00,
    valorVenda: 4.00,
    quantidadeAtual: 30,
    quantidadeMinima: 10,
    unidade: "KG",
    status: true,
  ),
};
