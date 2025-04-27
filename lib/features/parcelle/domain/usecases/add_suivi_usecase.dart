import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/suivi.dart';
import '../repositories/parcelle_repository.dart';

class AddSuiviUseCase {
  final ParcelleRepository repository;

  AddSuiviUseCase(this.repository);

  Future<Either<Failure, void>> call(Suivi suivi) async {
    return await repository.addSuivi(suivi);
  }
}