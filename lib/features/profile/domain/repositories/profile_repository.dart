import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class ProfileRepository {
  Future<Either<Failure, User>> getUser();
  Future<Either<Failure, void>> updateUser(User user);
}