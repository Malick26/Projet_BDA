import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mon_etat_civile/user_provider.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'package:http/http.dart' as http;

class AddResidenceCertificatePage extends StatefulWidget {
  @override
  _AddResidenceCertificatePageState createState() =>
      _AddResidenceCertificatePageState();
}

class _AddResidenceCertificatePageState
    extends State<AddResidenceCertificatePage> {
  bool ajoutEffectue = false;
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController lieuController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  TextEditingController dureeController = TextEditingController();
  late UserProvider userProvider;
  late int userId;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Accédez à l'InheritedWidget ici
    userProvider = Provider.of<UserProvider>(context);
    userId = userProvider.userId;
  }

  Future<void> sendDataToApi() async {
    final String apiUrl = 'http://127.0.0.1:8000/api/residence';

    // Retrieve values from text fields
    String nom = nomController.text;
    String prenom = prenomController.text;
    String lieu = lieuController.text;
    String adresse = adresseController.text;
    String duree = dureeController.text;
    // ... repeat for other fields

    // Prepare data for the API request
    Map<String, dynamic> data = {
      'idEmploye': userId,
      'nom': nom,
      'prenom': prenom,
      'adresse': adresse,
      'lieu_naissance': lieu,
      'duree': duree,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(205, 92, 92, 1),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Text(
                "Ajout certificat de résidence",
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 140),
              buildTextField("Nom du résident", nomController),
              buildTextField("Prénom du résident", prenomController),
              buildTextField("Lieu de naissance du résident", lieuController),
              buildTextField("Adresse du résident", adresseController),
              buildTextField("Durée de résidence", dureeController),
              SizedBox(height: 60),
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
                      //         padding: const EdgeInsets.symmetric(horizontal: 180),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
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
              SizedBox(height: 100),
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
