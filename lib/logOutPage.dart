import 'package:flutter/material.dart';
import 'package:mon_etat_civile/home.dart';
import 'package:mon_etat_civile/login_page.dart';

class PageDeconnexion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color containerColor = Color.fromRGBO(205, 92, 92, 1);

    return Scaffold(
      backgroundColor: containerColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Partie supérieure avec le titre "DECONNEXION"
            SizedBox(height: 200),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white, // Couleur de fond
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'DECONNEXION',
                      style: TextStyle(
                        color: containerColor, // Couleur du texte
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10), // Espace
                  Divider(
                    height: 1,
                    color: containerColor, // Couleur du Divider
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Souhaitez-vous vraiment vous déconnecter?',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black, // Couleur du texte
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Bouton "Oui" pour la déconnexion
                      GestureDetector(
                        onTap: () {
                          // Ajoutez ici la logique pour le texte "Oui" (déconnexion)
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white, // Couleur du texte "Oui"
                          ),
                          child: Text(
                            'Oui',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 35,
                                color: Color.fromRGBO(255, 160, 122, 1)),
                          ),
                        ),
                      ),
                      SizedBox(width: 10), // Espace entre les éléments
                      // Texte "Non" avec GestureDetector
                      GestureDetector(
                        onTap: () {
                          // Ajoutez ici la logique pour le texte "Non" (annuler)
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white, // Couleur du texte "Non"
                          ),
                          child: Text(
                            'Non',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 35,
                                color: Color.fromRGBO(255, 160, 122, 1)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10), // Espace
            // Texte "Souhaitez-vous vraiment vous déconnecter?"

            SizedBox(height: 20), // Espace
            // Boutons "Oui" et "Non" sur la même ligne
          ],
        ),
      ),
    );
  }
}
