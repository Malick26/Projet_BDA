import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'login_page.dart';
import 'user_provider.dart';

class ChangePassWord extends StatefulWidget {
  @override
  _ChangePassWordState createState() => _ChangePassWordState();
}

class _ChangePassWordState extends State<ChangePassWord> {
  TextEditingController motdepasse = TextEditingController();
  TextEditingController nouveau = TextEditingController();
  TextEditingController confirmer = TextEditingController();
  late UserProvider userProvider;
  late int userId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = Provider.of<UserProvider>(context);
    userId = userProvider.userId;
  }

  Future<void> changerMotDePasse() async {
    final String apiUrl = 'http://127.0.0.1:8000/api/changepassword';

    String ancieni = motdepasse.text;
    String nouveaui = nouveau.text;
    String confirmeri = confirmer.text;
    Map<String, dynamic> data = {
      'idEmploye': userId,
      'current_password': ancieni,
      'new_password': nouveaui,
      'confirm_password': confirmeri,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );
      final Logger _logger = Logger();

      if (response.statusCode == 200) {
        _logger.e('changement reussi');
        // Ajoutez ici toute action que vous souhaitez effectuer en cas de réussite
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
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Changement mot de passe",
              style: TextStyle(
                fontSize: 45.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextField(
                controller: motdepasse,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(90.0),
                    borderSide: BorderSide.none,
                  ),
                  labelText: "Mot de passe actuel",
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextField(
                controller: nouveau,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(90.0),
                    borderSide: BorderSide.none,
                  ),
                  labelText: "Nouveau mot de passe",
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextField(
                controller: confirmer,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(90.0),
                    borderSide: BorderSide.none,
                  ),
                  labelText: "Confirmer mot de passe",
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              height: 80,
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Color.fromRGBO(255, 160, 122, 1),
                ),
                onPressed: () {
                  changerMotDePasse();
                },
                child: const Text(
                  'Changer',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
