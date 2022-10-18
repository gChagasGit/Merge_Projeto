class ConversorMoeda {
  static String converterDoubleEmTexto(String texto) {
    if (texto.isNotEmpty) {
      if (texto.contains('.')) {
        texto = texto.replaceAll('.', ',');
        return texto;
      } else {
        return texto;
      }
    }
    return '';
  }
}
