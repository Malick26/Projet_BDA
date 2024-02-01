import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
//import 'package:http/http.dart' as http;
import 'dart:convert';

class Extrait {
  int? id;
  int? idEmploye;
  String? nom;
  String? prenom;
  String? date_naissance;
  String? lieu_naissance;
  String? prenom_pere;
  String? prenom_mere;
  String? nom_mere;
  String? date_naissancepere;
  String? date_naissancemere;

  Extrait({
    this.id,
    this.idEmploye,
    this.nom,
    this.prenom,
    this.date_naissance,
    this.lieu_naissance,
    this.prenom_pere,
    this.prenom_mere,
    this.nom_mere,
    this.date_naissancepere,
    this.date_naissancemere,
  });

  Extrait.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idEmploye = json['idEmploye'];
    nom = json['nom'];
    prenom = json['prenom'];
    date_naissance = json['date_naissance'];
    lieu_naissance = json['lieu_naissance'];
    prenom_pere = json['prenom_pere'];
    prenom_mere = json['prenom_mere'];
    nom_mere = json['nom_mere'];
    date_naissancepere = json['date_naissancepere'];
    date_naissancemere = json['date_naissancemere'];
  }
}
