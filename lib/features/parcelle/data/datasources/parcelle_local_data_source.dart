import 'package:sqflite/sqflite.dart';
import '../../../../core/storage/database.dart';
import '../models/parcelle_model.dart';
import '../models/culture_model.dart';
import '../models/suivi_model.dart';

abstract class ParcelleLocalDataSource {
  Future<List<ParcelleModel>> getParcelles();
  Future<void> addParcelle(ParcelleModel parcelle);
  Future<void> updateParcelle(ParcelleModel parcelle);
  Future<void> deleteParcelle(int id);
  Future<List<CultureModel>> getCultures(int parcelleId);
  Future<void> addCulture(CultureModel culture);
  Future<void> updateCulture(CultureModel culture);
  Future<void> deleteCulture(int id);
  Future<List<SuiviModel>> getSuivis(int cultureId);
  Future<void> addSuivi(SuiviModel suivi);
}

class ParcelleLocalDataSourceImpl implements ParcelleLocalDataSource {
  final DatabaseHelper databaseHelper;

  ParcelleLocalDataSourceImpl({required this.databaseHelper});

  Future<bool> hasColumn(Database db, String table, String column) async {
    final columns = await db.rawQuery('PRAGMA table_info($table)');
    return columns.any((col) => col['name'] == column);
  }

  @override
  Future<List<ParcelleModel>> getParcelles() async {
    try {
      final db = await databaseHelper.database;
      final parcellesMaps = await db.rawQuery('SELECT * FROM parcelles');
      print('ParcelleLocalDataSource: Fetched ${parcellesMaps.length} parcelles');
      return parcellesMaps.map((map) => ParcelleModel.fromJson(map)).toList();
    } catch (e) {
      print('ParcelleLocalDataSource: Error fetching parcelles: $e');
      throw Exception('Failed to fetch parcelles: $e');
    }
  }

  @override
  Future<void> addParcelle(ParcelleModel parcelle) async {
    try {
      final db = await databaseHelper.database;
      if (!(await hasColumn(db, 'parcelles', 'nom'))) {
        throw Exception('Column nom does not exist in parcelles table');
      }
      await db.insert(
        'parcelles',
        parcelle.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('ParcelleLocalDataSource: Successfully added parcelle: ${parcelle.nom}');
    } catch (e) {
      print('ParcelleLocalDataSource: Error adding parcelle: $e');
      throw Exception('Failed to add parcelle: $e');
    }
  }

  @override
  Future<void> updateParcelle(ParcelleModel parcelle) async {
    try {
      final db = await databaseHelper.database;
      await db.update(
        'parcelles',
        parcelle.toJson(),
        where: 'id = ?',
        whereArgs: [parcelle.id],
      );
      print('ParcelleLocalDataSource: Successfully updated parcelle: ${parcelle.nom}');
    } catch (e) {
      print('ParcelleLocalDataSource: Error updating parcelle: $e');
      throw Exception('Failed to update parcelle: $e');
    }
  }

  @override
  Future<void> deleteParcelle(int id) async {
    try {
      final db = await databaseHelper.database;
      await db.delete(
        'parcelles',
        where: 'id = ?',
        whereArgs: [id],
      );
      print('ParcelleLocalDataSource: Successfully deleted parcelle: $id');
    } catch (e) {
      print('ParcelleLocalDataSource: Error deleting parcelle: $e');
      throw Exception('Failed to delete parcelle: $e');
    }
  }

  @override
  Future<List<CultureModel>> getCultures(int parcelleId) async {
    try {
      final db = await databaseHelper.database;
      final culturesMaps = await db.rawQuery(
        'SELECT * FROM cultures WHERE parcelleId = ?',
        [parcelleId],
      );
      print('ParcelleLocalDataSource: Fetched ${culturesMaps.length} cultures for parcelle $parcelleId');
      return culturesMaps.map((map) => CultureModel.fromJson(map)).toList();
    } catch (e) {
      print('ParcelleLocalDataSource: Error fetching cultures: $e');
      throw Exception('Failed to fetch cultures: $e');
    }
  }

  @override
  Future<void> addCulture(CultureModel culture) async {
    try {
      final db = await databaseHelper.database;
      if (!(await hasColumn(db, 'cultures', 'datePlantation'))) {
        throw Exception('Column datePlantation does not exist in cultures table');
      }
      await db.insert(
        'cultures',
        culture.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('ParcelleLocalDataSource: Successfully added culture: ${culture.nom}');
    } catch (e) {
      print('ParcelleLocalDataSource: Error adding culture: $e');
      throw Exception('Failed to add culture: $e');
    }
  }

  @override
  Future<void> updateCulture(CultureModel culture) async {
    try {
      final db = await databaseHelper.database;
      await db.update(
        'cultures',
        culture.toJson(),
        where: 'id = ?',
        whereArgs: [culture.id],
      );
      print('ParcelleLocalDataSource: Successfully updated culture: ${culture.nom}');
    } catch (e) {
      print('ParcelleLocalDataSource: Error updating culture: $e');
      throw Exception('Failed to update culture: $e');
    }
  }

  @override
  Future<void> deleteCulture(int id) async {
    try {
      final db = await databaseHelper.database;
      await db.delete(
        'cultures',
        where: 'id = ?',
        whereArgs: [id],
      );
      print('ParcelleLocalDataSource: Successfully deleted culture: $id');
    } catch (e) {
      print('ParcelleLocalDataSource: Error deleting culture: $e');
      throw Exception('Failed to delete culture: $e');
    }
  }

  @override
  Future<List<SuiviModel>> getSuivis(int cultureId) async {
    try {
      final db = await databaseHelper.database;
      final suivisMaps = await db.rawQuery(
        'SELECT * FROM suivis WHERE cultureId = ?',
        [cultureId],
      );
      print('ParcelleLocalDataSource: Fetched ${suivisMaps.length} suivis for culture $cultureId');
      return suivisMaps.map((map) => SuiviModel.fromJson(map)).toList();
    } catch (e) {
      print('ParcelleLocalDataSource: Error fetching suivis: $e');
      throw Exception('Failed to fetch suivis: $e');
    }
  }

  @override
  Future<void> addSuivi(SuiviModel suivi) async {
    try {
      final db = await databaseHelper.database;
      if (!(await hasColumn(db, 'suivis', 'cultureId'))) {
        throw Exception('Column cultureId does not exist in suivis table');
      }
      await db.insert(
        'suivis',
        suivi.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('ParcelleLocalDataSource: Successfully added suivi: ${suivi.type}');
    } catch (e) {
      print('ParcelleLocalDataSource: Error adding suivi: $e');
      throw Exception('Failed to add suivi: $e');
    }
  }
}