import 'package:flutter/material.dart';

import '../../../data/models/product.dart';
import '../../../domain/usecases/get_products_usecase.dart'; // Use case to fetch products

enum HomeState { initial, loading, loaded, error } // States for the home screen

class HomeViewModel extends ChangeNotifier {
  final GetProductsUseCase _getProductsUseCase; // Use case for fetching products

  HomeViewModel(this._getProductsUseCase);

  HomeState _state = HomeState.initial; // Current state of the home screen
  List<Product> _allProducts = []; // List of all fetched products
  final List<Product> _favoriteProducts = []; // List of favorite products
  String? _errorMessage; // Error message if any

  // Getters for state variables
  HomeState get state => _state;
  List<Product> get allProducts => _allProducts;
  List<Product> get favoriteProducts => _favoriteProducts;
  String? get errorMessage => _errorMessage;

  // Fetches products from the API
  Future<void> fetchProducts() async {
    _state = HomeState.loading; // Set state to loading
    _errorMessage = null; // Clear any previous error messages
    notifyListeners(); // Notify listeners to show loading indicator

    try {
      _allProducts = await _getProductsUseCase.call(); // Execute use case to get products
      _state = HomeState.loaded; // Set state to loaded on success
    } catch (e) {
      _errorMessage = 'Failed to load products: $e'; // Set error message
      _state = HomeState.error; // Set state to error on failure
    } finally {
      notifyListeners(); // Notify listeners to update UI
    }
  }

  // Toggles a product's favorite status
  void toggleFavorite(Product product) {
    if (_favoriteProducts.contains(product)) {
      _favoriteProducts.remove(product); // Remove from favorites if already present
    } else {
      _favoriteProducts.add(product); // Add to favorites if not present
    }
    notifyListeners(); // Notify listeners to update UI
  }

  // Checks if a product is in favorites
  bool isFavorite(Product product) {
    return _favoriteProducts.contains(product);
  }

  // Updates the product list after a new product is added
  void addNewProduct(Product newProduct) {
    _allProducts.add(newProduct); // Add the new product to the list
    notifyListeners(); // Notify listeners to update the product grid
  }
}
