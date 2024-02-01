import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mon_etat_civile/user_provider.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'package:http/http.dart' as http;

class AddMarriageCertificatePage extends StatefulWidget {
  @override
  _AddMarriageCertificatePageState createState() =>
      _AddMarriageCertificatePageState();
}

class _AddMarriageCertificatePageState
    extends State<AddMarriageCertificatePage> {
  TextEditingController date_mariage = TextEditingController();
  TextEditingController nomepoux = TextEditingController();
  TextEditingController nomepouse = TextEditingController();
  TextEditingController prenomepoux = TextEditingController();
  TextEditingController prenomepouse = TextEditingController();
  TextEditingController nomtemoin = TextEditingController();
  TextEditingController prenomtemoin = TextEditingController();

  bool ajoutEffectue = false;
  DateTime selectedDate = DateTime.now(); // Ajoutez cette ligne
  late UserProvider userProvider;
  late int userId;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Accédez à l'InheritedWidget ici
    userProvider = Provider.of<UserProvider>(context);
    userId = userProvider.userId;
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900), // Date de début acceptable
      lastDate: DateTime.now(), // Date de fin acceptable (date du jour)
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        controller.text = "${picked.year}/${picked.month}/${picked.day}";
      });
    }
  }

  Future<void> sendDataToApi() async {
    final String apiUrl = 'http://127.0.0.1:8000/api/mariage';

    // Retrieve values from text fields
    String snomepouse= nomepouse.text;
    String snomepoux = nomepoux.text;
    String sprenomepouse = prenomepouse.text;
    String sprenomepoux = prenomepoux.text;
    String sprenomtemoin = prenomtemoin.text;
    String snomtemoin = nomtemoin.text;
    String sdate = date_mariage.text;
    // ... repeat for other fields

    // Prepare data for the API request
    Map<String, dynamic> data = {
      'idEmploye': userId,
      'nomFemme': snomepouse,
      'nomMari': snomepoux,
      'prenomFemme': sprenomepouse,
      'prenomMari': sprenomepoux,
      'prenomTemoin': sprenomtemoin,
      'nomTemoin': snomtemoin,
      'date_mariage': sdate,
      // ... include other fields in the data map
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );
      final Logger _logger = Logger();

      if (response.statusCode == 200) {
        setState(() {
          _logger.e('ajout reussi');
          ajoutEffectue = true;
        });
      } else {
        _logger.e('erreur ici');
        // Handle error response
        print('API request failed with status ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
    }
  }

  Widget buildTextField(String labelText, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          labelText: labelText,
        ),
      ),
    );
  }

  Widget buildDateTextField(
      String labelText, TextEditingController controller) {
    return InkWell(
      onTap: () => _selectDate(context, controller),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide.none,
            ),
            labelText: labelText,
            suffixIcon: Icon(Icons.calendar_today),
          ),
          enabled:
              false, // Désactiver la saisie directe pour forcer l'utilisation du sélecteur de date
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(205, 92, 92, 1),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                "Ajout certificat de mariage",
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 80),
              buildTextField("Nom époux", nomepoux),
              buildTextField("Prénom époux", prenomepoux),
              buildTextField("Nom épouse", nomepouse),
              buildTextField("Prénom épouse", prenomepouse),
              buildTextField("Nom temoin ", nomtemoin),
              buildTextField("Prenom Temoin", prenomtemoin),
              buildDateTextField("date de mariage", date_mariage),
              //   buildDateTextField("Date de mariage",dateController),
              SizedBox(height: 30),
              ajoutEffectue
                  ? Column(
                      children: [
                        Icon(
                          Icons.done,
                          size: 60,
                          color: Colors.green,
                        ),
                        Text(
                          'Ajout effectué',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    )
                  : Container(
                      height: 50,
                      //          padding: const EdgeInsets.symmetric(horizontal: 180),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            backgroundColor: Color.fromRGBO(255, 160, 122, 1)),
                        onPressed: () {
                          // Ajoutez le code pour gérer le bouton d'ajout ici
                          sendDataToApi();
                        },
                        child: const Text(
                          'Ajouter',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
              SizedBox(height: 30),
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
