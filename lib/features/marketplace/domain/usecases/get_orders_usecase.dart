import 'package:dartz/dartz.dart' as dartz; // Add alias for dartz
import '../../../../core/errors/failures.dart';
import '../entities/order.dart'; // Your custom Order class
import '../repositories/marketplace_repository.dart';

class GetOrdersUseCase {
  final MarketplaceRepository repository;

  GetOrdersUseCase(this.repository);

  Future<dartz.Either<Failure, List<Order>>> call() async {
    return await repository.getOrders();
  }
}