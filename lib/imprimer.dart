import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'extrait.dart';
import 'dart:html' as html;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ImpressionExtraitPage extends StatefulWidget {
  @override
  _ImpressionExtraitPageState createState() => _ImpressionExtraitPageState();
}

class _ImpressionExtraitPageState extends State<ImpressionExtraitPage> {
  TextEditingController editingController = TextEditingController();
  Future<List<Extrait>> extraitFuture = getExtrait();
  List<Extrait> filteredExtraitList = [];

  static Future<List<Extrait>> getExtrait() async {
    var url = Uri.parse("http://127.0.0.1:8000/api/extraitget");
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    final List body = json.decode(response.body);
    return body.map((e) => Extrait.fromJson(e)).toList();
  }

  @override
  void initState() {
    super.initState();
    extraitFuture.then((value) {
      setState(() {
        filteredExtraitList = value;
      });
    });
  }

  void filterSearchResults(String query) async {
    List<Extrait> extraitList = await extraitFuture;

    setState(() {
      filteredExtraitList = extraitList
          .where(
            (extrait) =>
                extrait.nom!.toLowerCase().contains(query.toLowerCase()) ||
                extrait.prenom!.toLowerCase().contains(query.toLowerCase()) ||
                extrait.id!
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
      ),
      backgroundColor: Color.fromRGBO(205, 92, 92, 1),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Page Impression Extrait',
                  style: TextStyle(
                    fontSize: 36.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                  labelText: 'Rechercher...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredExtraitList.length,
                itemBuilder: (context, index) {
                  return _buildListTileWithDownloadButton(
                    title:
                        'Numéro d\'extrait : ${filteredExtraitList[index].id.toString()}',
                    subtitle:
                        'Nom complet :  ${filteredExtraitList[index].prenom} ${filteredExtraitList[index].nom}',
                    onPressed: () async {
                      final pdfBytes =
                          await makePdf(filteredExtraitList[index]);
                      downloadPdf(pdfBytes);
                      print('Télécharger ${filteredExtraitList[index]}');
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTileWithDownloadButton({
    required String title,
    required String subtitle,
    required VoidCallback onPressed,
  }) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 5.0,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: ElevatedButton(
          onPressed: onPressed,
          child: Icon(
            Icons.download,
            color: Color.fromRGBO(255, 160, 122, 1),
          ),
        ),
      ),
    );
  }

  Future<Uint8List> makePdf(Extrait extraitpdf) async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      margin: pw.EdgeInsets.all(10),
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Header(text: "Détails de l'extrait", level: 1),
              ],
            ),
            pw.Divider(borderStyle: pw.BorderStyle.dashed),
            pw.Paragraph(
              text: 'Extrait N°${extraitpdf.id}\n\n'
                  'Nom: ${extraitpdf.nom ?? 'N/A'}\n'
                  'Prénom: ${extraitpdf.prenom ?? 'N/A'}\n'
                  'Date de Naissance: ${extraitpdf.date_naissance ?? 'N/A'}\n'
                  'Lieu de Naissance: ${extraitpdf.lieu_naissance ?? 'N/A'}\n\n'
                  'Père\n'
                  'Prénom: ${extraitpdf.prenom_pere ?? 'N/A'}\n'
                  'Date de Naissance: ${extraitpdf.date_naissancepere ?? 'N/A'}\n\n'
                  'Mère\n'
                  'Nom: ${extraitpdf.nom_mere ?? 'N/A'}\n'
                  'Prénom: ${extraitpdf.prenom_mere ?? 'N/A'}\n'
                  'Date de Naissance: ${extraitpdf.date_naissancemere ?? 'N/A'}',
            ),
          ],
        );
      },
    ));
    return pdf.save();
  }

  void downloadPdf(Uint8List pdfBytes) {
    final blob = html.Blob([pdfBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'webviewer'
      ..download = 'extrait.pdf'
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
