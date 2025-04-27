import 'package:sqflite/sqflite.dart';
import '../../../../core/storage/database.dart';
import '../../../parcelle/data/models/suivi_model.dart' as model;
import '../../../parcelle/domain/entities/suivi.dart' as entity;
import '../../domain/entities/dashboard_stats.dart';
import '../models/dashboard_stats_model.dart';

abstract class DashboardLocalDataSource {
  Future<DashboardStats> getDashboardStats();
}

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  @override
  Future<DashboardStats> getDashboardStats() async {
    final db = await DatabaseHelper.instance.database;
    final parcellesCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM parcelles')) ?? 0;
    final culturesCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM cultures')) ?? 0;
    final suivisMaps = await db.rawQuery('SELECT * FROM suivis ORDER BY date DESC LIMIT 3');
    final recentSuivisModels = suivisMaps.map((map) => model.SuiviModel.fromJson(map)).toList();

    // Map SuiviModel to Suivi (domain entity)
    final recentSuivis = recentSuivisModels
        .map((suiviModel) => entity.Suivi(
              id: suiviModel.id ?? 0, // Handle null id (if id is nullable in SuiviModel)
              cultureId: suiviModel.cultureId,
              type: suiviModel.type,
              date: suiviModel.date,
              notes: suiviModel.notes,
            ))
        .toList();

    return DashboardStatsModel(
      parcellesCount: parcellesCount,
      culturesCount: culturesCount,
      recentSuivis: recentSuivis,
    );
  }
}