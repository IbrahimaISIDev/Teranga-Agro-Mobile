import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/culture.dart';
import '../repositories/parcelle_repository.dart';

class AddCultureUseCase {
  final ParcelleRepository repository;

  AddCultureUseCase(this.repository);

  Future<Either<Failure, void>> call(Culture culture) async {
    return await repository.addCulture(culture);
  }
}