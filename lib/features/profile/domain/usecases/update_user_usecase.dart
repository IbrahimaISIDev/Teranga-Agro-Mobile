import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/profile_repository.dart';

class UpdateUserUseCase {
  final ProfileRepository repository;

  UpdateUserUseCase(this.repository);

  Future<Either<Failure, void>> call(User user) async {
    return await repository.updateUser(user);
  }
}