import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mon_etat_civile/addResidence.dart';
import 'package:mon_etat_civile/home.dart';
import 'login_page.dart';
import 'user_provider.dart';
import 'admin_page.dart';
import 'package:provider/provider.dart';
import 'imprimer.dart';
import 'extrait.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // ... autres fournisseurs
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add a duration for the Splash Screen, for example, 3 seconds.
    Timer(
      Duration(seconds: 1),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Login()), // Navigate to LoginPage
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(205, 92, 92, 1),
      body: Center(
        child: Image.asset('assets/logo.png'), // Use the path to your logo.
      ),
    );
  }
}


/*class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Etat Civile'),
      ),
      body: Center(
        child: Text('Bienvenue sur votre application !'),
      ),
    );
  }
}*/
