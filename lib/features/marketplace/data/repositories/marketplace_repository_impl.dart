import 'package:dartz/dartz.dart' as dartz;
import 'package:teranga_agro/core/network/network_info.dart';
import 'package:teranga_agro/features/marketplace/data/models/product_model.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/order.dart';
import '../../data/datasources/marketplace_local_data_source.dart';
import '../../domain/repositories/marketplace_repository.dart';

class MarketplaceRepositoryImpl implements MarketplaceRepository {
  final MarketplaceLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  MarketplaceRepositoryImpl(this.localDataSource, this.networkInfo);

  @override
  Future<dartz.Either<Failure, List<Product>>> getProducts() async {
    try {
      final products = await localDataSource.getProducts();
      return dartz.Right(products);
    } catch (e) {
      return dartz.Left(
          ServerFailure('Failed to fetch products: ${e.toString()}'));
    }
  }

  @override
  Future<dartz.Either<Failure, List<Order>>> getOrders() async {
    try {
      // Récupérer directement la liste d'OrderModel sans transformation supplémentaire
      final orders = await localDataSource.getOrders();
      return dartz.Right(orders);
    } catch (e) {
      return dartz.Left(
          ServerFailure('Failed to fetch orders: ${e.toString()}'));
    }
  }

  @override
  Future<dartz.Either<Failure, void>> updateOrderStatus(
      int orderId, String status) async {
    try {
      await localDataSource.updateOrderStatus(orderId, status);
      return const dartz.Right(null);
    } catch (e) {
      return dartz.Left(
          ServerFailure('Failed to update order status: ${e.toString()}'));
    }
  }

  Future<dartz.Either<Failure, void>> addProduct(Product product) async {
    try {
      await localDataSource.addProduct(product as ProductModel);
      return const dartz.Right(null);
    } catch (e) {
      return dartz.Left(OfflineFailure());
    }
  }

  Future<dartz.Either<Failure, void>> updateProduct(Product product) async {
    try {
      await localDataSource.updateProduct(product as ProductModel);
      return const dartz.Right(null);
    } catch (e) {
      return dartz.Left(OfflineFailure());
    }
  }
}
