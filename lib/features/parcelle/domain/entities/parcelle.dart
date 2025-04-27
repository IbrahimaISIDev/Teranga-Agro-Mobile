class Parcelle {
  final int? id; // Changed to nullable
  final String nom;
  final double surface;
  final double? latitude;
  final double? longitude;

  const Parcelle({
    this.id, // No longer required
    required this.nom,
    required this.surface,
    this.latitude,
    this.longitude,
  });
}