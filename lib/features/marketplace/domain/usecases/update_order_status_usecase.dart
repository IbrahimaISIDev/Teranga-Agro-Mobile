import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/marketplace_repository.dart';

class UpdateOrderStatusUseCase {
  final MarketplaceRepository repository;

  UpdateOrderStatusUseCase(this.repository);

  Future<Either<Failure, void>> call(int orderId, String status) async {
    return await repository.updateOrderStatus(orderId, status);
  }
}