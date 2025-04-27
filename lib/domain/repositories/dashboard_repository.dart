import 'package:dartz/dartz.dart';
import 'package:teranga_agro/features/dashboard/domain/entities/dashboard_stats.dart';
import '../../../../core/errors/failures.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardStats>> getDashboardStats();
}