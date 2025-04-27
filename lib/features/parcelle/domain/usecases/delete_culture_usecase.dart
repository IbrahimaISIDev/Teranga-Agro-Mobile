import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/parcelle_repository.dart';

class DeleteCultureUseCase {
  final ParcelleRepository repository;

  DeleteCultureUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    return await repository.deleteCulture(id);
  }
}