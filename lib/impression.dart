import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'animated_type_ahead_searchbar.dart';
import 'package:pdf/widgets.dart' as pw;
import 'residence.dart';
import 'dart:html' as html;

class PageImpression extends StatefulWidget {
  @override
  _PageImpressionState createState() => _PageImpressionState();
}

class _PageImpressionState extends State<PageImpression> {
  
  TextEditingController editingController = TextEditingController();
  Future<List<Residence>> residenceFuture = getResidence();
  List<Residence> filteredResidencetList = [];
  List<String> elements = ['Élément 1', 'Élément 2', 'Élément 3'];
  List<String> filteredElements = [];
  static Future<List<Residence>> getResidence() async {
    var url = Uri.parse("http://127.0.0.1:8000/api/getresidence");
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    final List body = json.decode(response.body);
    return body.map((e) => Residence.fromJson(e)).toList();
  }

  @override
  void initState() {
    super.initState();
    residenceFuture.then((value) {
      setState(() {
        filteredResidencetList = value;
      });
    });
  }

  void filterSearchResults(String query) async {
    // Attendre que la future se termine pour obtenir la liste complète
    List<Residence> residenceList = await residenceFuture;

    setState(() {
      filteredResidencetList = residenceList
          .where(
            (residence) =>
                residence.nom!.toLowerCase().contains(query.toLowerCase()) ||
                residence.prenom!.toLowerCase().contains(query.toLowerCase()) ||
                residence.id!
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
      backgroundColor: Color.fromRGBO(205, 92, 92, 1),
      body: Center(
        child: FutureBuilder<List<Residence>>(
          future: residenceFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              final extrait = snapshot.data!;
              return buildResidence(extrait);
            } else {
              return const Text("No data available");
            }
          },
        ),
      ),
    );
  }

  Widget buildResidence(List<Residence> residence) {
    
    return Scaffold(
      extendBodyBehindAppBar: true,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: true, // Activer le bouton de retour automatique
    ),
      backgroundColor: Color.fromRGBO(205, 92, 92, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Page Impression',
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
              itemCount: filteredResidencetList
                  .length, // Utilisez la taille de la liste
              itemBuilder: (context, index) {
                return _buildListTileWithDownloadButton(
                  title:
                      'numero residence : ${filteredResidencetList[index].id.toString()}',
                  subtitle:
                      'Nom complet :  ${filteredResidencetList[index].prenom} ${filteredResidencetList[index].nom}', // Exemple de sous-titre basé sur l'index
                  onPressed: () async {
                    final pdfBytes =
                        await makePdf(filteredResidencetList[index]);
                    downloadPdf(pdfBytes);
                    // Logique de téléchargement pour l'élément à cet index
                    print('Télécharger ${elements[index]}');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Fonction pour créer un élément de liste avec un bouton de téléchargement
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

  void filterElements(String query) {
    setState(() {
      filteredElements = elements
          .where(
              (element) => element.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<Uint8List> makePdf(Residence residencepdf) async {
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
                text: 'Residence N°${residencepdf.id}\n\n'
                    'Nom du resident : ${residencepdf.nom ?? 'N/A'}\n'
                    'Prénom du resident: ${residencepdf.prenom ?? 'N/A'}\n'
                    'adresse du resident: ${residencepdf.adresse ?? 'N/A'}\n'
                    'Duree : ${residencepdf.duree ?? ' ans N/A'}\n\n'
                    'lieu : ${residencepdf.lieu ?? 'N/A'}\n\n'),
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
      ..download = 'residence.pdf'
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
