import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mon_etat_civile/addDeces.dart';
import 'package:mon_etat_civile/addMariage.dart';
import 'package:mon_etat_civile/addResidence.dart';
import 'package:mon_etat_civile/impression.dart';
import 'package:mon_etat_civile/imprimer.dart';
import 'deces_imprimer.dart';
import 'imprimer_mariage.dart';
import 'setting_page.dart';
import 'user_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'add_extrait.dart';
import 'logOutPage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late UserProvider userProvider;
  late String userId;
  late String userName;
  late String formattedDate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Accédez à l'InheritedWidget ici
    userProvider = Provider.of<UserProvider>(context);
    userId = userProvider.userId.toString();
    userName = userProvider.userName;
    formattedDate = (() {
      DateTime userCreationDate = userProvider.userCreationDate;
      return DateFormat('dd/MM/yy').format(userCreationDate);
    })();
  }

  OverlayEntry? overlayEntry;

  void showOverlay(BuildContext context) {
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0.0,
        left: 0.0,
        child: GestureDetector(
          onTap: () {
            hideOverlay();
          },
          child: Material(
            color: Colors.transparent,
            child: Container(
              width:
                  MediaQuery.of(context).size.width, // Diminution de la largeur
              height: MediaQuery.of(context).size.height * 0.5 + 100,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icône de personne au milieu en haut
                  const Icon(
                    Icons.person,
                    size: 85,
                    color: Color.fromRGBO(205, 92, 92, 1),
                  ),
                  SizedBox(height: 8.0),
                  // Texte "Nom d'utilisateur"
                  Text(
                    userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 27,
                      color: Colors.black,
                    ),
                  ),
                  // Texte "ID utilisateur"
                  Text(
                    userId,
                    style: TextStyle(
                      fontSize: 27,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 30.0),
                  // Carré avec fond orange et coins arrondis
                  Container(
                    width: MediaQuery.of(context).size.width - 50,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(205, 92, 92, 1),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Texte "En fonction depuis le"
                        Text(
                          'En fonction depuis le',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                            color: Colors.white,
                          ),
                        ),
                        // Texte "Exemple de date"
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 19,
                            color: Colors.white,
                          ),
                        ),
                        // Trait qui sépare
                        Divider(
                          thickness: 2,
                          color: Colors.white,
                        ),
                        // Ligne avec icône "Paramètres"
                        InkWell(
                          onTap: () {
                            hideOverlay();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangePassWord()),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lock,
                                size: 24,
                                color: Colors.white,
                              ),
                              SizedBox(width: 16.0), // Plus d'espace
                              // Texte "Paramètres"
                              Text(
                                'Changer mot de passe',
                                style: TextStyle(
                                  fontSize: 19,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Plus d'espace
                        SizedBox(height: 16.0),
                        // Trait qui sépare
                        Divider(
                          thickness: 2,
                          color: Colors.white,
                        ),
                        // Ligne avec icône "Déconnexion"
                        InkWell(
                          onTap: () {
                            hideOverlay();

                            // Ajoutez ici la logique pour la navigation vers la page de déconnexion
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PageDeconnexion()),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.power_settings_new,
                                size: 24,
                                color: Colors.white,
                              ),
                              SizedBox(width: 16.0), // Plus d'espace
                              // Texte "Déconnexion"
                              Text(
                                'Déconnexion',
                                style: TextStyle(
                                  fontSize: 19,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(overlayEntry!);
  }

  void showBottomSheetCertificat(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6 - 150,
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Icône pour fermer
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  size: 24,
                ),
              ),
              SizedBox(height: 1.0),
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Que souhaitez vous faire ?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              SizedBox(height: 30.0),
              // Ligne avec icônes "Ajouter" et "Imprimer"
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 16.0,
                  ),
                  Column(
                    children: [
                      // GestureDetector pour l'icône "Ajouter"
                      GestureDetector(
                        onTap: () {
                          // Ajoutez ici la logique à exécuter lorsque l'utilisateur tape sur l'icône "Ajouter"
                          showCustomBottomSheetCertificatChoice(context);
                        },
                        child: Column(
                          children: [
                            // Icône "Ajouter"
                            Icon(
                              Icons.add,
                              size: 60,
                              color: Color.fromRGBO(255, 160, 122, 1),
                            ),
                            // Texte "Ajouter"
                            Text(
                              'Ajouter',
                              style: TextStyle(fontSize: 23),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 55.0),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Ajoutez ici la logique à exécuter lorsque l'utilisateur tape sur l'icône "Ajouter"
                          showCustomBottomSheetCertificatChoice2(context);
                        },
                        child: Column(
                          children: [
                            // Icône "Imprimer"
                            Icon(
                              Icons.print,
                              size: 60,
                              color: Color.fromRGBO(255, 160, 122, 1),
                            ),
                            // Texte "Imprimer"
                            Text(
                              'Imprimer',
                              style: TextStyle(fontSize: 23),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void hideOverlay() {
    overlayEntry?.remove();
  }

  void showCustomBottomSheetCertificatChoice(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.6 - 150,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Rangée pour le bouton de fermeture
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      size: 24,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              // Colonnes pour les zones de texte avec Divider entre elles
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Ajouter la logique pour la zone de texte 1
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AddResidenceCertificatePage()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center, // Centrer le texte
                      child: Text(
                        'Résidence',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Divider(
                    color: Color.fromRGBO(205, 92, 92, 1),
                  ),
                  SizedBox(height: 10.0),
                  GestureDetector(
                    onTap: () {
                      // Ajouter la logique pour la zone de texte 2
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddMarriageCertificatePage()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center, // Centrer le texte
                      child: Text(
                        'Mariage',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Divider(
                    color: Color.fromRGBO(205, 92, 92, 1),
                  ),
                  SizedBox(height: 10.0),
                  GestureDetector(
                    onTap: () {
                      // Ajouter la logique pour la zone de texte 3
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddDeathCertificatePage()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center, // Centrer le texte
                      child: Text(
                        'Décès',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Le choix pour l'impression
  void showCustomBottomSheetCertificatChoice2(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.6 - 150,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Rangée pour le bouton de fermeture
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      size: 24,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              // Colonnes pour les zones de texte avec Divider entre elles
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Ajouter la logique pour la zone de texte 1
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PageImpression()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center, // Centrer le texte
                      child: Text(
                        'Résidence',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Divider(
                    color: Color.fromRGBO(205, 92, 92, 1),
                  ),
                  SizedBox(height: 10.0),
                  GestureDetector(
                    onTap: () {
                      // Ajouter la logique pour la zone de texte 2
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImpressionMariagePage()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center, // Centrer le texte
                      child: Text(
                        'Mariage',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Divider(
                    color: Color.fromRGBO(205, 92, 92, 1),
                  ),
                  SizedBox(height: 10.0),
                  GestureDetector(
                    onTap: () {
                      // Ajouter la logique pour la zone de texte 3
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImpressionDecesPage()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center, // Centrer le texte
                      child: Text(
                        'Décès',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void showBottomSheetextrait(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5 - 150,
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Icône pour fermer
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  size: 24,
                ),
              ),
              SizedBox(height: 1.0),
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Que voulez vous faire',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              SizedBox(height: 16.0),
              // Ligne avec icônes "Ajouter" et "Imprimer"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Naviguer vers la page d'ajout
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddPage(),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        // Icône "Ajouter"
                        Icon(
                          Icons.add,
                          size: MediaQuery.of(context).size.width * 0.10,
                        ),
                        // Texte "Ajouter"
                        Text(
                          'Ajouter',
                          style: TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Naviguer vers la page d'impression
                      // Assurez-vous de remplacer ImprimerPage par le nom de votre page d'impression
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImpressionExtraitPage(),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        // Icône "Imprimer"
                        Icon(
                          Icons.print,
                          size: MediaQuery.of(context).size.width * 0.10,
                        ),
                        // Texte "Imprimer"
                        Text(
                          'Imprime',
                          style: TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(205, 92, 92, 1),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              showOverlay(context);
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        size: 60,
                        color: Color.fromRGBO(205, 92, 92, 1),
                      ),
                      SizedBox(width: 8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color.fromRGBO(205, 92, 92, 1),
                            ),
                          ),
                          Text(
                            userId,
                            style: TextStyle(
                              fontSize: 17,
                              color: Color.fromRGBO(205, 92, 92, 1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          showBottomSheetextrait(
                              context); // Appeler la fonction showBottomSheet
                        },
                        child: SvgPicture.asset(
                          'assets/image.svg',
                          width: 100,
                          height: 100,
                          color: Color.fromRGBO(255, 160, 122, 1),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Extrait",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          showBottomSheetCertificat(
                              context); // Appeler la fonction showBottomSheet
                        },
                        child: SvgPicture.asset(
                          'assets/image.svg',
                          width: 100,
                          height: 100,
                          color: Color.fromRGBO(255, 160, 122, 1),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Certificat",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


  




/*
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              color: Colors.white,
              child: Center(
                child: Text(
                  "Widget 1",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Titre en dessous 1",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Container(
              width: 150,
              height: 150,
              color: Colors.green,
              child: Center(
                child: Text(
                  "Widget 2",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Titre en dessous 2",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}*/
