import 'package:dartz/dartz.dart';
import 'package:teranga_agro/core/errors/failures.dart';
import 'package:teranga_agro/features/parcelle/domain/entities/culture.dart';
import 'package:teranga_agro/features/parcelle/domain/entities/parcelle.dart';
import 'package:teranga_agro/features/parcelle/domain/entities/suivi.dart';

abstract class ParcelleRepository {
  Future<Either<Failure, List<Parcelle>>> getParcelles();
  Future<Either<Failure, void>> addParcelle(Parcelle parcelle);
  Future<Either<Failure, void>> updateParcelle(Parcelle parcelle);
  Future<Either<Failure, void>> deleteParcelle(int id);

  Future<Either<Failure, List<Culture>>> getCultures(int parcelleId);
  Future<Either<Failure, void>> addCulture(Culture culture);

  Future<Either<Failure, void>> updateCulture(Culture culture);
  Future<Either<Failure, void>> deleteCulture(int id);

    Future<Either<Failure, List<Suivi>>> getSuivis(int cultureId);
  Future<Either<Failure, void>> addSuivi(Suivi suivi);
}
