import '../../domain/entities/culture.dart';

class CultureModel extends Culture {
  CultureModel({
    required int id,
    required int parcelleId,
    required String nom,
    required String type,
    required String datePlantation,
  }) : super(id: id, parcelleId: parcelleId, nom: nom, type: type, datePlantation: datePlantation);

  factory CultureModel.fromJson(Map<String, dynamic> json) {
    return CultureModel(
      id: json['id'],
      parcelleId: json['parcelleId'],
      nom: json['nom'],
      type: json['type'],
      datePlantation: json['datePlantation'], // Corrigé pour correspondre au schéma
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parcelleId': parcelleId,
      'nom': nom,
      'type': type,
      'datePlantation': datePlantation, // Corrigé pour correspondre au schéma
    };
  }
}

class Culture {
  final int id;
  final int parcelleId;
  final String nom;
  final String type;
  final String datePlantation;

  Culture({
    required this.id,
    required this.parcelleId,
    required this.nom,
    required this.type,
    required this.datePlantation,
  });
}