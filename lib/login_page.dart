import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'admin_page.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'home.dart';

// ignore: must_be_immutable
class Login extends StatelessWidget {
  final Logger _logger = Logger();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String varProfil = '';
  void _login(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;

    // URL de votre API de connexion
    String apiUrl = 'http://127.0.0.1:8000/api/login';

    // Données à envoyer à l'API
    Map<String, String> data = {'email': email, 'password': password};

    try {
      // Effectuer la requête POST à votre API
      var response = await http.post(
        Uri.parse(apiUrl),
        body: data,
      );

      // Vérifier le code de statut de la réponse
      if (response.statusCode == 200) {
        _logger.i('Connexion reussie');
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String profil = responseData['data']['user']['profil'];
        _logger.d('Profil: $profil');
        if (profil == 'admin') {
          _logger.d('Navigating to AdminPage');
          Provider.of<UserProvider>(context, listen: false).setUserDetails(
            responseData['data']['user']['id'],
            responseData['data']['user']['nom'],
            DateTime.parse(responseData['data']['user']['created_at']),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  AdminPage()),
          );
        } else {
          _logger.d('Profil pas admin');
          Provider.of<UserProvider>(context, listen: false).setUserDetails(
            responseData['data']['user']['id'],
            responseData['data']['user']['nom'],
            DateTime.parse(responseData['data']['user']['created_at']),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        }
      } else {
        // La connexion a échoué, afficher un message d'erreur
        _logger.e('Échec de la connexion');
      }
    } catch (e) {
      // Gérer les erreurs, par exemple, imprimer l'erreur
      _logger.d('Erreur: $e');
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
              "CONNEXION",
              style: TextStyle(
                fontSize: 45.0, // Taille du texte
                fontWeight: FontWeight.bold, // Poids du texte (gras)
                color: Colors.white,
              ),
            ),

            SizedBox(height: 20.0), // espace entre le text et le textfields

            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(90.0), // Coins circulaires
                    borderSide: BorderSide.none, // Supprime la bordure
                  ),
                  labelText: "Email",
                ),
              ),
            ),

            SizedBox(height: 20.0), //augmenter la distance entre les textfields

            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(90.0), // Coins circulaires
                    borderSide: BorderSide.none, // Supprime la bordure
                  ),
                  labelText: "Mot de passe",
                ),
              ),
            ),

            SizedBox(height: 20.0), //augmenter la distance entre les textfields

            Container(
              height: 80,
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Color.fromRGBO(255, 160, 122, 1)),
                onPressed: () {
                  // Ajoutez le code pour gérer le bouton de connexion ici
                  _login(context);
                },
                child: const Text(
                  'Connexion',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Ajoutez le code pour gérer le bouton "Forgot Password" ici
              },
              child: Text(
                'Mot de passe oublié?',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
