import '../../../parcelle/data/models/suivi_model.dart' as model;
import '../../../parcelle/domain/entities/suivi.dart' as entity;
import '../../domain/entities/dashboard_stats.dart';

class DashboardStatsModel extends DashboardStats {
  DashboardStatsModel({
    required super.parcellesCount,
    required super.culturesCount,
    required super.recentSuivis,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    final recentSuivisModels = (json['recentSuivis'] as List)
        .map((item) => model.SuiviModel.fromJson(item as Map<String, dynamic>))
        .toList();

    // Map SuiviModel to Suivi (domain entity)
    final recentSuivis = recentSuivisModels
        .map((suiviModel) => entity.Suivi(
              id: suiviModel.id ?? 0, // Handle null id
              cultureId: suiviModel.cultureId,
              type: suiviModel.type,
              date: suiviModel.date,
              notes: suiviModel.notes,
            ))
        .toList();

    return DashboardStatsModel(
      parcellesCount: json['parcellesCount'] as int,
      culturesCount: json['culturesCount'] as int,
      recentSuivis: recentSuivis,
    );
  }

  Map<String, dynamic> toJson() {
    // Map Suivi (domain entity) back to SuiviModel for serialization
    final recentSuivisModels = recentSuivis
        .map((suivi) => model.SuiviModel(
              id: suivi.id,
              cultureId: suivi.cultureId,
              type: suivi.type,
              date: suivi.date,
              notes: suivi.notes,
            ))
        .toList();

    return {
      'parcellesCount': parcellesCount,
      'culturesCount': culturesCount,
      'recentSuivis': recentSuivisModels.map((suiviModel) => suiviModel.toJson()).toList(),
    };
  }
}