import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';
import '../models/user_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl(this.localDataSource, this.networkInfo);

  @override
  Future<Either<Failure, User>> getUser() async {
    try {
      final user = await localDataSource.getUser();
      return Right(user);
    } catch (e) {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateUser(User user) async {
    try {
      await localDataSource.updateUser(user as UserModel);
      return const Right(null);
    } catch (e) {
      return Left(OfflineFailure());
    }
  }
}