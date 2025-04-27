import 'package:dartz/dartz.dart';
import 'package:teranga_agro/core/errors/failures.dart';
import 'package:teranga_agro/features/parcelle/domain/entities/parcelle.dart';
import 'package:teranga_agro/features/parcelle/domain/repositories/parcelle_repository.dart';

class GetParcellesUseCase {
  final ParcelleRepository repository;

  GetParcellesUseCase(this.repository);

  Future<Either<Failure, List<Parcelle>>> call() async {
    return await repository.getParcelles();
  }
}