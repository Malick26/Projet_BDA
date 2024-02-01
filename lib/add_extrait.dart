import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'home.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  bool ajoutEffectue = false;

  DateTime selectedDate = DateTime.now(); // Ajoutez cette ligne

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

  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController nommController = TextEditingController();
  TextEditingController prenompController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController prenommController = TextEditingController();
  TextEditingController datemController = TextEditingController();
  TextEditingController datepController = TextEditingController();
  TextEditingController lieuController = TextEditingController();
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
    final String apiUrl = 'http://127.0.0.1:8000/api/extrait';

    // Retrieve values from text fields
    String nom = nomController.text;
    String prenom = prenomController.text;
    String nom_mere = nommController.text;
    String prenom_pere = prenompController.text;
    String date_naissance = dateController.text;
    String prenom_mere = prenommController.text;
    String date_naiss_mere = datemController.text;
    String date_naiss_pere = datepController.text;
    String lieu_naissance = lieuController.text;
    // ... repeat for other fields

    // Prepare data for the API request
    Map<String, dynamic> data = {
      'idEmploye': userId,
      'nom': nom,
      'prenom': prenom,
      'date_naissance': date_naissance,
      'lieu_naissance': lieu_naissance,
      'prenom_pere': prenom_pere,
      'prenom_mere': prenom_mere,
      'nom_mere': nom_mere,
      'date_naissancepere': date_naiss_pere,
      'date_naissancemere': date_naiss_mere
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
                "Ajout nouveau extrait",
                style: TextStyle(
                  fontSize: 35.0, // Taille du texte
                  fontWeight: FontWeight.bold, // Poids du texte (gras)
                  color: Colors.white,
                ),
              ),
           //   SizedBox(height: 40),
              buildTextField("Nom", nomController),
              buildTextField("Prenom", prenomController),
              buildDateTextField("Date naissance", dateController),
              buildTextField("Lieu naissance", lieuController),
              buildTextField("Prenom pere", prenompController),
              buildDateTextField("date naiss pere", datepController),
              buildTextField("Prenom mere", prenommController),
              buildTextField("Nom mere", nommController),
              buildDateTextField("date naiss mere", datemController),
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
                      // height: 50,
                      //  padding: const EdgeInsets.symmetric(horizontal: 180),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            //    minimumSize: const Size.fromHeight(50),
                            backgroundColor: Color.fromRGBO(255, 160, 122, 1)),
                        onPressed: () {
                          sendDataToApi();
                          // Ajoutez le code pour gérer le bouton de connexion ici
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


/*
 nomController 
  prenomController 
  nommController 
  prenompController 
  dateController 
  prenommController 
  datemController
  datepController
  lieuController
  */