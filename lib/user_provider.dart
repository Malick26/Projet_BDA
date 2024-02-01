import 'package:flutter/material.dart';

/*
class UserProvider extends ChangeNotifier {
  String userId = '';
  String userName = '';
  DateTime userCreationDate = DateTime.now();

  void setUserDetails(String id, String name, DateTime creationDate) {
    userId = id;
    userName = name;
    userCreationDate = creationDate;
    notifyListeners();
  }
}
*/
class UserProvider extends ChangeNotifier {
  int userId = 0; // Définissez le type comme int si l'ID est un entier
  String userName = '';
  DateTime userCreationDate = DateTime.now();

  void setUserDetails(int id, String name, DateTime creationDate) {
    userId = id;
    userName = name;
    userCreationDate = creationDate;
    notifyListeners();
  }
}
