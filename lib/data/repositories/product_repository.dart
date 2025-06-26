import 'package:test_test/app/hive_helper.dart';

import '../../app/app_constants.dart';
import '../models/product.dart';
import '../services/api_service.dart'; // Application constants for API endpoints

class ProductRepository {
  final ApiService apiService; // Instance of ApiService for making API calls

  // Constructor for ProductRepository
  ProductRepository(this.apiService);

  // Fetches a list of all products from the API
  Future<List<Product>> getProducts() async {
    try {
      Map<String, dynamic> response = {};
      final storedData =
          HiveHelper.getDatWithKey<Map<String, dynamic>>(HiveHelper.dashBoardData);

      if (storedData==null) {
        response = await apiService.get(AppConstants.productsEndpoint);
      } else {
         response.addAll(storedData);
      }

      final List<Product> products = [];
      final Map<String, dynamic> map = {};
      response.forEach((key, value) {
        // Create Product object, passing the key as the ID
        products.add(Product.fromJson(value as Map<String, dynamic>, id: key));
        map.addAll({key: value});
      });
      HiveHelper.updateMap(HiveHelper.dashBoardData, map);
      return products;
    } catch (e) {
      // Re-throw the exception to be handled by the calling layer (ViewModel/UseCase)
      throw Exception('Error fetching products: $e');
    }
  }

  // Adds a new product to the API
  Future<void> addProduct(Product product) async {
    try {
      // Make a POST request to the products endpoint with product data
      // Firebase will generate an ID for new entries, so we don't send the local ID
      await apiService.post(AppConstants.productsEndpoint, product.toJson());
      await HiveHelper.removeKeyData(HiveHelper.dashBoardData);
    } catch (e) {
      // Re-throw the exception to be handled by the calling layer (ViewModel/UseCase)
      throw Exception('Error adding product: $e');
    }
  }
}
