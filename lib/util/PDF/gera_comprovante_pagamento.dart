import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'modelo_pdf/invoice.dart';

class GenerateComprovantePDF {
  Invoice invoice;
  GenerateComprovantePDF({
    required this.invoice,
  });

  /// Cria e Imprime a fatura
  generatePDFInvoice() async {
    final pw.Document doc = pw.Document();
    final pw.Font customFont =
        pw.Font.ttf((await rootBundle.load('lib/assets/RobotoSlabt.ttf')));
    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
            margin: pw.EdgeInsets.zero,
            theme:
                pw.ThemeData(defaultTextStyle: pw.TextStyle(font: customFont))),
        build: (context) => _buildContent(context),
      ),
    );
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  /// Constroi o conteúdo da página
  List<pw.Widget> _buildContent(pw.Context context) {
    return [
      pw.Padding(
          padding: pw.EdgeInsets.only(top: 10, left: 25, right: 25),
          child: _buildContentClient()),
      pw.Padding(
          padding: pw.EdgeInsets.only(top: 10, left: 25, right: 25),
          child: _contentTable()),
    ];
  }

  pw.Widget _buildContentClient() {
    return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _titleText('Mercado Carneiro'),
              pw.Text('CNPJ: 22.719.170/0001-63',
                  style: pw.TextStyle(
                    fontSize: 14,
                  )),
              _titleText('Cliente'),
              pw.Text(invoice.client.name,
                  style: pw.TextStyle(
                    fontSize: 20,
                  )),
            ],
          ),
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
            _titleText('COMPROVANTE PAGAMENTO'),
            _titleText('Número'),
            pw.Text(invoice.id.toString(),
                style: pw.TextStyle(
                  fontSize: 16,
                )),
            _titleText('Data'),
            pw.Text(DateFormat('dd/MM/yyyy').format(DateTime.now()),
                style: pw.TextStyle(
                  fontSize: 16,
                ))
          ])
        ]);
  }

  /// Retorna um texto com formatação própria para título
  _titleText(String text) {
    return pw.Padding(
        padding: pw.EdgeInsets.only(top: 8),
        child: pw.Text(text,
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)));
  }

  /// Constroi uma tabela com base nos produtos da fatura
  pw.Widget _contentTable() {
    return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                    'Valor da Conta: R\$ ${_formatValue(invoice.valorTotalAntigo)}',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.Text(
                    'Dinheiro: R\$: ${_formatValue(invoice.pagamentoModificado.dinheiro)}',
                    style: pw.TextStyle(fontSize: 18)),
                pw.Text(
                    'Crédito: R\$: ${_formatValue(invoice.pagamentoModificado.credito)}',
                    style: pw.TextStyle(fontSize: 18)),
                pw.Text(
                    'Débito: R\$: ${_formatValue(invoice.pagamentoModificado.debito)}',
                    style: pw.TextStyle(fontSize: 18)),
                pw.Text(
                    'PIX: R\$: ${_formatValue(invoice.pagamentoModificado.pix)}',
                    style: pw.TextStyle(fontSize: 18)),
                pw.Text('Troco: R\$: ${_formatValue(invoice.troco)}',
                    style: pw.TextStyle(fontSize: 18)),
                pw.Text('Novo Valor: R\$ ${_formatValue(invoice.total)}',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
              ]),
        ]);
  }

  /// Formata o valor informado na formatação pt/BR
  String _formatValue(double value) {
    final NumberFormat numberFormat = new NumberFormat("#,##0.00", "pt_BR");
    return numberFormat.format(value);
  }

  /// Formata o valor informado na formatação pt/BR
  String _formatValueQuatidade(double value) {
    final NumberFormat numberFormat = new NumberFormat("#,###0.000", "pt_BR");
    return numberFormat.format(value);
  }
}
