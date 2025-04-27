import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/buyer_repository.dart';

class PlaceOrderUseCase {
  final BuyerRepository repository;

  PlaceOrderUseCase(this.repository);

  Future<Either<Failure, void>> call(int productId, String productName, int quantity, double totalPrice) async {
    return await repository.placeOrder(productId, productName, quantity, totalPrice);
  }
}