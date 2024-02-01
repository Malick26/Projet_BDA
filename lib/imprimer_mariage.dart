import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'mariage.dart'; // Assurez-vous que la classe Mariage est importée
import 'dart:html' as html;
import 'package:pdf/widgets.dart' as pw;

class ImpressionMariagePage extends StatefulWidget {
  @override
  _ImpressionMariagePageState createState() => _ImpressionMariagePageState();
}

class _ImpressionMariagePageState extends State<ImpressionMariagePage> {
  TextEditingController editingController = TextEditingController();
  Future<List<Mariage>> mariageFuture = getMariages();
  List<Mariage> filteredMariageList = [];

  static Future<List<Mariage>> getMariages() async {
    var url = Uri.parse("http://127.0.0.1:8000/api/getmariage");
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    final List body = json.decode(response.body);
    return body.map((e) => Mariage.fromJson(e)).toList();
  }

  @override
  void initState() {
    super.initState();
    mariageFuture.then((value) {
      setState(() {
        filteredMariageList = value;
      });
    });
  }

  void filterSearchResults(String query) async {
    List<Mariage> mariageList = await mariageFuture;

    setState(() {
      filteredMariageList = mariageList
          .where(
            (mariage) =>
                mariage.nomMari!.toLowerCase().contains(query.toLowerCase()) ||
                mariage.prenomMari!.toLowerCase().contains(query.toLowerCase()) ||
                mariage.id!
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
                  'Page Impression Mariage',
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
                itemCount: filteredMariageList.length,
                itemBuilder: (context, index) {
                  return _buildListTileWithDownloadButton(
                    title:
                        'Numéro de mariage : ${filteredMariageList[index].id.toString()}',
                    subtitle:
                        'Nom complet mari :  ${filteredMariageList[index].prenomMari} ${filteredMariageList[index].nomMari}',
                    onPressed: () async {
                      final pdfBytes = await makePdf(filteredMariageList[index]);
                      downloadPdf(pdfBytes);
                      print('Télécharger ${filteredMariageList[index]}');
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

  Future<Uint8List> makePdf(Mariage mariagepdf) async {
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
                pw.Header(text: "Détails du mariage", level: 1),
              ],
            ),
            pw.Divider(borderStyle: pw.BorderStyle.dashed),
            pw.Paragraph(
              text: 'Mariage N°${mariagepdf.id}\n\n'
                  'Nom Mari: ${mariagepdf.nomMari ?? 'N/A'}\n'
                  'Prénom Mari: ${mariagepdf.prenomMari ?? 'N/A'}\n'
                  'Nom Femme: ${mariagepdf.nomFemme ?? 'N/A'}\n'
                  'Prénom Femme: ${mariagepdf.prenomFemme ?? 'N/A'}\n\n'
                  'Témoin\n'
                  'Nom Témoin: ${mariagepdf.nomTemoin ?? 'N/A'}\n'
                  'Prénom Témoin: ${mariagepdf.prenomTemoin ?? 'N/A'}\n\n'
                  'Date Mariage: ${mariagepdf.dateMariage ?? 'N/A'}\n',
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
      ..download = 'mariage.pdf'
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
