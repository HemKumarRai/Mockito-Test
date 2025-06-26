

import '../../data/models/product.dart';
import '../../data/repositories/product_repository.dart'; // Product repository

class AddProductUseCase {
  final ProductRepository _productRepository; // Instance of ProductRepository

  // Constructor for AddProductUseCase
  AddProductUseCase(this._productRepository);

  // Executes the use case to add a new product
  Future<void> call(Product product) async {
    try {
      await _productRepository.addProduct(product); // Call the repository to add the product
    } catch (e) {
      // Re-throw any exceptions for higher-level error handling
      throw Exception('Failed to add product: $e');
    }
  }
}
