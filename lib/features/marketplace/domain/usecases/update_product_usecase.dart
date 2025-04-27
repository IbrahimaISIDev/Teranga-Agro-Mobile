import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';
import '../repositories/marketplace_repository.dart';

class UpdateProductUseCase {
  final MarketplaceRepository repository;

  UpdateProductUseCase(this.repository);

  Future<Either<Failure, void>> call(Product product) async {
    return await repository.updateProduct(product);
  }
}