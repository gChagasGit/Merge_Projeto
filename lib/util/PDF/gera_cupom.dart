import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_teste_msql1/modelo/ItemVenda.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../modelo/Pagamento.dart';
import 'modelo_pdf/invoice.dart';
import 'modelo_pdf/product.dart';

class GenerateCupomPDF {
  Invoice invoice;
  GenerateCupomPDF({
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
        // header: _buildHeader,
        // footer: _buildPrice,
        build: (context) => _buildContent(context),
      ),
    );
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  /// Constroi o cabeçalho da página
  pw.Widget _buildHeader(pw.Context context) {
    return pw.Container(
        color: PdfColors.blue,
        height: 150,
        child: pw.Padding(
            padding: pw.EdgeInsets.all(16),
            child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Padding(
                            padding: pw.EdgeInsets.all(8), child: pw.PdfLogo()),
                        pw.Text('Fatura',
                            style: pw.TextStyle(
                                fontSize: 22, color: PdfColors.white))
                      ]),
                  pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Restaurante do Vale',
                          style: pw.TextStyle(
                              fontSize: 22, color: PdfColors.white)),
                      pw.Text('Rua dos Expedicionários',
                          style: pw.TextStyle(color: PdfColors.white)),
                      pw.Text('Curitiba',
                          style: pw.TextStyle(color: PdfColors.white)),
                    ],
                  )
                ])));
  }

  /// Constroi o conteúdo da página
  List<pw.Widget> _buildContent(pw.Context context) {
    return [
      pw.Padding(
          padding: pw.EdgeInsets.only(top: 10, left: 25, right: 25),
          child: _buildContentClient()),
      pw.Padding(
          padding: pw.EdgeInsets.only(top: 10, left: 25, right: 25),
          child: _contentTable(context)),
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
            _titleText('CUPOM NÃO FISCAL'),
            _titleText('Número da venda'),
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
  pw.Widget _contentTable(pw.Context context) {
    // Define uma lista usada no cabeçalho
    const tableHeaders = ['Cód.', 'Descrição', 'Quantidade', 'Preço', 'Total'];

    return pw.Column(
        //crossAxisAlignment: pw.CrossAxisAlignment.center,
        //mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Table.fromTextArray(
            border: null,
            cellAlignment: pw.Alignment.centerLeft,
            headerDecoration: pw.BoxDecoration(
              borderRadius: pw.BorderRadius.circular(2),
            ),
            headerHeight: 25,
            cellHeight: 40,
            // Define o alinhamento das células, onde a chave é a coluna
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.centerRight,
              3: pw.Alignment.center,
              4: pw.Alignment.centerRight,
            },
            // Define um estilo para o cabeçalho da tabela
            headerStyle: pw.TextStyle(
              fontSize: 15,
              color: PdfColors.black,
              fontWeight: pw.FontWeight.bold,
            ),
            // Define um estilo para a célula
            cellStyle: const pw.TextStyle(
              fontSize: 15,
            ),
            // Define a decoração
            rowDecoration: pw.BoxDecoration(border: pw.Border.all(width: 0.5)),
            headers: tableHeaders,
            // retorna os valores da tabela, de acordo com a linha e a coluna
            data: List<List<String>>.generate(
              invoice.itensVendidos.length,
              (row) => List<String>.generate(
                tableHeaders.length,
                (col) => _getValueIndex(invoice.itensVendidos[row], col),
              ),
            ),
          ),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                _titleText('Total: R\$ ${_formatValue(invoice.total)}'),
              ]),
          _pagamentos(invoice.pagamentos),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('Troco: R\$ ${_formatValue(invoice.troco)}',
                    style: pw.TextStyle(fontSize: 20))
              ]),
        ]);
  }

  _pagamentos(List<Pagamento> pagamentos) {
    try {
      return pw.ListView.builder(
        itemCount: pagamentos.length,
        itemBuilder: (context, index) {
          Pagamento element = pagamentos.elementAt(index);
          return pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                    '${element.tipoPagamento.descricao}: R\$:  ${_formatValue(element.valor)}',
                    style: pw.TextStyle(fontSize: 15))
              ]);
        },
      );
    } catch (e) {
      print("try --> $e");
    }
    ;
  }

  /// Retorna o valor correspondente a coluna
  String _getValueIndex(ItemVenda itemVenda, int col) {
    switch (col) {
      case 0:
        return itemVenda.produto.cod;
      case 1:
        return itemVenda.produto.descricao;
      case 2:
        return _formatValueQuatidade(itemVenda.quantidadeVendida);
      case 3:
        return _formatValue(itemVenda.valorVendido);
      case 4:
        return _formatValue(
            itemVenda.valorVendido * itemVenda.quantidadeVendida);
    }
    return '';
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

  /// Retorna o QrCode da fatura
  pw.Widget _buildQrCode(pw.Context context) {
    return pw.Container(
        height: 65,
        width: 65,
        child: pw.BarcodeWidget(
            barcode: pw.Barcode.fromType(pw.BarcodeType.QrCode),
            data: 'invoice_id=${invoice.id}',
            color: PdfColors.white));
  }

  /// Retorna o rodapé da página
  pw.Widget _buildPrice(pw.Context context) {
    return pw.Container(
      color: PdfColors.blue,
      height: 130,
      child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Padding(
                padding: pw.EdgeInsets.only(left: 16),
                child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      _buildQrCode(context),
                      pw.Padding(
                          padding: pw.EdgeInsets.only(top: 12),
                          child: pw.Text('Use esse QR para pagar',
                              style: pw.TextStyle(
                                  color: PdfColor(0.85, 0.85, 0.85))))
                    ])),
            pw.Padding(
                padding: pw.EdgeInsets.all(16),
                child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Padding(
                          padding: pw.EdgeInsets.only(bottom: 0),
                          child: pw.Text('TOTAL',
                              style: pw.TextStyle(color: PdfColors.white))),
                      pw.Text('R\$: ${_formatValue(invoice.total)}',
                          style: pw.TextStyle(
                              color: PdfColors.white, fontSize: 22))
                    ]))
          ]),
    );
  }
}
