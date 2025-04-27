import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/parcelle.dart';
import '../repositories/parcelle_repository.dart';

class UpdateParcelleUseCase {
  final ParcelleRepository repository;

  UpdateParcelleUseCase(this.repository);

  Future<Either<Failure, void>> call(Parcelle parcelle) async {
    return await repository.updateParcelle(parcelle);
  }
}