import 'package:dartz/dartz.dart';
import 'package:teranga_agro/core/errors/failures.dart';
import 'package:teranga_agro/features/parcelle/domain/entities/parcelle.dart';
import 'package:teranga_agro/features/parcelle/domain/repositories/parcelle_repository.dart';

class AddParcelleUseCase {
  final ParcelleRepository repository;

  AddParcelleUseCase(this.repository);

  Future<Either<Failure, void>> call(Parcelle parcelle) async {
    return await repository.addParcelle(parcelle);
  }
}