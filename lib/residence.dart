class Residence {
  int? id;
  int? idEmploye;
  String? nom;
  String? prenom;
  String? adresse;
  int? duree;
  String? lieu;

  Residence({
    this.id,
    this.idEmploye,
    this.nom,
    this.prenom,
    this.adresse,
    this.duree,
    this.lieu,
  });

  Residence.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idEmploye = json['idEmploye'];
    nom = json['nom'];
    prenom = json['prenom'];
    adresse = json['adresse'];
    duree = json['duree'];
    lieu = json['lieu'];
  }
}
