import 'package:dartz/dartz.dart';
import 'package:teranga_agro/features/parcelle/data/models/culture_model.dart' as model;
import 'package:teranga_agro/features/parcelle/data/models/parcelle_model.dart' as model;
import 'package:teranga_agro/features/parcelle/data/models/suivi_model.dart' as model;
import 'package:teranga_agro/features/parcelle/domain/entities/suivi.dart' as entity;
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/parcelle.dart' as entity;
import '../../domain/entities/culture.dart' as entity;
import '../../domain/repositories/parcelle_repository.dart';
import '../datasources/parcelle_local_data_source.dart';
import '../../../../core/network/queue.dart';

class ParcelleRepositoryImpl implements ParcelleRepository {
  final ParcelleLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final QueueManager queueManager;

  ParcelleRepositoryImpl(
      this.localDataSource, this.networkInfo, this.queueManager);

  @override
  Future<Either<Failure, List<entity.Parcelle>>> getParcelles() async {
    try {
      final localParcelles = await localDataSource.getParcelles();
      print('ParcelleRepositoryImpl: Successfully fetched ${localParcelles.length} parcelles');
      // Map ParcelleModel to Parcelle (domain entity)
      final parcelles = localParcelles
          .map((modelParcelle) => entity.Parcelle(
                id: modelParcelle.id,
                nom: modelParcelle.nom,
                surface: modelParcelle.surface,
                latitude: modelParcelle.latitude,
                longitude: modelParcelle.longitude,
              ))
          .toList();
      return Right(parcelles);
    } catch (e) {
      print('ParcelleRepositoryImpl: Error fetching parcelles: $e');
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addParcelle(entity.Parcelle parcelle) async {
    try {
      final parcelleModel = model.ParcelleModel(
        id: parcelle.id,
        nom: parcelle.nom,
        surface: parcelle.surface,
        latitude: parcelle.latitude,
        longitude: parcelle.longitude,
      );
      await localDataSource.addParcelle(parcelleModel);
      if (!await networkInfo.isConnected) {
        await queueManager.addToQueue(
            {'action': 'add_parcelle', 'data': parcelleModel.toJson()});
        print('ParcelleRepositoryImpl: Added parcelle to offline queue: ${parcelle.nom}');
        return Left(OfflineFailure());
      }
      print('ParcelleRepositoryImpl: Successfully added parcelle: ${parcelle.nom}');
      return const Right(null);
    } catch (e) {
      print('ParcelleRepositoryImpl: Error adding parcelle: $e');
      return Left(ServerFailure('Failed to add parcelle: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateParcelle(entity.Parcelle parcelle) async {
    try {
      final parcelleModel = model.ParcelleModel(
        id: parcelle.id,
        nom: parcelle.nom,
        surface: parcelle.surface,
        latitude: parcelle.latitude,
        longitude: parcelle.longitude,
      );
      await localDataSource.updateParcelle(parcelleModel);
      if (!await networkInfo.isConnected) {
        await queueManager.addToQueue(
            {'action': 'update_parcelle', 'data': parcelleModel.toJson()});
        print('ParcelleRepositoryImpl: Added parcelle update to offline queue: ${parcelle.nom}');
        return Left(OfflineFailure());
      }
      print('ParcelleRepositoryImpl: Successfully updated parcelle: ${parcelle.nom}');
      return const Right(null);
    } catch (e) {
      print('ParcelleRepositoryImpl: Error updating parcelle: $e');
      return Left(ServerFailure('Failed to update parcelle: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteParcelle(int id) async {
    try {
      await localDataSource.deleteParcelle(id);
      if (!await networkInfo.isConnected) {
        await queueManager.addToQueue({
          'action': 'delete_parcelle',
          'data': {'id': id}
        });
        print('ParcelleRepositoryImpl: Added parcelle deletion to offline queue: $id');
        return Left(OfflineFailure());
      }
      print('ParcelleRepositoryImpl: Successfully deleted parcelle: $id');
      return const Right(null);
    } catch (e) {
      print('ParcelleRepositoryImpl: Error deleting parcelle: $e');
      return Left(ServerFailure('Failed to delete parcelle: $e'));
    }
  }

  @override
  Future<Either<Failure, List<entity.Culture>>> getCultures(int parcelleId) async {
    try {
      final cultures = await localDataSource.getCultures(parcelleId);
      print('ParcelleRepositoryImpl: Successfully fetched ${cultures.length} cultures for parcelle $parcelleId');
      // Map CultureModel to Culture (domain entity)
      final domainCultures = cultures
          .map((modelCulture) => entity.Culture(
                id: modelCulture.id,
                parcelleId: modelCulture.parcelleId,
                nom: modelCulture.nom,
                type: modelCulture.type,
                datePlantation: modelCulture.datePlantation,
              ))
          .toList();
      return Right(domainCultures);
    } catch (e) {
      print('ParcelleRepositoryImpl: Error fetching cultures: $e');
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addCulture(entity.Culture culture) async {
    try {
      final cultureModel = model.CultureModel(
        id: culture.id,
        parcelleId: culture.parcelleId,
        nom: culture.nom,
        type: culture.type,
        datePlantation: culture.datePlantation,
      );
      await localDataSource.addCulture(cultureModel);
      if (!await networkInfo.isConnected) {
        await queueManager.addToQueue(
            {'action': 'add_culture', 'data': cultureModel.toJson()});
        print('ParcelleRepositoryImpl: Added culture to offline queue: ${culture.nom}');
        return Left(OfflineFailure());
      }
      print('ParcelleRepositoryImpl: Successfully added culture: ${culture.nom}');
      return const Right(null);
    } catch (e) {
      print('ParcelleRepositoryImpl: Error adding culture: $e');
      return Left(ServerFailure('Failed to add culture: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateCulture(entity.Culture culture) async {
    try {
      final cultureModel = model.CultureModel(
        id: culture.id,
        parcelleId: culture.parcelleId,
        nom: culture.nom,
        type: culture.type,
        datePlantation: culture.datePlantation,
      );
      await localDataSource.updateCulture(cultureModel);
      if (!await networkInfo.isConnected) {
        await queueManager.addToQueue(
            {'action': 'update_culture', 'data': cultureModel.toJson()});
        print('ParcelleRepositoryImpl: Added culture update to offline queue: ${culture.nom}');
        return Left(OfflineFailure());
      }
      print('ParcelleRepositoryImpl: Successfully updated culture: ${culture.nom}');
      return const Right(null);
    } catch (e) {
      print('ParcelleRepositoryImpl: Error updating culture: $e');
      return Left(ServerFailure('Failed to update culture: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCulture(int id) async {
    try {
      await localDataSource.deleteCulture(id);
      if (!await networkInfo.isConnected) {
        await queueManager.addToQueue({
          'action': 'delete_culture',
          'data': {'id': id}
        });
        print('ParcelleRepositoryImpl: Added culture deletion to offline queue: $id');
        return Left(OfflineFailure());
      }
      print('ParcelleRepositoryImpl: Successfully deleted culture: $id');
      return const Right(null);
    } catch (e) {
      print('ParcelleRepositoryImpl: Error deleting culture: $e');
      return Left(ServerFailure('Failed to delete culture: $e'));
    }
  }

  @override
  Future<Either<Failure, List<entity.Suivi>>> getSuivis(int cultureId) async {
    try {
      final suivis = await localDataSource.getSuivis(cultureId);
      print('ParcelleRepositoryImpl: Successfully fetched ${suivis.length} suivis for culture $cultureId');
      // Map SuiviModel to Suivi (domain entity)
      final domainSuivis = suivis
          .map((modelSuivi) => entity.Suivi(
                id: modelSuivi.id,
                cultureId: modelSuivi.cultureId,
                type: modelSuivi.type,
                date: modelSuivi.date,
                notes: modelSuivi.notes,
              ))
          .toList();
      return Right(domainSuivis);
    } catch (e) {
      print('ParcelleRepositoryImpl: Error fetching suivis: $e');
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addSuivi(entity.Suivi suivi) async {
    try {
      final suiviModel = model.SuiviModel(
        id: suivi.id,
        cultureId: suivi.cultureId,
        type: suivi.type,
        date: suivi.date,
        notes: suivi.notes,
      );
      await localDataSource.addSuivi(suiviModel);
      if (!await networkInfo.isConnected) {
        await queueManager.addToQueue(
            {'action': 'add_suivi', 'data': suiviModel.toJson()});
        print('ParcelleRepositoryImpl: Added suivi to offline queue: ${suivi.type}');
        return Left(OfflineFailure());
      }
      print('ParcelleRepositoryImpl: Successfully added suivi: ${suivi.type}');
      return const Right(null);
    } catch (e) {
      print('ParcelleRepositoryImpl: Error adding suivi: $e');
      return Left(ServerFailure('Failed to add suivi: $e'));
    }
  }
}