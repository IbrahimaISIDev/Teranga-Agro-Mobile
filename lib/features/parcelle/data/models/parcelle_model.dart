import '../../domain/entities/parcelle.dart';

class ParcelleModel extends Parcelle {
  ParcelleModel({
    int? id, // Changed to nullable to match Parcelle
    required String nom,
    required double surface,
    double? latitude,
    double? longitude,
  }) : super(id: id, nom: nom, surface: surface, latitude: latitude, longitude: longitude);

  factory ParcelleModel.fromJson(Map<String, dynamic> json) {
    return ParcelleModel(
      id: json['id'], // json['id'] can be null since SQLite can return null for INTEGER PRIMARY KEY
      nom: json['nom'],
      surface: json['surface'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // id can be null; SQLite will handle it (e.g., auto-increment for null id)
      'nom': nom,
      'surface': surface,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}