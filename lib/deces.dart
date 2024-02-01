class Deces {
  int? id;
  int? idEmploye;
  String? nom;
  String? prenom;
  String? dateNaissance;
  String? lieuNaissance;
  String? dateDeces;
  String? lieuDeces;
  String? cause;

  Deces({
    this.id,
    this.idEmploye,
    this.nom,
    this.prenom,
    this.dateNaissance,
    this.lieuNaissance,
    this.dateDeces,
    this.lieuDeces,
    this.cause,
  });

  Deces.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idEmploye = json['idEmploye'];
    nom = json['nom'];
    prenom = json['prenom'];
    dateNaissance = json['date_naissance'];
    lieuNaissance = json['lieu_naissance'];
    dateDeces = json['date_deces'];
    lieuDeces = json['lieu_deces'];
    cause = json['cause'];
  }
}
