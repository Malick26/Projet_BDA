import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'deces.dart'; // Importez la classe Deces
import 'dart:html' as html;
import 'package:pdf/widgets.dart' as pw;


class ImpressionDecesPage extends StatefulWidget {
  @override
  _ImpressionDecesPageState createState() => _ImpressionDecesPageState();
}

class _ImpressionDecesPageState extends State<ImpressionDecesPage> {
  TextEditingController editingController = TextEditingController();
  Future<List<Deces>> decesFuture = getDeces();
  List<Deces> filteredDecesList = [];

  static Future<List<Deces>> getDeces() async {
    var url = Uri.parse("http://127.0.0.1:8000/api/getdeces");
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    final List body = json.decode(response.body);
    return body.map((e) => Deces.fromJson(e)).toList();
  }

  @override
  void initState() {
    super.initState();
    decesFuture.then((value) {
      setState(() {
        filteredDecesList = value;
      });
    });
  }

  void filterSearchResults(String query) async {
    List<Deces> decesList = await decesFuture;

    setState(() {
      filteredDecesList = decesList
          .where(
            (deces) =>
                deces.nom!.toLowerCase().contains(query.toLowerCase()) ||
                deces.prenom!.toLowerCase().contains(query.toLowerCase()) ||
                deces.id!
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
                  'Page Impression Deces',
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
                itemCount: filteredDecesList.length,
                itemBuilder: (context, index) {
                  return _buildListTileWithDownloadButton(
                    title:
                        'Numéro de décès : ${filteredDecesList[index].id.toString()}',
                    subtitle:
                        'Nom complet :  ${filteredDecesList[index].prenom} ${filteredDecesList[index].nom}',
                    onPressed: () async {
                      final pdfBytes = await makePdf(filteredDecesList[index]);
                      downloadPdf(pdfBytes);
                      print('Télécharger ${filteredDecesList[index]}');
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

  Future<Uint8List> makePdf(Deces decespdf) async {
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
                pw.Header(text: "Détails du décès", level: 1),
              ],
            ),
            pw.Divider(borderStyle: pw.BorderStyle.dashed),
            pw.Paragraph(
              text: 'Décès N°${decespdf.id}\n\n'
                  'Nom du défunt : ${decespdf.nom ?? 'N/A'}\n'
                  'Prénom du défunt: ${decespdf.prenom ?? 'N/A'}\n'
                  'Date de Naissance: ${decespdf.dateNaissance ?? 'N/A'}\n'
                  'Lieu de Naissance: ${decespdf.lieuNaissance ?? 'N/A'}\n\n'
                  'Date du décès: ${decespdf.dateDeces ?? 'N/A'}\n'
                  'Lieu du décès: ${decespdf.lieuDeces ?? 'N/A'}\n'
                  'Cause du décès: ${decespdf.cause ?? 'N/A'}\n\n',
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
      ..download = 'deces.pdf'
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
