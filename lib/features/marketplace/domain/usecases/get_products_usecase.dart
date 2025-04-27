import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';
import '../repositories/marketplace_repository.dart';

class GetProductsUseCase {
  final MarketplaceRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<Product>>> call() async {
    return await repository.getProducts();
  }
}