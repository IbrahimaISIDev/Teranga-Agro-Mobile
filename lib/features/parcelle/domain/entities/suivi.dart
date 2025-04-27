class Suivi {
  final int id;
  final int cultureId;
  final String type;
  final String date;
  final String? notes;

  Suivi({
    required this.id,
    required this.cultureId,
    required this.type,
    required this.date,
    this.notes,
  });
}