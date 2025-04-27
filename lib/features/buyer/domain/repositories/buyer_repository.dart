import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

abstract class BuyerRepository {
  Future<Either<Failure, List<Order>>> getOrders();
  Future<Either<Failure, void>> placeOrder(int productId, String productName, int quantity, double totalPrice);
}