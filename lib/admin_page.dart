//import 'dart:ffi';

import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset(0.0, 0.3),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Démarrez l'animation dans initState
    _controller.forward();
  }

  List<Map<String, dynamic>> dataList = [
    {'title': 'Extrait', 'value': 2000},
    {'title': 'Certificat', 'value': 4000},
    {'title': 'Mariage', 'value': 8000},
  ];

  void glisseblanc() {
    SlideTransition(
      position: _offsetAnimation,
      child: Container(
        margin: EdgeInsets.only(top: 20.0),
        padding: EdgeInsets.all(16.0),
        //   height: MediaQuery.of(context).size.height * 0.7,
        color: const Color.fromARGB(255, 95, 54, 54),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Conteneurs horizontaux avec défilement horizontal
            Container(
              // width: 150,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                //encore
                child: Row(
                  children: List.generate(dataList.length, (index) {
                    String title = dataList[index]['title'];
                    int value = dataList[index]['value'];
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.width * 0.5,
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(title),
                          Text('$value'),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(205, 92, 92, 1),
      body: Stack(
        children: [
          // Fond orange arrondi avec plus d'espace en haut
          Container(
            // La couleur orange s'applique à tout le conteneur
            child: Container(
              margin: EdgeInsets.only(top: 20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Text(
                'Votre texte en gras',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Conteneur blanc qui glisse du bas vers le haut
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Statistiques',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

//bakhbakh bi boul nelawwww d
//
//
//
//
//voila
