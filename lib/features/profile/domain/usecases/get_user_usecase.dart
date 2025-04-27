import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/profile_repository.dart';

class GetUserUseCase {
  final ProfileRepository repository;

  GetUserUseCase(this.repository);

  Future<Either<Failure, User>> call() async {
    return await repository.getUser();
  }
}