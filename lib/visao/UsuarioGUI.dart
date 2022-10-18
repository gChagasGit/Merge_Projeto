import '../controle/UsuarioCtrl.dart';
import '../modelo/Usuario.dart';

class UsuarioGUI {

  late UsuarioCtrl _usuarioCtrl;

  UsuarioGUI(UsuarioCtrl usuarioCtrl){
    _usuarioCtrl = usuarioCtrl;
  }

  void simulaCadastroUsuario() {
    Usuario usuario = Usuario();
    usuario.nome = "Usuario4";
    usuario.cpf = "17223344487";
    usuario.senha = "senhaUsuario4";
    usuario.status = true;
    _usuarioCtrl.usuario = usuario;
    _usuarioCtrl.cadastrarUsuario(usuario);
  }

  Future<void> simulaAlteracaoUsuario() async {
    UsuarioCtrl usuarioCtrl = UsuarioCtrl();
    int i = usuarioCtrl.usuarios.length;
    if (i == 0) {
      await usuarioCtrl.buscarTodosUsuarios();
    }
    i = usuarioCtrl.usuarios.length - 1;
    usuarioCtrl.usuario = usuarioCtrl.usuarios.elementAt(i);
    usuarioCtrl.usuario.senha = "senhaDoUsuario3";
    //print("Usuário a ser atulizado: ${usuarioCtrl.usuario}");
    usuarioCtrl.alterarUsuario(_usuarioCtrl.usuario);
  }

  Future<void> simulaBuscarTodosUsuariosAtivos() async {
    UsuarioCtrl usuarioCtrl = UsuarioCtrl();
    await usuarioCtrl.buscarTodosUsuarios();
    usuarioCtrl.usuarios.forEach((element) {
      print(element);
    });
  }

  Future<void> simulaBuscarPorEspecificacao(
      {int? id, String? nome, String? cpf}) async {
    UsuarioCtrl usuarioCtrl = UsuarioCtrl();
    await usuarioCtrl.buscarUsuario(id: id, nome: nome, cpf: cpf);
    /*usuarioCtrl.usuarios.forEach((element) {
      print(element);
    });*/
  }
}
