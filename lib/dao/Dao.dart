abstract class Dao<T> {
  
  Future<T> buscaPorId(int id) async {
    // TODO: implement salvar
    throw UnimplementedError();
  }

  Future<int> salvar(T objeto) async {
    // TODO: implement salvar
    throw UnimplementedError();
  }

  Future<void> alterar(T objeto) async{}

  Future<void> excluir(T objeto) async{}

  Future<List<T>> buscarTodos();
}
