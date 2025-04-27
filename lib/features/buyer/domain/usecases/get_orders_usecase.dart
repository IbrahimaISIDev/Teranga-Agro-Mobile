import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/buyer_repository.dart';

class GetOrdersUseCase {
  final BuyerRepository repository;

  GetOrdersUseCase(this.repository);

  Future<Either<Failure, List<Order>>> call() async {
    return await repository.getOrders();
  }
}