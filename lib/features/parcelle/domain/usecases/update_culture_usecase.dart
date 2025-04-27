import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/culture.dart';
import '../repositories/parcelle_repository.dart';

class UpdateCultureUseCase {
  final ParcelleRepository repository;

  UpdateCultureUseCase(this.repository);

  Future<Either<Failure, void>> call(Culture culture) async {
    return await repository.updateCulture(culture);
  }
}