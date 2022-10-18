class ConversorDataHora {

  ConversorDataHora();

  String dataTimeDartToSQL(DateTime data) {
    String date = data.toString().split(".").first;
    return date;
  }

  DateTime dataTimeSQLToDart(String date) {
    //SQL: YYYY-MM-DD HH:mm:ss
    List<String> b = date.split("-");
    List<String> c = b[2].split(" ");
    List<String> d = c[1].split(":");
    int ano = int.parse(b[0]);
    int mes = int.parse(b[1]);
    int dia = int.parse(c[0]);
    int hora = int.parse(d[0]);
    int min = int.parse(d[1]);
    int seg = int.parse(d[2]);
    DateTime dt = DateTime(ano, mes, dia, hora, min, seg);
    return dt;
  }
}