import 'package:dartz/dartz.dart' as dartz; // Add alias for dartz
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';
import '../entities/order.dart'; // Your custom Order class

abstract class MarketplaceRepository {
  Future<dartz.Either<Failure, List<Product>>> getProducts();
  Future<dartz.Either<Failure, List<Order>>> getOrders();
  Future<dartz.Either<Failure, void>> updateOrderStatus(int orderId, String status);
  Future<dartz.Either<Failure, void>> addProduct(Product product);
  Future<dartz.Either<Failure, void>> updateProduct(Product product);
}