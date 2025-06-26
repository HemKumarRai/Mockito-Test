

import '../../data/models/product.dart';
import '../../data/repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository _productRepository; // Instance of ProductRepository

  // Constructor for GetProductsUseCase
  GetProductsUseCase(this._productRepository);

  // Executes the use case to get all products
  Future<List<Product>> call() async {
    try {
      return await _productRepository.getProducts(); // Call the repository to get products
    } catch (e) {
      // Re-throw any exceptions for higher-level error handling
      throw Exception('Failed to get products: $e');
    }
  }
}