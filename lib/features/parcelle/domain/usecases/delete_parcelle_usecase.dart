import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/parcelle_repository.dart';

class DeleteParcelleUseCase {
  final ParcelleRepository repository;

  DeleteParcelleUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    return await repository.deleteParcelle(id);
  }
}