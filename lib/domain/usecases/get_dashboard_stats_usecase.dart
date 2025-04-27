import 'package:dartz/dartz.dart';
import 'package:teranga_agro/features/dashboard/domain/entities/dashboard_stats.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardStatsUseCase {
  final DashboardRepository repository;

  GetDashboardStatsUseCase(this.repository);

  Future<Either<Failure, DashboardStats>> call() async {
    return await repository.getDashboardStats();
  }
}