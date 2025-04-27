import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';
import '../repositories/marketplace_repository.dart';

class AddProductUseCase {
  final MarketplaceRepository repository;

  AddProductUseCase(this.repository);

  Future<Either<Failure, void>> call(Product product) async {
    return await repository.addProduct(product);
  }
}