class Mariage {
  int? id;
  String? prenomMari;
  int? idEmploye;
  String? nomMari;
  String? prenomFemme;
  String? nomFemme;
  String? nomTemoin;
  String? prenomTemoin;
  String? dateMariage;

  Mariage({
    this.id,
    this.prenomMari,
    this.idEmploye,
    this.nomMari,
    this.prenomFemme,
    this.nomFemme,
    this.nomTemoin,
    this.prenomTemoin,
    this.dateMariage,
  });

  Mariage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prenomMari = json['prenomMari'];
    idEmploye = json['idEmploye'];
    nomMari = json['nomMari'];
    prenomFemme = json['prenomFemme'];
    nomFemme = json['nomFemme'];
    nomTemoin = json['nomTemoin'];
    prenomTemoin = json['prenomTemoin'];
    dateMariage = json['date_mariage'];
  }
}
