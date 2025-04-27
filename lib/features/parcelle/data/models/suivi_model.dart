import '../../domain/entities/suivi.dart';

class SuiviModel extends Suivi {
  SuiviModel({
    required int id,
    required int cultureId,
    required String type,
    required String date,
    String? notes,
  }) : super(id: id, cultureId: cultureId, type: type, date: date, notes: notes);

  factory SuiviModel.fromJson(Map<String, dynamic> json) {
    return SuiviModel(
      id: json['id'],
      cultureId: json['cultureId'],
      type: json['type'],
      date: json['date'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cultureId': cultureId,
      'type': type,
      'date': date,
      'notes': notes,
    };
  }
}

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